
@tool
extends PanelContainer
class_name BoardControl

@export_range(32, 128, 4.0) var square_size = 32 : set = _set_square_size
@export var background_color := Color("#123456") : set = _set_background_color
@export var white_color := Color("#123456") : set = _set_white_color
@export var black_color := Color("#123456") : set = _set_black_color
@export var highlight_color := Color("#123456")
@export_range(0, 100, 1.0) var border_size = 16 : set = _set_border_size
@export_range(0, 32, 1.0) var spacing_size = 4 : set = _set_spacing_size


var svg_pieces: Dictionary = {}

func _ready():
	_load_svg_pieces()
	_clear_board()
	

func set_fen(fen: String):
	_clear_board()
	var counter = 0
	for ch in fen.split(' ')[0]:
		match ch:
			"/": # Next rank
				pass
			"1", "2", "3", "4", "5", "6", "7", "8":
				counter += ch.to_int()
			_:
				_set_piece(ch, counter)
				counter += 1 

func highlight_square(position: String, is_highlighting: bool = true):
	var col = position[0].to_ascii_buffer()[0] - 97
	var row = position[1].to_int()
	print(col, row)
	var index = 64 - (8 * row) + col
	print("indexx", index)
	if(is_highlighting):
		$GridContainer.get_child(index).color = highlight_color
	else:
		$GridContainer.get_child(index).color = black_color if index % 2 == 0 and (index / 8) % 2 == 1 else white_color


#################
# PRIVATE METHODS
#################

func _set_piece(pieceKey: String, index: int):
	var piece_texture_rect = $GridContainer.get_child(index).get_child(0)
	if(pieceKey == ' '):
		piece_texture_rect.texture = null
	else:
		piece_texture_rect.texture = svg_pieces[pieceKey]

func _clear_board():
	for i in 64:
		_set_piece(' ', i)


func _load_svg_pieces():
	var initial_path = "res://board/pieces_svgs/"
	svg_pieces['R'] = load(initial_path + "rook.svg")
	svg_pieces['r'] = load(initial_path + "black_rook.svg")
	svg_pieces['N'] = load(initial_path + "knight.svg")
	svg_pieces['n'] = load(initial_path + "black_knight.svg")
	svg_pieces['B'] = load(initial_path + "bishop.svg")
	svg_pieces['b'] = load(initial_path + "black_bishop.svg")
	svg_pieces['Q'] = load(initial_path + "queen.svg")
	svg_pieces['q'] = load(initial_path + "black_queen.svg")
	svg_pieces['K'] = load(initial_path + "king.svg")
	svg_pieces['k'] = load(initial_path + "black_king.svg")
	svg_pieces['P'] = load(initial_path + "pawn.svg")
	svg_pieces['p'] = load(initial_path + "black_pawn.svg")
########
# SETTERS
########
func _set_square_size(size: float):
	if(get_node_or_null("GridContainer")):
		for child in $GridContainer.get_children():
			child.custom_minimum_size = Vector2(size, size)
	square_size = size

func _set_background_color(color: Color):
	var new_stylebox_normal = self.get_theme_stylebox("panel").duplicate()
	new_stylebox_normal.border_color = color
	new_stylebox_normal.bg_color = color
	self.add_theme_stylebox_override("panel", new_stylebox_normal)
	background_color = color

func _set_white_color(color: Color):
	var counter = 0
	if(get_node_or_null("GridContainer")):
		for child in $GridContainer.get_children():
			if((counter / 8) % 2 == 0 && counter % 2 == 0):
				child.color = color
			if((counter / 8) % 2 == 1 && counter % 2 == 1
			):
				child.color = color
			counter += 1
	white_color = color

func _set_black_color(color: Color):
	var counter = 0
	if(get_node_or_null("GridContainer")):
		for child in $GridContainer.get_children():
			if((counter / 8) % 2 == 0 && counter % 2 == 1):
				child.color = color
			if((counter / 8) % 2 == 1 && counter % 2 == 0
			):
				child.color = color
			counter += 1
	black_color = color

func _set_border_size(size: float):
	var new_stylebox_normal = self.get_theme_stylebox("panel").duplicate()
	new_stylebox_normal.border_width_left = size
	new_stylebox_normal.border_width_right = size
	new_stylebox_normal.border_width_top = size
	new_stylebox_normal.border_width_bottom = size
	self.add_theme_stylebox_override("panel", new_stylebox_normal)
	border_size = size

func _set_spacing_size(size: float):
	if(get_node_or_null("GridContainer")):
		$GridContainer.add_theme_constant_override("h_separation", size)
		$GridContainer.add_theme_constant_override("v_separation", size)
	spacing_size = size
