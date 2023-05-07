extends TextureRect
class_name ShortcutFile

signal delete(node)

@onready var button = $Button
@onready var delete_button = $Delete

var path := ""
var enter := false

func _ready():
  button.mouse_entered.connect(_on_mouse_entered)
  button.mouse_exited.connect(_on_mouse_exited)
  button.pressed.connect(open_exe)
  delete_button.pressed.connect(func():delete.emit(self))
  resize()

func _input(_event):
  if GlobalSettings.edit_mode:
    delete_button.show()
  else:
    delete_button.hide()

func set_path(_path:String,_icon_path:String):
  path = _path
  var image = Image.load_from_file(_icon_path)
  texture = ImageTexture.create_from_image(image)

func resize():
  var target_size = Vector2(GlobalSettings.shortcut_size,GlobalSettings.shortcut_size)
  set_deferred("size",target_size)
  set_deferred("custom_minimum_size",target_size)
  button.set_deferred("size",target_size)
  button.set_deferred("custom_minimum_size",target_size)

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
