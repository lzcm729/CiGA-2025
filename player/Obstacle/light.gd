extends Node3D
class_name Lamp

var default_radius: float
var min_radius: float = 0.2
var shrink_rate: float = 1.0
var cylinder_mesh: CylinderMesh
var gone: bool = false

@onready var decal: MeshInstance3D = $Decal
@onready var light: SpotLight3D = $SpotLight3D

func _ready() -> void:
	if decal.mesh is CylinderMesh:
		cylinder_mesh = (decal.mesh as CylinderMesh).duplicate() as CylinderMesh
		decal.mesh = cylinder_mesh
		default_radius = cylinder_mesh.bottom_radius
	else:
		push_error("Decal mesh is not a CylinderMesh!")


func decrease_light(delta) -> void:
	if gone: return
	if cylinder_mesh.bottom_radius > min_radius:
		cylinder_mesh.bottom_radius = cylinder_mesh.bottom_radius - shrink_rate * delta
	else:
		print("Light is gone")
		decal.visible = false
		light.visible = false
		decal.queue_free()
		light.queue_free()
		gone = true
	
	
func increase_light(delta) -> void:
	if cylinder_mesh.bottom_radius < default_radius:
		cylinder_mesh.bottom_radius = cylinder_mesh.bottom_radius + shrink_rate * delta
