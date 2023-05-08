extends BasicComponent
class_name ResizeComponent

@export var use_resize:=true
@export var use_move:=true

@onready var right_drag = $RightDrag
@onready var left_drag = $LeftDrag
@onready var top_drag = $TopDrag
@onready var bottom_drag = $BottomDrag

var action := -1
var direction := Vector2.ZERO
var pressed := false
var last_position:= Vector2.ZERO

func _ready():
  right_drag.mouse_entered.connect(func():change_direction(Vector2.RIGHT))
  left_drag.mouse_entered.connect(func():change_direction(Vector2.LEFT))
  top_drag.mouse_entered.connect(func():change_direction(Vector2.UP))
  bottom_drag.mouse_entered.connect(func():change_direction(Vector2.DOWN))
  right_drag.mouse_exited.connect(func():change_direction(Vector2.ZERO))
  left_drag.mouse_exited.connect(func():change_direction(Vector2.ZERO))
  top_drag.mouse_exited.connect(func():change_direction(Vector2.ZERO))
  bottom_drag.mouse_exited.connect(func():change_direction(Vector2.ZERO))

func _input(event):
  check_edit_mode()

  if not GlobalSettings.edit_mode:return

  if event is InputEventMouseButton and event.button_index == 1:
    if event.is_pressed():
      if direction != Vector2.ZERO:
        action = 1
      elif get_global_rect().has_point(event.position):
        action = 0
    else:
      last_position = Vector2.ZERO
      direction = Vector2.ZERO
      action = -1

  if action == -1:return

  if event is InputEventMouseMotion:
    if last_position == Vector2.ZERO:
      last_position = event.position
    var shift = event.position - last_position
    last_position = event.position
    if action == 0:
      if not use_move:return
      move(shift)
    elif action == 1:
      if not use_resize:return
      resize(shift)

func check_edit_mode():
  if GlobalSettings.edit_mode:
    if use_move:
      mouse_default_cursor_shape = Control.CURSOR_DRAG
    if use_resize:
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

func move(_shift:Vector2):
  var final_position = get_parent().global_position + _shift
  if final_position.x <= 0 :
    var final_x = -get_parent().global_position.x
    _shift = Vector2(final_x,_shift.y)
  if final_position.y <= 0 :
    var final_y = -get_parent().global_position.y
    _shift = Vector2(_shift.x,final_y)
  if final_position.x + get_parent().size.x >= get_tree().root.size.x:
    var final_x = get_tree().root.size.x - get_parent().size.x - get_parent().global_position.x
    _shift = Vector2(final_x,_shift.y)
  if final_position.y + get_parent().size.y >= get_tree().root.size.y:
    var final_y = get_tree().root.size.y - get_parent().size.y - get_parent().global_position.y
    _shift = Vector2(_shift.x,final_y)
  get_parent().position = get_parent().position + _shift

func resize(_shift:Vector2):
  if direction == Vector2.RIGHT:
    if get_parent().global_position.x + _shift.x + get_parent().size.x >= get_tree().root.size.x:return
    get_parent().size.x += _shift.x

  if direction == Vector2.LEFT:
    if get_parent().size.x - _shift.x < get_parent().custom_minimum_size.x:
      _shift = Vector2(get_parent().size.x - get_parent().custom_minimum_size.x,0)
    move(Vector2(_shift.x,0))
    get_parent().size.x -= _shift.x

  if direction == Vector2.DOWN:
    if get_parent().global_position.y + _shift.y + get_parent().size.y >= get_tree().root.size.y:return
    get_parent().size.y += _shift.y

  if direction == Vector2.UP:
    if get_parent().size.y - _shift.y < get_parent().custom_minimum_size.y:
      _shift = Vector2(0,get_parent().size.y - get_parent().custom_minimum_size.y)
    move(Vector2(0,_shift.y))
    get_parent().size.y -= _shift.y


func change_direction(_direction:Vector2):
  if not GlobalSettings.edit_mode:return
  if action!=-1:return
  direction= _direction
