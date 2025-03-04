extends HBoxContainer

@onready var coin_label: Label = $coin_label
@onready var life_label = $life_label

func _ready():
	life_label.text = str(3)

func update_coin(amount: int):
	coin_label.text = "%d" % amount
	
func update_life(health: int):
	life_label.text = "%d" % health
