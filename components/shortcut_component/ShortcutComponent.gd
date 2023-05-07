extends TextureRect
class_name ShortCutComponent

@onready var button = $Button

var path := ""

func _ready():
  resize()
  button.mouse_entered.connect(func():modulate = Color(0.8,0.8,0.8,1))
  button.mouse_exited.connect(func():modulate = Color(1,1,1,1))
  button.pressed.connect(open_exe)

func set_path(_path:String,_icon_path:String):
  path = _path
  texture = load(_icon_path)

func resize():
  var target_size = Vector2(GlobalSettings.shortcut_size,GlobalSettings.shortcut_size)
  set_deferred("size",target_size)
  set_deferred("custom_minimum_size",target_size)
  button.set_deferred("size",target_size)
  button.set_deferred("custom_minimum_size",target_size)

func open_exe():
  if path == "":return

  if "lnk" in path:
    OS.execute("cmd.exe",["/c",path])
  else:
    OS.execute(path,[])
