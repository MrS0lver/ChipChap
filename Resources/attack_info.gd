class_name AttackInfo
extends Resource

@export var demage: int
@export var attack_type: AttackType

enum AttackType {
	Phisical,
	Direct
}
const	PHISICAL: = AttackType.Phisical
const	DIRECT: = AttackType.Direct

var from: Node
