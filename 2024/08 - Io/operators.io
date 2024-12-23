// Bounds-checking operator
OperatorTable addOperator("<>", 5)

Number <> := method(bound, (self >= 0 and self < bound))
