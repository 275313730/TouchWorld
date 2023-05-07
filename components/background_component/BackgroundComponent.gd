extends Component
class_name BackgroundComponent

@onready var texture_rect = $TextureRect
@onready var texture_rect_2 = $TextureRect2

var auto_change_time := GlobalSettings.background_change_time
var current_texture := 1

func _ready():
  modulate = GlobalSettings.background_brightness
  texture_rect.texture = ResourceManager.backgrounds.pick_random()
  texture_rect_2.modulate = Color(0,0,0,0)

func _process(_delta:float):
  if ResourceManager.backgrounds.size() == 1:return
  if not GlobalSettings.background_auto_change:return
  auto_change_time -= _delta
  if auto_change_time > 0.0:return
  auto_change_time = GlobalSettings.background_change_time
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
