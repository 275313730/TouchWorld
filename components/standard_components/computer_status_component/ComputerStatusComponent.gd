extends StandardComponent
class_name ComputerStatusComponent

var cpu_name = OS.get_processor_name()
var cpu_count = OS.get_processor_count()

var gpu_name = OS.get_video_adapter_driver_info()

var fps = Performance.get_monitor(Performance.TIME_FPS)
var memory_dynamic = Performance.get_monitor(Performance.MEMORY_STATIC)
var memory_dynamic_max = Performance.get_monitor(Performance.MEMORY_STATIC_MAX)

var render_used = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)

func _ready():
  print(cpu_name,",",cpu_count)
  print(gpu_name)
