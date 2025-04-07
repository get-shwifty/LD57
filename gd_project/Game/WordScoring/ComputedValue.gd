class_name ComputedValue

var raw_value : float;
var variable : VariableContext.VariableType;

func _init(raw_value : float = 0, variable : VariableContext.VariableType = VariableContext.VariableType.None):
	self.raw_value = raw_value
	self.variable = variable
	
func get_value(context : VariableContext) -> float:
	if variable == VariableContext.VariableType.None:
		return raw_value
	else:
		return context.get_variable(variable)
