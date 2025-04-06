class_name Condition

var comparison : Comparison
var custom_condition : CustomCondition

func _init(comparison : Comparison = null, custom_condition : CustomCondition = null):
	self.comparison = comparison
	self.custom_condition = custom_condition
	
	if self.comparison != null && self.custom_condition != null:
		printerr("Condition can only have a comparison or a custom condition, not both")

func get_result(variable_context : VariableContext, condition_context : ConditionContext):
	if self.comparison != null:
		return self.comparison.get_result(variable_context);
	elif self.custom_condition != null:
		return self.custom_condition.get_result(condition_context)
	else:
		return true;
