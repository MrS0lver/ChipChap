@tool
class_name InGamePopUp
extends Area2D

## Add RichTextLabel and ColishionShape2D 
## change text value to your desiried text

## put your text here
@export_multiline var text: String:
	set(val):
		text = val	
		if is_instance_valid(text_box):
			text_box.text = text
@export var trigger_group: String
## Use it to disabel visibility of text in editor
@export_tool_button("Show", "Callable") var show_in_engine: Callable = _show_in_engine

@onready var text_box: RichTextLabel = $RichTextLabel

var _show: bool = true:
	set(val):
		_show = val
		if is_instance_valid(text_box):
			text_box.visible = _show

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if !Engine.is_editor_hint():
		_show = false
	print(_show)
	
func _show_in_engine() -> void:
	_show = !_show

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(trigger_group):
		_show = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group(trigger_group):
		_show = false
