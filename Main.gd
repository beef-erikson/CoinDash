extends Node2D

export (PackedScene) var coin
export (PackedScene) var Powerup
export (int) var playtime

var level
var score
var time_left
var screensize
var playing = false


# Intialization of screensize and loads player, making it invisible
func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()


# Checks if all coins have been collected to proceed to next level; spawns powerups
func _process(delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$PowerupTimer.wait_time = rand_range(5, 10)
		$PowerupTimer.start()


# Initialization for starting a new game, sets starting variables and shows the player
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)


# Spawns coins in a random position based on the level - the higher the level, the more coins
func spawn_coins():
	for i in range(4 + level):
		var c = coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
	$LevelSound.play()


# On timer tick, subtract 1 and update title. 'Game Over' when timer is 0 (or less)
func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


# Game Over if player is hurt
func _on_Player_hurt():
	game_over()


# On coin pickup, add to score and update HUD. On powerup, add to timer, play sound and update HUD
func _on_Player_pickup(type):
	match type:
		"coin":
			score += 1
			$CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$PowerupSound.play()
			$HUD.update_timer(time_left)


# Game Over function; stops timer, frees all coins, trigger hud game over and player dies
func game_over():
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()


# Spawns a powerup
func _on_PowerupTimer_timeout():
	var p = Powerup.instance()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
