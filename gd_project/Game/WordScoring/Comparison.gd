class_name Comparison

enum Operator
{
	Unequal,
	Equal,
	Inferior,
	Superior,
	Odd,
	Even,
}

var left_operand : ComputedValue
var right_operand : ComputedValue
var operator : Operator

func _init(left : ComputedValue, operator : Operator, right : ComputedValue):
	self.left_operand = left
	self.right_operand = right
	self.operator = operator
	
func get_result(context : VariableContext) -> bool:
	var left = left_operand.get_value(context)
	var right = 0
	if operator != Operator.Odd && operator != Operator.Even:
		right = right_operand.get_value(context)
	
	match operator:
		Operator.Unequal:
			return left != right
		Operator.Equal:
			return left == right
		Operator.Inferior:
			return left < right
		Operator.Superior:
			return left > right
		Operator.Even:
			return left % 2 == 0
		Operator.Odd:
			return left % 2 != 0
	
	printerr("missing operator case")
	return 0
