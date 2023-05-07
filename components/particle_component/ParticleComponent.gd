extends Node2D
class_name Particle

@onready var gpu_particles_2d = $GPUParticles2D
@onready var cpu_particles_2d = $CPUParticles2D

func _ready():
  change_particle()
  Notify.change_particle.connect(change_particle)

func change_particle():
  gpu_particles_2d.texture = GlobalSettings.current_particle
  cpu_particles_2d.texture = GlobalSettings.current_particle
  if not GlobalSettings.use_particle:
    gpu_particles_2d.hide()
    cpu_particles_2d.hide()
    return
  if GlobalSettings.particle_mode == GlobalSettings.Particle_Mode.GPU:
    gpu_particles_2d.show()
    cpu_particles_2d.hide()
  else:
    gpu_particles_2d.hide()
    cpu_particles_2d.show()

