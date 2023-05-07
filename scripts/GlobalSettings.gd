extends Node

enum Particle_Mode{GPU,CPU}

var user_name := OS.get_user_data_dir().split("/")[2]

var shortcut_size := 60.0

var edit_mode:=false:
  set(value):
    edit_mode = value
    save_data()

var is_full_screen:=false:
  set(value):
    is_full_screen = value
    save_data()

## 背景亮度
var background_brightness := Color(0.8,0.8,0.8):
  set(value):
    background_brightness = value
    save_data()

## 是否进行背景轮换
var background_auto_change := true:
  set(value):
    background_auto_change = value
    save_data()

## 背景轮换时间
var background_change_time := 10.0:
  set(value):
    background_change_time = value
    save_data()

## 是否使用粒子
var use_particle := true:
  set(value):
    use_particle = value
    save_data()

## 粒子渲染模式
var particle_mode := Particle_Mode.CPU:
  set(value):
    particle_mode = value
    save_data()

## 当前粒子纹理路径
var current_particle_path:="res://assets/particles/defalut.png":
  set(value):
    current_particle_path = value
    save_data()

var components := []

var loading := false

func _ready():
  if FileAccess.file_exists("user://touch_world.dat"):
    load_data()
  else:
    save_data()

func load_data():
  loading = true
  var data_file = FileAccess.open("user://touch_world.dat",FileAccess.READ)
  var data = JSON.parse_string(data_file.get_as_text())
  var rgb = data["background_brightness"]
  background_brightness = Color(rgb[0],rgb[1],rgb[2])
  background_auto_change = data["background_auto_change"]
  background_change_time = data["background_change_time"]
  use_particle = data["use_particle"]
  particle_mode = data["particle_mode"]
  current_particle_path = data["current_particle_path"]
  components = data['components']
  data_file.close()
  loading = false

## 保存数据
func save_data():
  if loading :return
  var save_nodes = get_tree().get_nodes_in_group("Persist")
  var container = save_nodes[0]
  components = []
  for component in container.get_children():
    var data = component.save_data()
    components.append(data)

  var data_file = FileAccess.open("user://touch_world.dat",FileAccess.WRITE)

  var data = {
    background_brightness=[background_brightness.r,background_brightness.g,background_brightness.b],
    background_auto_change=background_auto_change,
    background_change_time=background_change_time,
    use_particle=use_particle,
    particle_mode=particle_mode,
    current_particle_path=current_particle_path,
    components=components
  }

  data_file.store_string(JSON.stringify(data))
  data_file.close()
