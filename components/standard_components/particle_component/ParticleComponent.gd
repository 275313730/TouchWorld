extends StandardComponent
class_name Particle

@onready var gpu_particles_2d = $GPUParticles2D
@onready var cpu_particles_2d = $CPUParticles2D

var gpu_mode:=false

func _ready():
  description = "粒子组件"

  var enable = Property.new("enable","开启粒子效果",true)
  var use_gpu = Property.new("use_gpu","启用GPU渲染",gpu_mode)
  var path = Property.new("path","粒子图片路径","res://assets/particles/defalut.png")
  properties = [enable,use_gpu,path]
  enable.value_changed.connect(change_status)
  use_gpu.value_changed.connect(func(_old_value,_new_value):gpu_mode=_new_value;change_mode())
  path.value_changed.connect(change_path)


func change_path(_old_value,_new_value):
  if FileAccess.file_exists(_new_value):
    gpu_particles_2d.texture = load(_new_value)
    cpu_particles_2d.texture = load(_new_value)

func change_status(_old_value,_new_value):
  if _new_value:
    change_mode()
  else:
    gpu_particles_2d.hide()
    cpu_particles_2d.hide()

func change_mode():
  if gpu_mode:
    gpu_particles_2d.show()
    cpu_particles_2d.hide()
  else:
    gpu_particles_2d.hide()
    cpu_particles_2d.show()
