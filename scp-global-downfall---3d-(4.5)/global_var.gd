extends Node

var walking : bool = false

var sprinting : bool = false

var hp : float = 100

var select_mode = ("settings")

var scene = ("test_map")

var loading_screen = preload("res://GUI/loading_screen.tscn")

var direction = ("forward")

var player_position : Vector3 = Vector3.ZERO

var takedown1 : bool = false

var takedown_cords : Vector3 = Vector3.ZERO

var takedown_dir : Vector3 = Vector3.ZERO

var key = 48291.374
