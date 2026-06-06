const childProcess = require("child_process");
const fs = require("fs");
const http = require("http");
const net = require("net");
const os = require("os");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const buildDir = path.join(repoRoot, "build", "web");
const chromePath = process.argv[2] || "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe";
const host = "127.0.0.1";
const serverPort = Number(process.argv[3] || 9021);
const debugPort = Number(process.argv[4] || 9223);
const perfRoute = "/perf.html";

function contentType(filePath) {
	const ext = path.extname(filePath).toLowerCase();
	return {
		".html": "text/html; charset=utf-8",
		".js": "text/javascript; charset=utf-8",
		".wasm": "application/wasm",
		".pck": "application/octet-stream",
		".png": "image/png",
		".ico": "image/x-icon",
		".json": "application/json; charset=utf-8",
	}[ext] || "application/octet-stream";
}

function withIsolationHeaders(response, status, headers = {}) {
	response.writeHead(status, {
		"Cross-Origin-Opener-Policy": "same-origin",
		"Cross-Origin-Embedder-Policy": "require-corp",
		"Cross-Origin-Resource-Policy": "cross-origin",
		"Cache-Control": "no-store",
		...headers,
	});
}

function createServer() {
	return http.createServer((request, response) => {
		const requestUrl = new URL(request.url, `http://${host}:${serverPort}`);
		let filePath = path.join(buildDir, decodeURIComponent(requestUrl.pathname));
		if (requestUrl.pathname === "/") {
			filePath = path.join(buildDir, "index.html");
		}
		if (requestUrl.pathname === perfRoute) {
			const htmlPath = path.join(buildDir, "index.html");
			const html = fs.readFileSync(htmlPath, "utf8")
				.replace('"args":[]', '"args":["--dust-performance-test"]');
			withIsolationHeaders(response, 200, {"Content-Type": "text/html; charset=utf-8"});
			response.end(html);
			return;
		}
		const resolved = path.resolve(filePath);
		if (!resolved.startsWith(path.resolve(buildDir)) || !fs.existsSync(resolved) || fs.statSync(resolved).isDirectory()) {
			withIsolationHeaders(response, 404, {"Content-Type": "text/plain; charset=utf-8"});
			response.end("Not found");
			return;
		}
		withIsolationHeaders(response, 200, {"Content-Type": contentType(resolved)});
		fs.createReadStream(resolved).pipe(response);
	});
}

