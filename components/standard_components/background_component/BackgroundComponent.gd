extends StandardComponent
class_name BackgroundComponent

@onready var texture_rect = $TextureRect
@onready var texture_rect_2 = $TextureRect2

var brightness = Property.new("brightness","背景亮度",Color(0.8,0.8,0.8,1))
var auto_change = Property.new("auto_change","背景轮换",true)
var time = Property.new("time","轮换时间",15.0)

var current_color := Color(0.8,0.8,0.8,1)
var current_time := 0.0
var current_texture := 1

func _on_ready():
  description = "背景组件"

  properties = [brightness,auto_change,time]
  brightness.value_changed.connect(change_modulate)

  modulate = current_color
  texture_rect.texture = ResourceManager.backgrounds.pick_random()
  texture_rect_2.modulate = Color(0,0,0,0)

func _process(_delta:float):
  if ResourceManager.backgrounds.size() == 1:return
  if not auto_change.value:return
  if not cal_time(_delta):return
  change_background()

func cal_time(_delta:float)->bool:
  current_time += _delta
  if current_time < time.value:return false
  current_time = 0.0
  return true

func change_background():
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

func change_modulate(_old_value,_new_value):
  if not Color.html_is_valid(_new_value):return
  current_color = Color.html(_new_value)
  modulate = current_color
