extends Control
class_name ShortcutPanel

@export var shortcut_template :PackedScene
@onready var container = $Container

func _ready():
  load_shortcut()

func load_shortcut():
  var user_shortcut_path := "C:/Users/"+ GlobalSettings.user_name +"/Desktop"
  var user_files = DirAccess.get_files_at(user_shortcut_path)
  for file_name in user_files:
    var file_path = user_shortcut_path + "/" + file_name
    var icon_path = extract_icon(file_name,user_shortcut_path)
    var new_shortcut = shortcut_template.instantiate() as ShortCutComponent
    new_shortcut.set_path(file_path,icon_path)
    container.add_child(new_shortcut)

  var public_shortcut_path := "C:/Users/Public/Desktop"
  var public_files = DirAccess.get_files_at(public_shortcut_path)
  for file_name in public_files:
    var file_path = public_shortcut_path + "/" + file_name
    var icon_path = extract_icon(file_name,public_shortcut_path)
    var new_shortcut = shortcut_template.instantiate() as ShortCutComponent
    new_shortcut.set_path(file_path,icon_path)
    container.add_child(new_shortcut)

func extract_icon(_file_name:String,_shortcut_path:String)->String:
  var file_path = _shortcut_path + "/" + _file_name
  var res_absolute_path = ProjectSettings.globalize_path("res://")
  var extraction_absolute_path = res_absolute_path+ "tools/extracticon.exe"
  if "." in _file_name:
    _file_name = _file_name.split(".")[0]
  var icon_path = res_absolute_path+'icons/'+_file_name+'.png'
  if not FileAccess.file_exists(icon_path):
    var final_execute_string =  extraction_absolute_path + ' "' + file_path + '" "' + icon_path + '"'
    OS.execute("cmd.exe",["/c",final_execute_string])
  return "res://icons/" + _file_name + ".png"
