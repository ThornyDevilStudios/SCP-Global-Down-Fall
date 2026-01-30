extends Area3D

@onready var hitbox = $"."

# Mindestwert für HP (Schwellenwert, um extrem kleine Reste zu ignorieren)
var min_hp = 0.01  # Schwellenwert für "praktisch tot"

func _on_area_entered(area):
	if area.is_in_group("player"):
		print("Damage to Player")
		var decrypted_hp = GlobalVar.hp / GlobalVar.key
		decrypted_hp -= 20
		if decrypted_hp <= min_hp:
			decrypted_hp = 0 
		GlobalVar.hp = decrypted_hp * GlobalVar.key
