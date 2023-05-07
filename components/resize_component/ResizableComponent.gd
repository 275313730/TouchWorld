extends Control
class_name ResizablePanel

@onready var right_drag = $RightDrag
@onready var left_drag = $LeftDrag
@onready var top_drag = $TopDrag
@onready var bottom_drag = $BottomDrag

var margin := 20.0
var direction := Vector2.ZERO
var can_move:= false
var pressed := false
var delay_change:=false
var last_position:= Vector2.ZERO

func _ready():
  mouse_entered.connect(func():can_move=true)
  mouse_exited.connect(func():can_move=false)
  right_drag.mouse_entered.connect(func():change_direction(Vector2.RIGHT))
  left_drag.mouse_entered.connect(func():change_direction(Vector2.LEFT))
  top_drag.mouse_entered.connect(func():change_direction(Vector2.UP))
  bottom_drag.mouse_entered.connect(func():change_direction(Vector2.DOWN))
  right_drag.mouse_exited.connect(func():change_direction(Vector2.ZERO))
  left_drag.mouse_exited.connect(func():change_direction(Vector2.ZERO))
  top_drag.mouse_exited.connect(func():change_direction(Vector2.ZERO))
  bottom_drag.mouse_exited.connect(func():change_direction(Vector2.ZERO))

func _process(_delta):
  if GlobalSettings.edit_mode:
    mouse_default_cursor_shape = Control.CURSOR_DRAG
    right_drag.mouse_default_cursor_shape = CURSOR_HSIZE
    left_drag.mouse_default_cursor_shape = CURSOR_HSIZE
    top_drag.mouse_default_cursor_shape = CURSOR_VSIZE
    bottom_drag.mouse_default_cursor_shape = CURSOR_VSIZE
  else:
    mouse_default_cursor_shape = Control.CURSOR_ARROW
    right_drag.mouse_default_cursor_shape = CURSOR_ARROW
    left_drag.mouse_default_cursor_shape = CURSOR_ARROW
    top_drag.mouse_default_cursor_shape = CURSOR_ARROW
    bottom_drag.mouse_default_cursor_shape = CURSOR_ARROW

func _input(event):
  if not GlobalSettings.edit_mode:return
  if event is InputEventMouseButton and event.button_index == 1:
    pressed = event.is_pressed()
  if not pressed:
    last_position = Vector2.ZERO
    if not delay_change:return
    direction = Vector2.ZERO
    delay_change = false
  if event is InputEventMouseMotion:
    if last_position == Vector2.ZERO:
      last_position = event.position
    var shift = event.position - last_position
    last_position = event.position
    if direction == Vector2.ZERO:
      if not can_move:return
      move(shift)
    else:
      resize(shift)

func move(_shift:Vector2):
  var final_position = get_parent().global_position + _shift
  if final_position.x <= 0 or final_position.y <= 0 :return
  if final_position.x + get_parent().size.x >= get_tree().root.size.x or final_position.y + get_parent().size.y >= get_tree().root.size.y:return
  get_parent().position = get_parent().position + _shift

func resize(_shift:Vector2):
  if direction == Vector2.RIGHT:
    get_parent().size += Vector2(_shift.x,0)
  elif direction == Vector2.LEFT:
    if get_parent().size.x - _shift.x <= get_parent().custom_minimum_size.x:return
    get_parent().size -= Vector2(_shift.x,0)
    move(Vector2(_shift.x,0))
  elif direction == Vector2.DOWN:
    get_parent().size += Vector2(0,_shift.y)
  elif direction == Vector2.UP:
    if get_parent().size.y - _shift.y <= get_parent().custom_minimum_size.y:return
    get_parent().size -= Vector2(0,_shift.y)
    move(Vector2(0,_shift.y))

func change_direction(_direction:Vector2):
  if not GlobalSettings.edit_mode:return
  if pressed:
    delay_change = true
    return
  direction= _direction
