extends Control
class_name Main

@onready var components = $Components

func _ready():
  load_components()

func load_components():
  if GlobalSettings.components.size()>0:
    for component in components.get_children():
      components.remove_child(component)
      component.queue_free()

  for component_data in GlobalSettings.components:
    var component_type = component_data['type']
    if ResourceManager.component_templates.has(component_type):
      var component_template = ResourceManager.component_templates[component_type] as PackedScene
      var new_component = component_template.instantiate() as Component
      components.add_child(new_component)
      new_component.load_data(component_data)
