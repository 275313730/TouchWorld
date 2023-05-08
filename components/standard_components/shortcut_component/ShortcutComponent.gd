extends StandardComponent
class_name ShortCutComponent

@export var shortcut_template :PackedScene
@onready var container = $Container

var shortcut_size = Property.new("shortcut_size","图标大小",40.0)

var selected_panel:=false
var shortcuts :Array[Dictionary]= []

func _init():
  create_icon_folder()

func _ready():
  description = "应用组件"

  properties = [shortcut_size]
  shortcut_size.value_changed.connect(change_shortcut_size)

  get_tree().root.files_dropped.connect(load_files)

func _input(event):
  if not GlobalSettings.edit_mode:return
  if event is InputEventMouseMotion:
    selected_panel = get_global_rect().has_point(event.position)

func load_files(_files:PackedStringArray):
  if GlobalSettings.edit_mode and selected_panel:
    for file_path in _files:
      var path_array = file_path.split("\\")
      var file_name = path_array[path_array.size()-1]
      if "." in file_name:
        file_name = file_name.split('.')[0]
      var icon_path = extract_icon(file_name,file_path)
      add_shortcut(file_path,file_name,icon_path)

func add_shortcut(_file_path:String,_file_name:String,_icon_path:String):
  if not FileAccess.file_exists(_file_path):return
  if not FileAccess.file_exists(_icon_path):extract_icon(_file_name,_file_path)
  var new_shortcut = shortcut_template.instantiate() as ShortcutFile
  container.add_child(new_shortcut)
  new_shortcut.set_path(_file_path,_icon_path)
  new_shortcut.set_deferred("size",Vector2(shortcut_size.value,shortcut_size.value))
  new_shortcut.delete.connect(remove_shorcut)
  shortcuts.append({file_path=_file_path,file_name=_file_name,icon_path=_icon_path})
  GlobalSettings.save_data()

func remove_shorcut(_shortcut:ShortcutFile):
  for i in shortcuts.size():
    var shortcut = shortcuts[i]
    if shortcut["file_path"] != _shortcut.path:continue
    shortcuts.remove_at(i)
    container.remove_child(_shortcut)
    _shortcut.queue_free()

func extract_icon(_file_name:String,_file_path:String)->String:
  var icon_dir = ProjectSettings.globalize_path("user://icons")
  var res_absolute_path = ProjectSettings.globalize_path("res://")
  var extraction_absolute_path = res_absolute_path+ "tools/extracticon.exe"
  if "." in _file_name:
    _file_name = _file_name.split(".")[0]
  var icon_path = icon_dir+'/'+_file_name+'.png'
  if not FileAccess.file_exists(icon_path):
    var final_execute_string =  extraction_absolute_path + ' "' + _file_path + '" "' + icon_path + '"'
    OS.execute("cmd.exe",["/c",final_execute_string])
  return icon_path

func create_icon_folder():
  var icon_dir = ProjectSettings.globalize_path("user://icons")
  if DirAccess.dir_exists_absolute(icon_dir):return
  DirAccess.make_dir_absolute(icon_dir)

func change_shortcut_size(_old_value,_new_value):
  for shortcut in container.get_children():
    shortcut.set_deferred("size",Vector2(_new_value,_new_value))

func save_data()->Dictionary:
  var data = super()
  data["shortcuts"] = shortcuts
  return data

func load_data(_data:Dictionary):
  super(_data)
  for key in _data:
    var data = _data[key]
    if key != "shortcuts":continue
    for shortcut_data in data:
      add_shortcut(shortcut_data["file_path"],shortcut_data["file_name"],shortcut_data["icon_path"])
