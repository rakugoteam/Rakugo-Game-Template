extends HBoxContainer

var bus_index:int
var bus_value:float

func _on_bus_h_slider_value_changed(value):
	AppSettings.set_bus_volume_from_linear(bus_index, value)

func _ready():
	$BusLabel.text = AudioServer.get_bus_name(bus_index)
	$BusHSlider.value = bus_value
