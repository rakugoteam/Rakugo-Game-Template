extends Object
class_name SignalHelper

static func force_only_one_callable(the_signal:Signal, the_callable:Callable):
	if the_callable.is_valid():
		var connections = the_signal.get_connections()
		
		if connections.is_empty():
			the_signal.connect(the_callable)
			return
			
		if connections.size() == 1 and \
		connections[0]["callable"] == the_callable:
			return
			
		for connection in connections:
			the_signal.disconnect(connection["callable"])
			
		the_signal.connect(the_callable)
