extends Component
class_name TimeComponent

@onready var time_display = $TimeDisplay

var time_passed := 0.0

func _ready():
  show_time()

func _process(_delta:float):
  time_passed += _delta
  if time_passed < 0.5:return
  time_passed -= 0.5
  show_time()

func show_time():
  var date_time = Time.get_datetime_dict_from_system()
  var year = get_format_string(date_time['year'])
  var month = get_format_string(date_time['month'])
  var day = get_format_string(date_time['day'])
  var date_string = year + "-" + month + "-" + day

  var hour = get_format_string(date_time['hour'])
  var minute = get_format_string(date_time['minute'])
  var second = get_format_string(date_time['second'])
  var time_string = hour + ":" + minute + ":" + second

  time_display.text = "[center]" + date_string + " " + time_string + "[/center]"

func get_format_string(_value:int)->String:
  if _value < 10:
    return "0" + str(_value)
  else:
    return str(_value)
