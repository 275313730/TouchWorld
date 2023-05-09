extends Component
class_name StandardComponent

var uid := randi()

var description := ""

var properties :Array[Property] = []

var loading:=false

func _ready():
  _on_ready()
  for property in properties:
    property.value_changed.connect(func(_old_value,_new_value):GlobalSettings.save_data())

func _on_ready():
  pass

func save_data()->Dictionary:
  var data = {type=name,description=description,uid=uid,position={x=position.x,y=position.y},size={x=size.x,y=size.y}}
  data.properties = get_properties()
  return data

func load_data(_data:Dictionary):
  uid = _data["uid"]
  set_deferred("position",Vector2(_data["position"].x,_data["position"].y))
  set_deferred("size",Vector2(_data["size"].x,_data["size"].y))
  set_properties(_data.properties)

func get_properties()->Array:
  var convert_properties = []
  for property in properties:
    convert_properties.append({key=property.key,description=property.description,value=property.value})
  return convert_properties

func set_properties(_convert_properties:Array):
  for convert_property in _convert_properties:
    for property in properties:
      if convert_property.key == property.key:
        property.value = convert_property.value
        break
