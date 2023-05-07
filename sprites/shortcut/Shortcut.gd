extends TextureRect
class_name ShortcutComponent

@onready var button = $Button

var path := ""

var dragging := false

func _ready():
  button.mouse_entered.connect(_on_mouse_entered)
  button.mouse_exited.connect(_on_mouse_exited)
  button.pressed.connect(open_exe)

func set_path(_path:String,_icon_path:String):
  path = _path
  texture = load(_icon_path)
  resize()

func resize():
  var target_size = Vector2(GlobalSettings.shortcut_size,GlobalSettings.shortcut_size)
  set_deferred("size",target_size)
  set_deferred("custom_minimum_size",target_size)
  button.set_deferred("size",target_size)
  button.set_deferred("custom_minimum_size",target_size)

func drag(_position:Vector2):
  global_position = _position

func drop():
  pass


func _on_mouse_entered():
  modulate = Color(0.8,0.8,0.8)

func _on_mouse_exited():
  modulate = Color(1,1,1)

func open_exe():
  if GlobalSettings.edit_mode:return
  if path == "":return
  if "exe" in path:
    OS.execute(path,[])
  else:
    OS.execute("cmd.exe",["/c",path])
