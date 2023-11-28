# I have no idea what I'm doing, so thank you The Shaggy Dev
extends HSlider

@export var bus_name : String

var bus_index : int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(on_value_changed)

func on_value_changed(value : float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
