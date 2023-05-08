extends Panel
class_name Options

@onready var edit_mode = $VBoxContainer/EditMode
@onready var component_setting = $VBoxContainer/ComponentSetting
@onready var full_screen = $VBoxContainer/FullScreen
@onready var exit = $VBoxContainer/Exit

func _ready():
  edit_mode.pressed.connect(func():change_edit_mode(true))
  full_screen.pressed.connect(change_screen)
  component_setting.pressed.connect(func():enter_component_setting(true))
  exit.pressed.connect(func():GlobalSettings.save_data();get_tree().quit())

  change_text()

func _unhandled_key_input(event:InputEvent):
  if event.keycode == KEY_ESCAPE and not event.is_pressed():
    change_edit_mode(false)
    enter_component_setting(false)
    if visible == true:
      hide()
    else:
      show()

func change_edit_mode(_status:bool):
  GlobalSettings.edit_mode = _status
  if _status:
    hide()

func change_screen():
  GlobalSettings.is_full_screen = !GlobalSettings.is_full_screen
  if GlobalSettings.is_full_screen:
    get_window().mode = Window.MODE_FULLSCREEN
  else:
    get_window().mode = Window.MODE_WINDOWED
  change_text()

func enter_component_setting(_status:bool):
  GlobalSettings.component_setting = _status
  Notify.switch_setting.emit(_status)
  if _status:
    hide()

func change_text():
  if GlobalSettings.edit_mode:
    edit_mode.text = "- 布局模式 -"
  else:
    edit_mode.text = "- 布局模式 -"

  if GlobalSettings.is_full_screen:
    full_screen.text = "- 窗口模式 -"
  else:
    full_screen.text = "- 全屏模式 -"
