extends Control
class_name Component

func save_data()->Dictionary:
  return {type=name,position=[position.x,position.y],size=[size.x,size.y]}

func load_data(_component_data:Dictionary):
  print(name)
  set_deferred("position",Vector2(_component_data["position"][0],_component_data["position"][1]))
  set_deferred("size",Vector2(_component_data["size"][0],_component_data["size"][1]))
