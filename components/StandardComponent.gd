extends Component
class_name StandardComponent

var uid := randi()

var properties := {}

var loading:=false

func _init():
  Notify.change_property.connect(change_property)

func change_property(_uid:int,_key:String,_value):
  if uid != _uid:return
  properties[_key] = _value
  GlobalSettings.save_data()

func save_data()->Dictionary:
  var data = {type=name,uid=uid,position={x=position.x,y=position.y},size={x=size.x,y=size.y}}
  data.properties = get_properties()
  return data

func load_data(_data:Dictionary):
  uid = _data["uid"]
  set_deferred("position",Vector2(_data["position"].x,_data["position"].y))
  set_deferred("size",Vector2(_data["size"].x,_data["size"].y))
  set_properties(_data.properties)

func get_properties()->Dictionary:
  properties.uid = uid
  return properties

func set_properties(_properties:Dictionary):
  for key in _properties:
    properties[key] = _properties[key]
