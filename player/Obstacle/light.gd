extends Node3D
class_name Lamp

var default_radius: float
var min_radius: float = 0.2
var shrink_rate: float = 0.5
var cylinder_mesh: CylinderMesh

var is_relighting := false
var draw : Draw

@onready var decal: MeshInstance3D = $Decal
@onready var light: SpotLight3D = $SpotLight3D

func _ready() -> void:
	if decal.mesh is CylinderMesh:
		cylinder_mesh = (decal.mesh as CylinderMesh).duplicate() as CylinderMesh
		decal.mesh = cylinder_mesh
		default_radius = cylinder_mesh.bottom_radius
	else:
		push_error("Decal mesh is not a CylinderMesh!")


func decrease_light(delta) -> bool:
	if cylinder_mesh.bottom_radius > min_radius:
		cylinder_mesh.bottom_radius = cylinder_mesh.bottom_radius - shrink_rate * delta
		return true
	else:
		print("Light is gone")
		#sound.play()
		decal.visible = false
		light.visible = false
		decal.queue_free()
		light.queue_free()
		return false
	
	
func increase_light(delta) -> bool:
	if cylinder_mesh.bottom_radius < default_radius:
		cylinder_mesh.bottom_radius = cylinder_mesh.bottom_radius + shrink_rate * delta
		return true
	else:
		return false


func Relight() -> void:
	is_relighting = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cylinder_mesh, "bottom_radius", default_radius, 0.2)
	tween.tween_callback(func():
		is_relighting = false
		if draw:
			draw.back_end.emit()
	)
