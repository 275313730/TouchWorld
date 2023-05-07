extends Node

var components:Array[String] = []

var particles:Array[Texture2D] = []

func _init():
  load_components()
  load_particles()

func load_components():
  var dirs = DirAccess.get_directories_at("res://components")
  for dir in dirs:
    var files = DirAccess.get_files_at("res://components/"+dir)
    for file in files:
      if ".tscn" in file:
        components.append(file)

func load_particles():
  var dir_path = "res://assets/particles"
  var particle_files = DirAccess.get_files_at(dir_path)
  for particle_file in particle_files:
    if ".import" in particle_file:continue
    if ".png" in particle_file:
      var particle_png = load(dir_path+"/"+particle_file) as Texture2D
      particles.append(particle_png)
