extends CanvasLayer

signal start_game


# Updates the score GUI value (top left)
func update_score(value):
	$MarginContainer/ScoreLabel.text = str(value)


# Updates the timer GUI value (top right)
func update_timer(value):
	$MarginContainer/TimerLabel.text = str(value)


# Display title message and start the timer
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


# Hides the title message when timer expires
func _on_MessageTimer_timeout():
	$MessageLabel.hide()


# Emits start_game signal on button press, starting the game
func _on_StartButton_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	emit_signal("start_game")


# Shows 'Game Over' message when game ends, unhides button and game title
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$StartButton.show()
	$MessageLabel.text = "Coin Dash!"
	$MessageLabel.show()
