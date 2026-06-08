extends Node

const AIMBOTIC_SUPABASE_PROJECT_REF := "uotzmpttpekpkcjxurjj"
const AIMBOTIC_SUPABASE_URL := "https://uotzmpttpekpkcjxurjj.supabase.co"
const BLOCKED_SUPABASE_PROJECT_REFS: Array[String] = [
	"vaoqvtxqvbptyxddpoju",
]

const SUPABASE_URL_ENV := "SUPABASE_URL"
const SUPABASE_PUBLISHABLE_KEY_ENV := "SUPABASE_PUBLISHABLE_KEY"
const SUPABASE_ANON_KEY_ENV := "SUPABASE_ANON_KEY"

var supabase_url := ""
var supabase_key := ""
var supabase_enabled := false


func _ready() -> void:
	load_from_environment()


func load_from_environment() -> bool:
	var key := OS.get_environment(SUPABASE_PUBLISHABLE_KEY_ENV).strip_edges()
	if key.is_empty():
		key = OS.get_environment(SUPABASE_ANON_KEY_ENV).strip_edges()
	return configure(OS.get_environment(SUPABASE_URL_ENV), key)


func configure(candidate_url: String, candidate_key: String = "") -> bool:
	var clean_url := _normalize_url(candidate_url)
	if clean_url.is_empty():
		_disable_supabase()
		return false

	if not is_allowed_supabase_url(clean_url):
		push_error("Supabase disabled: URL must match Aimbotic project ref %s." % AIMBOTIC_SUPABASE_PROJECT_REF)
		_disable_supabase()
		return false

	supabase_url = clean_url
	supabase_key = candidate_key.strip_edges()
	supabase_enabled = not supabase_key.is_empty()
	return supabase_enabled


func is_allowed_supabase_url(candidate_url: String) -> bool:
	var clean_url := _normalize_url(candidate_url)
	for blocked_ref in BLOCKED_SUPABASE_PROJECT_REFS:
		if clean_url.contains(blocked_ref):
			return false
	return clean_url == AIMBOTIC_SUPABASE_URL


func is_connection_ready() -> bool:
	return supabase_enabled and supabase_url == AIMBOTIC_SUPABASE_URL and not supabase_key.is_empty()


func _normalize_url(candidate_url: String) -> String:
	var clean_url := candidate_url.strip_edges()
	while clean_url.ends_with("/"):
		clean_url = clean_url.trim_suffix("/")
	return clean_url


func _disable_supabase() -> void:
	supabase_url = ""
	supabase_key = ""
	supabase_enabled = false
