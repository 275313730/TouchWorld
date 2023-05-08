extends StandardComponent
class_name Particle

@onready var gpu_particles_2d = $GPUParticles2D
@onready var cpu_particles_2d = $CPUParticles2D

func _ready():
  properties = {
    enable=true,
    use_gpu=false,
    path="res://assets/particles/defalut.png"
  }

func _input(_event):
  if FileAccess.file_exists(properties.path):
    gpu_particles_2d.texture = load(properties.path)
    cpu_particles_2d.texture = load(properties.path)
  if not properties.enable:
    gpu_particles_2d.hide()
    cpu_particles_2d.hide()
    return
  if properties.use_gpu == true:
    gpu_particles_2d.show()
    cpu_particles_2d.hide()
  else:
    gpu_particles_2d.hide()
    cpu_particles_2d.show()
