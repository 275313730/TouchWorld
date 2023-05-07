extends Component
class_name Particle

@onready var gpu_particles_2d = $GPUParticles2D
@onready var cpu_particles_2d = $CPUParticles2D

var use_particle = GlobalSettings.use_particle
var current_mode = GlobalSettings.particle_mode
var current_particle_path = GlobalSettings.current_particle_path

func _ready():
  change_particle()

func _process(_delta:float):
  if use_particle != GlobalSettings.use_particle:
    change_particle()
    return

  if current_mode != GlobalSettings.particle_mode:
    current_mode = GlobalSettings.particle_mode
    change_particle()
    return

  if current_particle_path != GlobalSettings.current_particle_path:
    current_particle_path = GlobalSettings.current_particle_path
    change_particle()
    return

func change_particle():
  gpu_particles_2d.texture = load(current_particle_path)
  cpu_particles_2d.texture = load(current_particle_path)
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

