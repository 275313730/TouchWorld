extends Node

enum Particle_Mode{GPU,CPU}

var edit_mode:=false:
  set(value):
    edit_mode = value
    Notify.change_edit_mode.emit()

## 背景亮度
var background_brightness = Color(0.8,0.8,0.8,1)

var shortcut_size := 60.0

var user_name := OS.get_user_data_dir().split("/")[2]

var use_particle := true:
  set(value):
    use_particle = value
    Notify.change_particle.emit()

var particle_mode := Particle_Mode.CPU:
  set(value):
    particle_mode = value
    Notify.change_particle.emit()

var current_particle:Texture2D=load("res://assets/particles/defalut.png"):
  set(value):
    current_particle = value
    Notify.change_particle.emit()

func _init():
  current_particle = ResourceManager.particles[0]
