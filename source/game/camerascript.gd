extends Camera2D

func shake(strength: float = 10.0, count: int = 5):
	var tween = create_tween()
	for i in count:
		var shake_a: Vector2 = Vector2(randf_range(-strength, strength), randf_range(-strength, strength))
		tween.tween_property(self, "offset", shake_a, 0.05)
	tween.tween_property(self, "offset", Vector2.ZERO, 0.05)

func flash(color: Color = Color.DARK_RED):
	print("Screen Flash")
	var tween = create_tween()
	tween.tween_property($Flash, "modulate", color, 0.1)
	tween.tween_property($Flash, "modulate", Color(0, 0, 0, 0), 0.1)
