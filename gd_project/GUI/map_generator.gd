class_name MapGenerator
extends Node

const X_DIST := 30
const Y_DIST := 30
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 7
const MAP_WITDTH := 5
const PATHS := 6
const MIN_START_POINTS := 3
const LEVEL_ROOM_WEIGHT := 10.0
const SHOP_ROOM_WEIGHT := 3.0
const MINI_BOSS_ROOM_WEIGHT := 5.0
const LIMIT_MIN_FOR_MINI_BOSS_SPAWN := 5

var random_room_type_weight = {
	Room.Type.LEVEL: 0.0,
	Room.Type.SHOP: 0.0,
	Room.Type.MINI_BOSS: 0.0,
}
var random_room_type_total_weight = 0.0
var map_data: Array[Array]

func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	## Génère chaque chemin de manière verticale pour chaque starting point
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
	
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()
	
	return map_data

## Génère la grille de départ en prenant les constantes définies plus haut
## Rajoute un offset aléatoire sur chaque position pour éviter d'avoir un truc trop rigide
func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_rooms: Array[Room] = []
		
		for j in MAP_WITDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			
			current_room.row = i
			current_room.column = j
			current_room.position = Vector2(j * X_DIST, i * Y_DIST) + offset
			current_room.next_rooms = []
			
			adjacent_rooms.append(current_room)
		
		result.append(adjacent_rooms)
	
	return result

## Créé une liste de points de départ pour le nb de PATHS défini plus haut
## Un point de départ peut servir à plusieurs chemins
## Exemple : pour 3 chemins, on pourra avoir la liste : [0,0,2] voulant dire que 2/3 chemins 
## commenceront sur le premier point de la grille et le dernier sur le plus à droite
func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < MIN_START_POINTS:
		
		## Reset des variables si condition non respectée
		y_coordinates = []
		unique_points = 0
		
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WITDTH -1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
			
			y_coordinates.append(starting_point)
	
	return y_coordinates

## Permet de choisir, à partir d'un point de départ, la prochaine salle
## Deux conditions : 
##  - Ne pas sortir de la limite de la range (MAP_WIDTH)
##  - Ne pas croiser un chemin déjà existant
func _setup_connection(i: int, j: int) -> int:
	var current_room := map_data[i][j] as Room
	var next_room: Room
	
	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j-1, j+1), 0, MAP_WITDTH - 1)
		next_room = map_data[i+1][random_j]
		
	current_room.next_rooms.append(next_room)
	
	return next_room.column 
	
## Regarde si la prochaine salle croise un chemin déjà existant 
func _would_cross_existing_path(i: int, j: int, next_room: Room) -> bool:
	var left_room: Room
	var right_room: Room
	
	if j > 0:
		left_room = map_data[i][j-1]
	if j < MAP_WITDTH -1:
		right_room = map_data[i][j+1]
	
	# On vérifie que si le voisin de gauche existe que ses prochaines salles
	# ne croisent pas la future salle (next_room)
	if left_room and next_room.column < j:
		for left_room_next: Room in left_room.next_rooms:
			if left_room_next.column > next_room.column:
				return true
	
	if right_room and next_room.column > j:
		for right_room_next: Room in right_room.next_rooms:
			if right_room_next.column < next_room.column:
				return true
	
	return false

## La salle du boss n'apparait qu'au dernier étage
## Toutes les salles sur l'étage inférieur doivent pointer vers cette salle
func _setup_boss_room() -> void:
	var middle_col := floori(MAP_WITDTH * 0.5)
	var boss_room := map_data[FLOORS - 1][middle_col] as Room
	
	for j in MAP_WITDTH:
		var room = map_data[FLOORS-2][j] as Room
		if room.next_rooms:
			room.next_rooms = [] as Array[Room]
			room.next_rooms.append(boss_room)
	
	boss_room.type = Room.Type.BOSS

## Permet d'attribuer un poids aléatoire à chaque type de salle
func _setup_random_room_weights() -> void:
	random_room_type_weight[Room.Type.LEVEL] = LEVEL_ROOM_WEIGHT
	random_room_type_weight[Room.Type.SHOP] = LEVEL_ROOM_WEIGHT + MINI_BOSS_ROOM_WEIGHT
	random_room_type_weight[Room.Type.MINI_BOSS] = LEVEL_ROOM_WEIGHT + MINI_BOSS_ROOM_WEIGHT + SHOP_ROOM_WEIGHT
	
	random_room_type_total_weight = random_room_type_weight[Room.Type.MINI_BOSS]
	
func _setup_room_types() -> void:
	# La première salle est toujours le niveau 1
	for room: Room in map_data[0]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.LEVEL_1
	
	# Le dernier étage avant un boss est toujours un magasin
	for room: Room in map_data[FLOORS - 2]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.SHOP
	
	# Pour le reste des salles
	var current_floor_index = -1
	for current_floor in map_data:
		current_floor_index += 1
		for room: Room in current_floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)
				if next_room.type == Room.Type.LEVEL:
					_set_room_precise_level(next_room, current_floor_index)
					
	
	# Après un mini-boss, on veut une salle d'upgrade
	for current_floor in map_data:
		for room: Room in current_floor:
			for next_room: Room in room.next_rooms:
				if room.type == Room.Type.MINI_BOSS:
					next_room.type = Room.Type.SHOP
	

func _set_room_randomly(room_to_set: Room) -> void:
	var mini_boss_below_N := true
	var consecutive_mini_boss := true
	var consecutive_shop := true
	
	var type_candidate: Room.Type
	
	while mini_boss_below_N or consecutive_mini_boss or consecutive_shop :
		# Si les conditions ne sont pas respectées, on relance le type 
		type_candidate = _get_random_room_type_by_weight()
		
		var is_miniboss := type_candidate == Room.Type.MINI_BOSS
		var is_shop := type_candidate == Room.Type.SHOP
		var has_miniboss_parent := _has_parent_of_type(room_to_set, Room.Type.MINI_BOSS)
		var has_shop_parent := _has_parent_of_type(room_to_set, Room.Type.SHOP)
		
		# On revérifie les conditions
		mini_boss_below_N = is_miniboss and room_to_set.row < LIMIT_MIN_FOR_MINI_BOSS_SPAWN
		consecutive_mini_boss = is_miniboss and has_miniboss_parent
		consecutive_shop = is_shop and has_shop_parent
	
	room_to_set.type = type_candidate

func _set_room_precise_level(room_to_set: Room, floor_index : int) -> void:
	match floor_index:
		0:
			room_to_set.type = Room.Type.LEVEL_1
		1:
			room_to_set.type = Room.Type.LEVEL_2
		2:
			room_to_set.type = Room.Type.LEVEL_2
		3:
			room_to_set.type = Room.Type.LEVEL_3
		4:
			room_to_set.type = Room.Type.LEVEL_4
		5:
			room_to_set.type = Room.Type.LEVEL_5
		6:
			room_to_set.type = Room.Type.LEVEL_6
		7:
			room_to_set.type = Room.Type.LEVEL_7
		_:
			room_to_set.type = Room.Type.LEVEL_1

## Vérifie si la salle a un parent du type annoncé
func _has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents: Array[Room] = []
	
	# Récupération du parent de gauche, s'il existe
	# On ne prend pas les parents "hors range"
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	# Récupération du parent de droite
	if room.column < MAP_WITDTH - 1 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column + 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	# Récupération du parent du-dessous
	if room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	for parent: Room in parents:
		if parent.type == type:
			return true
	
	return false

func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	for type: Room.Type in random_room_type_weight:
		if random_room_type_weight[type] > roll:
			return type
	
	return Room.Type.LEVEL
