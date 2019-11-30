extends Node

var current_map: String
var entrance_id: int = -1
var player: Player = null

var spawn: bool = false

onready var MAPS: Dictionary = {
	"The Altar": 'res://src/worlds/altar.tscn',
	"The Outskirts": 'res://src/worlds/outskirts.tscn',
	"Caves of Sin": 'res://src/worlds/caves_of_sin.tscn'
}
onready var VISITED_MAPS: Dictionary = {}


func start_new_game():
	spawn = true
	load_map("The Altar") 

func go_to_map(map: String, entrance: int):
	entrance_id = entrance
	player = get_tree().current_scene.get_player(true)
	load_map(map)

func load_map(map: String):
	get_tree().change_scene('res://src/UI/main_screen_ui/loading_screen.tscn')
	var loader = ResourceLoader.load_interactive(MAPS[map])
	if VISITED_MAPS.has(map):
		var pack_scene = PackedScene.new()
		var packed_scene = pack_scene.pack(get_tree().current_scene)
		VISITED_MAPS[current_map] = pack_scene
		get_tree().change_scene_to(VISITED_MAPS[map])
		current_map = map
		return
	if loader.wait() == ERR_FILE_EOF:
		var pack_scene = PackedScene.new()
		var packed_scene = pack_scene.pack(get_tree().current_scene)
		VISITED_MAPS[current_map] = pack_scene
		get_tree().change_scene_to(loader.get_resource())
		current_map = map