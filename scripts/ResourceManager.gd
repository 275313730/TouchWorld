extends Node

var component_templates := {}
var backgrounds:Array[Texture2D] = []
var particles:Array[String] = []

func _init():
  load_components()
  load_backgrounds()
  load_particles()

func load_components():
  var dirs = DirAccess.get_directories_at("res://components")
  for dir in dirs:
    var files = DirAccess.get_files_at("res://components/"+dir)
    for file in files:
      if ".tscn" in file:
        var file_name = file.split(".")[0]
        component_templates[file_name] = load("res://components/"+dir+"/"+file)

func load_backgrounds():
  var dir_path = "res://assets/backgrounds"
  var background_files = DirAccess.get_files_at(dir_path)
  for background_name in background_files:
    if ".import" in background_name:continue
    if ".png" in background_name:
      var background = load(dir_path+ "/" +background_name) as Texture2D
      backgrounds.append(background)

func load_particles():
  var dir_path = "res://assets/particles"
  var particle_files = DirAccess.get_files_at(dir_path)
  for particle_name in particle_files:
    if ".import" in particle_name:continue
    if ".png" in particle_name:
      particles.append(dir_path+"/"+particle_name)
