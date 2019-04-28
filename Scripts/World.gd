extends Node

var unit: PackedScene = preload("res://Scenes/Player.tscn")

# Number of civilization in the game
export (int) var civ_num: int
# Array containing each civilization with their nodes
var civs: Array
# Cells in the tileset used in $Map:  0 = Water / 1 = Ground
enum {WATER, GROUND}
# Currently playing civilization
var current_civ: Node
# Currently playing unit
var current_unit: Node

func _ready() -> void:
	randomize()
	init_civilizations(civ_num)
	init_units()
	start_turn()

# For each civilization, initialize their nodes
# Civ01 / Cities / Units in which every building and units are going to be added
func init_civilizations(number_of_civs: int) -> void:
	for i in number_of_civs:
		var civ_node: Node = Node.new()
		civ_node.name = "Civ" + str(i)
		add_child(civ_node)
		civs.append(civ_node)
		
		var civ_cities: Node = Node.new()
		civ_cities.name = "Cities"
		civ_node.add_child(civ_cities)
		
		var civ_units: Node = Node.new()
		civ_units.name = "Units"
		civ_units.add_to_group("units")
		civ_node.add_child(civ_units)

# Initialize each civilization with a single unit (settler) for it to build a city.
# Place the units randomly on the map, at correct coordinates so its in the center of a tile.
func init_units() -> void:
	for civ in civs:
		var new_unit: Node = unit.instance()
		var ground_cells: Array = ($Map as TileMap).get_used_cells_by_id(GROUND)
		new_unit.position = ($Map as TileMap).map_to_world(ground_cells[randi() % len(ground_cells)]) + Vector2(16, 16)
		civ.get_node("Units").add_child(new_unit)

func start_turn() -> void:
	# Passer toutes les unités du jeu en "waiting"
	for node in get_tree().get_nodes_in_group("units"):
		for unit in node.get_children():
			unit.state = unit.unit_state.WAITING
	current_civ = civs[0]