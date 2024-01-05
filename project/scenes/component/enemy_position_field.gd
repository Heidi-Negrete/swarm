extends Node2D

@onready var start_marker = $StartMarker
@onready var top_right_marker = $TopRightMarker
@onready var bottom_left_marker = $BottomLeftMarker
@onready var end_marker = $EndMarker
var _field_rect: Rect2


func _ready():
	_field_rect = Rect2(Vector2(start_marker.global_position), Vector2(end_marker.global_position))
	print(get_field_position())
	print(get_field_size())
	print(get_field_end())

func get_field_position():
	return _field_rect.position


func get_field_size():
	return _field_rect.size


func get_field_end():
	return _field_rect.end


func has_point(point: Vector2):
	return _field_rect.has_point(point)
