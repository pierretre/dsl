type VarType = 'number' | 'bool';

type FunctionType = VarType | 'void';

type Unit = 'mm' | 'cm';

type Direction = 'Forward' | 'Backward' | 'Left' | 'Right';

type RotationDirection = 'Clock' | 'CounterClock';

type ComparisonOperator = '<' | '<=' | '==' | '>=' | '>' | '!=';

type BooleanOperator = 'and' | 'or';

type ArithmeticOperator = '+' | '-' | '*' | '/';

interface RoboProgram {
	entrypoint: Entrypoint
	defs: FunctionDef[]
}

interface Entrypoint {
	body: Block
}

interface Block {
	statements?: Statement[]
}

interface Statement {
}

interface FunctionDef {
	name: string
	parameters: Variable[]
	returnType: FunctionType
	body: Block
}

interface Expression {
	unit?: Unit
}

interface SetSpeedStmt extends Statement {
	value: Expression
}

interface IfStmt extends Statement {
	condition: Expression
	thenBlock: Block
	elseBlock?: Block
	elseif: ElseIf[]
}

interface ElseIf {
	condition: Expression
	thenBlock: Block
}

interface ReturnStmt extends Statement {
	expr: Expression
}

interface LoopStmt extends Statement {
	condition: Expression
	block: Block
}

interface Variable {
	name: string
	type: VarType
	value?: VariableValue
}

interface VariableValue {
	value: Expression
}

interface MovementStmt extends Statement {
	direction?: Direction
	expr: Expression
}

interface RotationStmt extends Statement {
	rotation?: RotationDirection
	degrees: Expression
}

interface FunctionCallStmt extends Statement {
	parameters: Expression[]
	voidfct?: @FunctionDef
}

interface NumeralConst extends LiteralExpression {
	value?: number
}

interface LiteralExpression extends Expression {
}

interface SensorFunctionCall extends LiteralExpression {
}

interface VariableRef extends LiteralExpression {
	decl: @Variable
}

interface VariableAffStmt extends Statement {
	decl: @Variable
	expr: Expression
}

interface ComparisonOp extends BinaryOp {
	operator: ComparisonOperator
}

interface BinaryOp extends Expression {
	left: Expression
	right: Expression
}

interface BooleanConst extends LiteralExpression {
	value?: boolean
}

interface Not extends UnaryOp {
}

interface UnaryOp extends Expression {
	expr: Expression
}

interface LogicOp extends BinaryOp {
	operator: BooleanOperator
}

interface Opposite extends UnaryOp {
}

interface ArithmeticOp extends BinaryOp {
	operator: ArithmeticOperator
}

interface FunctionCall extends LiteralExpression {
	ref: @FunctionDef
	parameters: Expression[]
}