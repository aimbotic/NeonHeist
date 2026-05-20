class_name GameDirector
extends Node

signal alert_changed(level: int, meter: float)
signal lockdown_started

const MAX_ALERT_LEVEL := 4

var alert_level := 0
var alert_meter := 0.0
var elapsed := 0.0
var difficulty_pressure := 1.0

func reset() -> void:
	alert_level = 0
	alert_meter = 0.0
	elapsed = 0.0
	difficulty_pressure = 1.0
	alert_changed.emit(alert_level, alert_meter)

func tick(delta: float, player_heat: float) -> void:
	elapsed += delta
	var time_pressure: float = clamp(elapsed / 210.0, 0.0, 1.0)
	difficulty_pressure = 1.0 + time_pressure * 1.35 + player_heat * 0.45
	alert_meter += delta * (0.055 + time_pressure * 0.085 + player_heat * 0.02)

	if alert_meter >= 1.0 and alert_level < MAX_ALERT_LEVEL:
		alert_meter = 0.0
		alert_level += 1
		alert_changed.emit(alert_level, alert_meter)
		if alert_level == 3:
			lockdown_started.emit()
	else:
		alert_changed.emit(alert_level, alert_meter)

func add_heat(amount: float) -> void:
	alert_meter = clamp(alert_meter + amount, 0.0, 1.2)
	if alert_meter >= 1.0 and alert_level < MAX_ALERT_LEVEL:
		alert_meter = 0.0
		alert_level += 1
		alert_changed.emit(alert_level, alert_meter)