function wait(ms) {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

function getJson(url) {
	return new Promise((resolve, reject) => {
		http.get(url, (response) => {
			let body = "";
			response.on("data", (chunk) => body += chunk);
			response.on("end", () => {
				try {
					resolve(JSON.parse(body));
				} catch (error) {
					reject(error);
				}
			});
		}).on("error", reject);
	});
}

async function waitForDebuggerPage() {
	const deadline = Date.now() + 20000;
	while (Date.now() < deadline) {
		try {
			const pages = await getJson(`http://${host}:${debugPort}/json/list`);
			const page = pages.find((entry) => entry.type === "page" && entry.url.includes(perfRoute));
			if (page && page.webSocketDebuggerUrl) {
				return page.webSocketDebuggerUrl;
			}
		} catch (_) {
			// Chrome is still starting.
		}
		await wait(150);
	}
	throw new Error("Timed out waiting for Chrome DevTools page");
}

function createCdpClient(wsUrl) {
	let nextId = 1;
	const pending = new Map();
	const listeners = new Map();
	const socket = new WebSocket(wsUrl);
	socket.onmessage = (event) => {
		const message = JSON.parse(event.data);
		if (message.id && pending.has(message.id)) {
			const {resolve, reject} = pending.get(message.id);
			pending.delete(message.id);
			if (message.error) {
				reject(new Error(JSON.stringify(message.error)));
			} else {
				resolve(message.result);
			}
			return;
		}
		if (message.method && listeners.has(message.method)) {
			for (const listener of listeners.get(message.method)) {
				listener(message.params || {});
			}
		}
	};
	const opened = new Promise((resolve, reject) => {
		socket.onopen = resolve;
		socket.onerror = reject;
	});
	return {
		async send(method, params = {}) {
			await opened;
			const id = nextId++;
			const payload = JSON.stringify({id, method, params});
			const result = new Promise((resolve, reject) => pending.set(id, {resolve, reject}));
			socket.send(payload);
			return result;
		},
		on(method, listener) {
			if (!listeners.has(method)) {
				listeners.set(method, []);
			}
			listeners.get(method).push(listener);
		},
		close() {
			socket.close();
		},
	};
}

async function waitForPortFree(port) {
	return new Promise((resolve, reject) => {
		const tester = net.createServer()
			.once("error", reject)
			.once("listening", () => tester.close(resolve))
			.listen(port, host);
	});
}

async function evaluateWithContextRetry(cdp, params) {
	const deadline = Date.now() + 10000;
	let lastError = null;
	while (Date.now() < deadline) {
		try {
			return await cdp.send("Runtime.evaluate", params);
		} catch (error) {
			lastError = error;
			if (!String(error.message).includes("execution context")) {
				throw error;
			}
			await wait(150);
		}
	}
	throw lastError || new Error("Timed out waiting for browser execution context");
}

async function main() {
	if (!fs.existsSync(chromePath)) {
		throw new Error(`Chrome executable not found: ${chromePath}`);
	}
	if (!fs.existsSync(path.join(buildDir, "index.html"))) {
		throw new Error(`Web export missing: ${path.join(buildDir, "index.html")}`);
	}
	await waitForPortFree(serverPort);
	await waitForPortFree(debugPort);

	const server = createServer();
	await new Promise((resolve) => server.listen(serverPort, host, resolve));

	const userDataDir = fs.mkdtempSync(path.join(os.tmpdir(), "dust-heist-browser-perf-"));
	const chrome = childProcess.spawn(chromePath, [
		"--headless=new",
		`--remote-debugging-port=${debugPort}`,
		`--user-data-dir=${userDataDir}`,
		"--disable-background-timer-throttling",
		"--disable-renderer-backgrounding",
		"--disable-dev-shm-usage",
		"--no-first-run",
		"--no-default-browser-check",
		`http://${host}:${serverPort}${perfRoute}?browser_perf=1`,
	], {stdio: "ignore"});

	let cdp;
	try {
		const wsUrl = await waitForDebuggerPage();
		cdp = createCdpClient(wsUrl);
		let gamePerfLine = "";
		cdp.on("Runtime.consoleAPICalled", (params) => {
			const text = (params.args || []).map((arg) => arg.value || arg.description || "").join(" ");
			if (text.includes("DUST_PERF:")) {
				gamePerfLine = text;
			}
		});
		await cdp.send("Runtime.enable");
		await cdp.send("Page.enable");
		await evaluateWithContextRetry(cdp, {
			awaitPromise: true,
			returnByValue: true,
			expression: `new Promise((resolve) => {
				const started = performance.now();
				const waitForCanvas = () => {
					const canvas = document.getElementById("canvas");
					if (canvas && canvas.width > 0 && canvas.height > 0) {
						let warm = 60;
						let remaining = 240;
						let last = performance.now();
						let sum = 0;
						let max = 0;
						let minFps = Infinity;
						const tick = (now) => {
							const dt = Math.max(0.001, now - last);
							last = now;
							if (warm > 0) {
								warm -= 1;
							} else {
								sum += dt;
								max = Math.max(max, dt);
								minFps = Math.min(minFps, 1000 / dt);
								remaining -= 1;
							}
							if (remaining > 0) {
								requestAnimationFrame(tick);
							} else {
								const samples = 240;
								resolve({
									samples,
									avgFps: 1000 / (sum / samples),
									minFps,
									worstFrameMs: max,
									canvasWidth: canvas.width,
									canvasHeight: canvas.height,
									elapsedMs: performance.now() - started
								});
							}
						};
						requestAnimationFrame(tick);
					} else if (performance.now() - started > 60000) {
						resolve({samples: 0, avgFps: 0, minFps: 0, worstFrameMs: 0, canvasWidth: 0, canvasHeight: 0, elapsedMs: performance.now() - started});
					} else {
						setTimeout(waitForCanvas, 100);
					}
				};
				waitForCanvas();
			})`,
		}).then((result) => {
			const value = result.result.value;
			if (!value || value.samples <= 0) {
				throw new Error("Browser FPS sampler did not collect frames");
			}
			if (value.avgFps < 45 || value.minFps < 30 || value.worstFrameMs > 80) {
				throw new Error(`Browser FPS gate failed: avg=${value.avgFps.toFixed(1)} min=${value.minFps.toFixed(1)} worst=${value.worstFrameMs.toFixed(1)}ms`);
			}
			console.log(`DUST_BROWSER_PERF: PASS samples=${value.samples} avg_fps=${value.avgFps.toFixed(1)} min_fps=${value.minFps.toFixed(1)} worst_frame_ms=${value.worstFrameMs.toFixed(1)} canvas=${value.canvasWidth}x${value.canvasHeight} elapsed_ms=${value.elapsedMs.toFixed(1)}`);
		});

		const perfDeadline = Date.now() + 12000;
		while (Date.now() < perfDeadline && gamePerfLine === "") {
			await wait(250);
		}
		if (gamePerfLine !== "") {
			console.log(gamePerfLine);
		}
	} finally {
		if (cdp) {
			cdp.close();
		}
		chrome.kill();
		server.close();
		for (let attempt = 0; attempt < 5; attempt += 1) {
			try {
				fs.rmSync(userDataDir, {recursive: true, force: true});
				break;
			} catch (_) {
				await wait(200);
			}
		}
	}
}

main().catch((error) => {
	console.error(`DUST_BROWSER_PERF: FAIL ${error.message}`);
	process.exit(1);
});
