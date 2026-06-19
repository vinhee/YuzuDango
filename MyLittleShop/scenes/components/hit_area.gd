# this is the player's range(?)
# where the player's tool does damage
class_name HitArea
extends Area2D

# hit area's collision layer is 4 (Tool)
# mask is layer 5 (Object) bc the tool interacts w the objects

# default set to none first
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
# stores player's current equipped tool
# to compare with the objects damageable tool

@export var hit_damage: int = 1
