extends Control
class_name ParticleOption

signal back()

@onready var particle_preview = $ParticlePreview
@onready var change_status = $ChangeStatus
@onready var change_mode = $ChangeMode
@onready var back_button = $Back

func _ready():
  load_particles()
  change_text()

  change_status.pressed.connect(change_particle_status)
  change_mode.pressed.connect(change_particle_mode)
  back_button.pressed.connect(func():hide();back.emit())

func load_particles():
  for particle_png in ResourceManager.particles:
    var particle_texture = TextureRect.new()
    particle_texture.texture = load(particle_png)
    var texture_size = Vector2(size.y,size.y)
    particle_texture.custom_minimum_size = texture_size
    particle_texture.size = texture_size
    particle_preview.add_child(particle_texture)

    var button = Button.new()
    particle_texture.add_child(button)
    button.custom_minimum_size = texture_size
    button.size = texture_size
    button.modulate = Color(1,1,1,0.2)
    button.pressed.connect(func():GlobalSettings.current_particle_path=particle_png)

func change_particle_status():
  GlobalSettings.use_particle = !GlobalSettings.use_particle
  change_text()

func change_particle_mode():
  if GlobalSettings.particle_mode == GlobalSettings.Particle_Mode.CPU:
    GlobalSettings.particle_mode = GlobalSettings.Particle_Mode.GPU
  else:
    GlobalSettings.particle_mode = GlobalSettings.Particle_Mode.CPU
  change_text()

func change_text():
  if GlobalSettings.use_particle:
    change_status.text = "已开启"
  else:
    change_status.text = "已关闭"
  if GlobalSettings.particle_mode == GlobalSettings.Particle_Mode.CPU:
    change_mode.text = "GPU"
  else:
    change_mode.text = "CPU"
