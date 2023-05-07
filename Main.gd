extends Control

@onready var background_image = $BackgroundImage
@onready var options = $Options
@onready var back = $Options/VBoxContainer/Back
@onready var edit_mode = $Options/VBoxContainer/EditMode
@onready var particle_setting = $Options/VBoxContainer/ParticleSetting
@onready var background_setting = $Options/VBoxContainer/BackgroundSetting
@onready var exit = $Options/VBoxContainer/Exit

@onready var particle_option = $ParticleOption

func _ready():
  background_image.modulate = GlobalSettings.background_brightness
  back.pressed.connect(func():options.hide())
  edit_mode.pressed.connect(func():GlobalSettings.edit_mode = !GlobalSettings.edit_mode)
  particle_setting.pressed.connect(func():particle_option.show();options.hide())
  background_setting.pressed.connect(func():pass)
  exit.pressed.connect(func():get_tree().quit())

  Notify.change_edit_mode.connect(change_edit_mode)
  Notify.back.connect(func():options.show())

func _unhandled_key_input(event:InputEvent):
  if event.keycode == KEY_ESCAPE and not event.is_pressed():
    if options.visible == true:
      options.hide()
    else:
      options.show()

func change_edit_mode():
  if GlobalSettings.edit_mode:
    edit_mode.text = "- 编辑模式(已开启) -"
  else:
    edit_mode.text = "- 编辑模式(已关闭) -"
