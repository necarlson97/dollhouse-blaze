extends CellConnector

func forced_open():
	$RigidBody2D/WoodPlank.hide()
	$RigidBody2D/CollisionShape2D.disabled = true
