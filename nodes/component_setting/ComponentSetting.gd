extends Control
class_name ComponentSetting

@onready var property_container = $PropertyPanel/PropertyContainer
@onready var component_container = $SelectPanel/ComponentContainer

func _ready():
 Notify.switch_setting.connect(func(status:bool):if status:load_components() else:hide())

func load_components():
  show()
  for child in component_container.get_children():
    component_container.remove_child(child)
    child.queue_free()

  for data in GlobalSettings.components:
    var new_select = Button.new()
    new_select.text = data.description
    new_select.pressed.connect(func():load_properties(data.uid,data.properties))
    component_container.add_child(new_select)

func load_properties(_uid:int,_properties:Array):
  for line in property_container.get_children():
    property_container.remove_child(line)
    line.queue_free()

  for property in _properties:
    var line = create_property_line(property.description)
    var value = property.value

    if typeof(value) == TYPE_STRING:
      var input = create_input(value)
      input.text_changed.connect(func(_text):change_property(_uid,property,_text))
      line.add_child(input)

    if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
      var spin = create_spin(value)
      spin.value_changed.connect(func(_value):change_property(_uid,property,_value))
      line.add_child(spin)

    if typeof(value) == TYPE_BOOL:
      var check = create_check_button(value)
      check.pressed.connect(func():change_property(_uid,property,check.button_pressed))
      line.add_child(check)

    property_container.add_child(line)

func create_property_line(_key:String)->HBoxContainer:
  var container = HBoxContainer.new()
  var label = Label.new()
  label.text = _key
  container.add_child(label)
  return container

func create_input(_value:String)->LineEdit:
  var input = LineEdit.new()
  input.expand_to_text_length = true
  input.context_menu_enabled = false
  input.text = _value
  return input

func create_spin(_value:float)->SpinBox:
  var spin = SpinBox.new()
  spin.value = _value
  return spin

func create_check_button(_value:bool)->CheckButton:
  var check = CheckButton.new()
  check.button_pressed = _value
  return check

func change_property(_uid:int,_property:Dictionary,_value):
  _property.value = _value
  Notify.change_property.emit(_uid,_property.key,_value)
