extends Node

signal score_updated(new_score:int)
signal player_took_damage(distance_traveled:float)

var score = 0
var last_landed_position = Vector3.ZERO
var player
var distance_threshold = 2
var max_distance = 25

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	score_updated.connect(test_score)
	player_took_damage.connect(damage_test)

func _on_player_landed():
	var distance_traveled = abs(last_landed_position.y - player.transform.origin.y)
	if distance_traveled > distance_threshold:
		if distance_traveled > max_distance:
			emit_signal("player_took_damage", distance_traveled)
		else:
			score += 1
			emit_signal("score_updated", score)
	last_landed_position = player.transform.origin
		
func test_score(new_score: int):
	print("Score: " + str(new_score))
	
func damage_test(distance_traveled: float):
	print("Player died or something yo")
