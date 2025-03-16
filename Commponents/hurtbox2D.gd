@icon("res://addons/godottoolbelt/icons/hurtbox.svg")
class_name Hurtbox2D
extends Area2D

@onready var health: HealthCommponent = get_parent().get_node_or_null("HealthCommponent")

@export var eneble_iframes = false
@export var iframe_duration = 0.1

@export var debug = false

var enable = true

signal dmg_applied


func take_attack_info(attack_info: AttackInfo) -> AttackInfoResult:
	var result: = AttackInfoResult.new() 
	result.from = get_parent()
	if take_dmg(attack_info.demage, attack_info.attack_type):
		result.demage_applied = attack_info.demage
	return result


func take_dmg(dmg: int, source_demage: AttackInfo.AttackType) -> bool:
	if enable:
		if debug: print("taken dmg", dmg)
		health.take_dmg(dmg, source_demage)
		dmg_applied.emit()
		if eneble_iframes:
			enable = false
			get_tree().create_timer(iframe_duration).timeout.connect(func(): enable = true)
		return true
	return false
	

