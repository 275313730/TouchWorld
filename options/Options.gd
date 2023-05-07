extends Control
class_name Options

@onready var basic_options = $BasicOptions
@onready var edit_mode = $BasicOptions/VBoxContainer/EditMode
@onready var background_setting = $BasicOptions/VBoxContainer/BackgroundSetting
@onready var particle_setting = $BasicOptions/VBoxContainer/ParticleSetting
@onready var full_screen = $BasicOptions/VBoxContainer/FullScreen
@onready var exit = $BasicOptions/VBoxContainer/Exit

@onready var particle_option = $ParticleOption

func _ready():
  edit_mode.pressed.connect(change_edit_mode)
  background_setting.pressed.connect(change_background_setting)
  particle_setting.pressed.connect(show_particle_option)
  full_screen.pressed.connect(change_screen)
  exit.pressed.connect(func():get_tree().quit())
  particle_option.back.connect(func():basic_options.show())

  change_text()

func _unhandled_key_input(event:InputEvent):
  if particle_option.visible:return
  if event.keycode == KEY_ESCAPE and not event.is_pressed():
    if visible == true:
      hide()
    else:
      show()

func change_edit_mode():
  GlobalSettings.edit_mode = !GlobalSettings.edit_mode
  change_text()

func show_particle_option():
  particle_option.show()
  basic_options.hide()

func change_background_setting():
  GlobalSettings.background_auto_change = !GlobalSettings.background_auto_change
  change_text()

func change_screen():
  GlobalSettings.is_full_screen = !GlobalSettings.is_full_screen
  if GlobalSettings.is_full_screen:
    get_window().mode = Window.MODE_FULLSCREEN
  else:
    get_window().mode = Window.MODE_WINDOWED
  change_text()

func change_text():
  if GlobalSettings.edit_mode:
    edit_mode.text = "- 编辑模式(已开启) -"
  else:
    edit_mode.text = "- 编辑模式(已关闭) -"

  if GlobalSettings.background_auto_change:
    background_setting.text = "- 背景轮换(已开启) -"
  else:
    background_setting.text = "- 背景轮换(已关闭) -"

  if GlobalSettings.is_full_screen:
    full_screen.text = "- 窗口化 -"
  else:
    full_screen.text = "- 全屏化 -"
