extends StandardComponent
class_name BackgroundComponent

@onready var texture_rect = $TextureRect
@onready var texture_rect_2 = $TextureRect2

var current_color := Color(0.8,0.8,0.8,1)
var current_time := 0.0
var current_texture := 1

func _ready():
  properties = {
    brightness=current_color.to_html(),
    auto_change=true,
    time=15.0
  }
  modulate = current_color
  texture_rect.texture = ResourceManager.backgrounds.pick_random()
  texture_rect_2.modulate = Color(0,0,0,0)

func _input(_event):
  if current_color.to_html() == properties["brightness"]:return
  if not Color.html_is_valid(properties["brightness"]):return
  current_color = Color.html(properties["brightness"])
  modulate = current_color

func _process(_delta:float):
  if ResourceManager.backgrounds.size() == 1:return
  if not properties["auto_change"]:return
  current_time += _delta
  if current_time < properties.time:return
  current_time = 0.0
  var tween = create_tween()
  var tween2 = create_tween()
  if current_texture == 1:
    current_texture = 2
    var new_background = ResourceManager.backgrounds.filter(func(_background:Texture2D):return _background != texture_rect.texture).pick_random()
    tween.tween_property(texture_rect,"modulate",Color(0,0,0,0),0.5)
    tween2.tween_property(texture_rect_2,"modulate",Color(1,1,1,1),0.5)
    texture_rect_2.texture = new_background
  else :
    current_texture = 1
    var new_background = ResourceManager.backgrounds.filter(func(_background:Texture2D):return _background != texture_rect_2.texture).pick_random()
    tween.tween_property(texture_rect_2,"modulate",Color(0,0,0,0),0.5)
    tween2.tween_property(texture_rect,"modulate",Color(1,1,1,1),0.5)
    texture_rect.texture = new_background
