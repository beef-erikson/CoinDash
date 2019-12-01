extends Area2D

var screensize = Vector2()


# Changes the scale of the coin, fades it out using Modulate property, and starts animation timer
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
	$Timer.wait_time = rand_range(2, 5)
	$Timer.start()


# Removes coin once picked up
# Sets monitoring to false so signal doesn't trigger if picked up during tweening
func pickup():
	monitoring = false
	$Tween.start()


# Deletes coin when tween is finished
func _on_Tween_tween_completed(object, key):
	queue_free()


# Starts coin animation
func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()


func _on_coin_area_entered(area):
	if area.is_in_group("obstacles"):
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
