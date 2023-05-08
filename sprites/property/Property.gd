extends Node
class_name Property

signal value_changed(old_value,new_value)

var key:String
var description:String
var value:
  set(new_value):
    var old_value = value
    value = new_value
    value_changed.emit(old_value,new_value)

func _init(_key:String,_description:String,_value):
  key = _key
  description = _description
  value = _value
