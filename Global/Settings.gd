extends Node

var is_mobile = false

#func _ready() -> void:
	#GlobalButton.visible = true
	#if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		#is_mobile = true
		#GlobalButton.visible = true 
