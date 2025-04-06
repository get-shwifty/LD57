class_name Artefact

enum TargetType
{
	LetterAdd,
	LetterMult,
	WordAdd,
	WordMult,
}

enum TriggerType
{
	Letter,
	Word,
}

var name : String
var target : TargetType;
var trigger : TriggerType;
var value : ComputedValue;
var conditions : Array[Condition]

func are_conditions_valid(variable_context : VariableContext, condition_context : ConditionContext) -> bool:
	for condition in conditions:
		if !condition.get_result(variable_context, condition_context):
			return false
	return true
