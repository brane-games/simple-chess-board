extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$BoardControl.set_fen("r2qkb1r/pppb1pp1/2np1n1p/4p3/4P3/1PNP1N2/PBP1BPPP/R2QK2R b KQkq - 1 7")
	$BoardControl.highlight_square("c3")
