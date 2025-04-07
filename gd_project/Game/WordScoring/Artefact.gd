class_name Artefact

enum TargetType
{
	LetterAdd,
	LetterMult,
	LetterFishType,
	LetterBonusType,
	WordAdd,
	WordMult,
}

enum TriggerType
{
	Letter,
	Word,
}

var name : String
var description : String
var is_malus : bool
var target : TargetType;
var trigger : TriggerType;
var value;
var conditions : Array[Condition]
var condition: Callable # KISS

func get_value(variable_context : VariableContext, condition_context : ConditionContext):
	if value is ComputedValue:
		return value.get_value(variable_context)
	elif value is Callable:
		return value.call(variable_context, condition_context)
	return value

func are_conditions_valid(variable_context : VariableContext, condition_context : ConditionContext) -> bool:
	if condition != null:
		return condition.call(variable_context, condition_context)

	for condition in conditions:
		if !condition.get_result(variable_context, condition_context):
			return false
	return true
