extends Node3D

@export var books: Array[Book] = []
@export var answers: Array[bool] = []

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func pull(book: Book, pullable: bool) -> void:
	var result: bool = check()
	if result == true:
		animation_player.play("open_shelf")
		print("Shall Pass")

func check() -> bool:
	for i in range(books.size()):
		if books[i].is_pulled != answers[i]:
			return false
	return true
