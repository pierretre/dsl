import 'XMLType-types'

type VarType = VarType_NUMBER | VarType_BOOLEAN;
type VarType_NUMBER = 'NUMBER';
type VarType_BOOLEAN = 'BOOLEAN';

type FunctionType = FunctionType_VOID | FunctionType_NUMBER | FunctionType_BOOLEAN;
type FunctionType_VOID = 'VOID';
type FunctionType_NUMBER = 'NUMBER';
type FunctionType_BOOLEAN = 'BOOLEAN';

type Unit = Unit_NONE | Unit_MM | Unit_CM;
type Unit_NONE = 'NONE';
type Unit_MM = 'MM';
type Unit_CM = 'CM';

type Direction = Direction_FORWARD | Direction_BACKWARD | Direction_LEFT | Direction_RIGHT;
type Direction_FORWARD = 'FORWARD';
type Direction_BACKWARD = 'BACKWARD';
type Direction_LEFT = 'LEFT';
type Direction_RIGHT = 'RIGHT';

type RotationDirection = RotationDirection_CLOCKWISE | RotationDirection_COUNTERCLOCKWISE;
type RotationDirection_CLOCKWISE = 'CLOCKWISE';
type RotationDirection_COUNTERCLOCKWISE = 'COUNTERCLOCKWISE';

type ComparisonOperator = ComparisonOperator_LOWERTHAN | ComparisonOperator_LOWERTHANEQUAL | ComparisonOperator_EQUAL | ComparisonOperator_GREATERTHANEQUAL | ComparisonOperator_GREATERTHAN;
type ComparisonOperator_LOWERTHAN = 'LOWERTHAN';
type ComparisonOperator_LOWERTHANEQUAL = 'LOWERTHANEQUAL';
type ComparisonOperator_EQUAL = 'EQUAL';
type ComparisonOperator_GREATERTHANEQUAL = 'GREATERTHANEQUAL';
type ComparisonOperator_GREATERTHAN = 'GREATERTHAN';

type BooleanOperator = BooleanOperator_AND | BooleanOperator_OR;
type BooleanOperator_AND = 'AND';
type BooleanOperator_OR = 'OR';

type ArithmeticOperator = ArithmeticOperator_PLUS | ArithmeticOperator_MINUS | ArithmeticOperator_MULT | ArithmeticOperator_DIV;
type ArithmeticOperator_PLUS = 'PLUS';
type ArithmeticOperator_MINUS = 'MINUS';
type ArithmeticOperator_MULT = 'MULT';
type ArithmeticOperator_DIV = 'DIV';

interface RoboProgram {
	entrypoint: Entrypoint
	function: FunctionDef[]
}

interface Entrypoint {
	statements: Statement[]
}

interface Statement {
	comment?: Comment
}

interface Comment {
	value?: String
}

interface FunctionDef {
	statements: Statement[]
	name?: String
	parameters: Parameter[]
	returnType?: FunctionType
}

interface Parameter {
	name?: String
	^type?: VarType
}

interface Expression {
	unit?: Unit
}

interface SetSpeedStmt extends Statement {
	value: Expression
}

interface IfStmt extends Statement {
	then: Statement[]
	condition: Expression
	else: Statement[]
}

interface LoopStmt extends Statement {
	instruction: Statement[]
	condition: Expression
}

interface VariableDeclStmt extends Statement {
	variable: Variable
	initialexpr: Expression
	newAttribute?: VarType
}

interface Variable {
	name?: String
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
	value?: Double
}

interface LiteralExpression extends Expression {
}

interface VariableRef extends LiteralExpression {
	decl: @VariableDeclStmt
}

interface ComparisonOp extends BinaryOp {
	operator?: ComparisonOperator
}

interface BinaryOp extends Expression {
	expr1: Expression
	expr2: Expression
}

interface BooleanConst extends LiteralExpression {
	value?: Boolean
}

interface Not extends UnaryOp {
}

interface UnaryOp extends Expression {
	expr: Expression
}

interface LogicOp extends BinaryOp {
	operator?: BooleanOperator
}

interface Opposite extends UnaryOp {
}

interface ArithmeticOp extends BinaryOp {
	operator?: ArithmeticOperator
}

interface FunctionCall extends LiteralExpression {
	ref: @FunctionDef
	parameters: Expression[]
}

