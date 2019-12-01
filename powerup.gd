extends Area2D

var screensize = Vector2()


# Changes the scale of the powerup, fades it out using Modulate property, and starts animation timer
func _ready():
	$Tween.interpolate_property($AnimatedSprite, 'scale',
								$AnimatedSprite.scale,
								$AnimatedSprite.scale * 3, 0.3,
								Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)
								
	$Tween.interpolate_property($AnimatedSprite, 'modulate',
								Color(1, 1, 1, 1),
								Color(1, 1, 1, 0), 0.3,
								Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)
	$Timer.wait_time = rand_range(0.5, 1.5)
	$Timer.start()

# Removes powerup once picked up
# Sets monitoring to false so signal doesn't trigger if picked up during tweening
func pickup():
	monitoring = false
	$Tween.start()


# Deletes powerup when tween is finished
func _on_Tween_tween_completed(object, key):
	queue_free()


# Powerup has been picked up
func _on_Powerup_area_entered(area):
	if area.is_in_group("obstacles"):
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))


# Powerup disappears after timer expires
func _on_Lifetime_timeout():
	queue_free()


func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()
