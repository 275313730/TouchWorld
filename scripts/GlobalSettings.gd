extends Node

enum Particle_Mode{GPU,CPU}

var user_name := OS.get_user_data_dir().split("/")[2]

var edit_mode:=false

var component_setting:=false

var is_full_screen:=false

var components := []

func _ready():
  Notify.main_ready.connect(init)

func init():
  if FileAccess.file_exists("user://touch_world.dat"):
    load_data()
  else:
    save_data()

func save_data():
  var save_nodes = get_tree().get_nodes_in_group("Persist")
  var container = save_nodes[0]
  components = []
  for component in container.get_children():
    var data = component.save_data()
    components.append(data)
  var data_file = FileAccess.open("user://touch_world.dat",FileAccess.WRITE)

  var data = {
    is_full_screen=is_full_screen,
    components=components
  }
  data_file.store_string(JSON.stringify(data))
  data_file.close()

func load_data():
  var data_file = FileAccess.open("user://touch_world.dat",FileAccess.READ)
  var data = JSON.parse_string(data_file.get_as_text()) as Dictionary
  is_full_screen = data['is_full_screen']
  components = data['components']
  data_file.close()
