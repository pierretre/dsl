
grammar RoboML


type MyString = string;

type Double = string;

type Boolean = string;

terminal DOUBLE returns number: INT '.' INT;
terminal ID returns string:'^'? ('a' ..'z' | 'A' ..'Z' | '_' )('a' ..'z' | 'A' ..'Z' | '_' | '0' ..'9' )* ;
terminal INT returns number:'0' ..'9' +;
terminal STRING returns string:'"' ('\\' . |  !('\\' | '"' ))*'"'  | "'" ('\\' . |  !('\\' | "'" ))*"'"  ;
hidden terminal ML_COMMENT returns string:'/*'  -> '*/'  ;
hidden terminal SL_COMMENT returns string:'//'  !('\n' | '\r' )('\r'? '\n' )?  ;
hidden terminal WS returns string:(' ' | '\t' | '\r' | '\n' )+;
terminal ANY_OTHER returns string:.;


type VarType = VarType_NUMBER | VarType_BOOLEAN;
type VarType_NUMBER = 'NUMBER';
type VarType_BOOLEAN = 'BOOLEAN';

type FunctionType = FunctionType_VOID | FunctionType_NUMBER | FunctionType_BOOLEAN;
type FunctionType_VOID = 'VOID';
type FunctionType_NUMBER = 'NUMBER';
type FunctionType_BOOLEAN = 'BOOLEAN';

type Unit = Unit_NONE | Unit_MM | Unit_CM;
type Unit_NONE = '';
type Unit_MM = 'mm';
type Unit_CM = 'cm';

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
	value?: MyString
}

interface FunctionDef {
	statements: Statement[]
	name?: MyString
	parameters: Parameter[]
	returnType?: FunctionType
}

interface Parameter {
	name?: MyString
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
	name?: MyString
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

entry RoboProgram returns RoboProgram:
    entrypoint=Entrypoint   ( function+=FunctionDef  )*
;

Statement returns Statement:
    SetSpeedStmt | IfStmt | LoopStmt | VariableDeclStmt | MovementStmt | RotationStmt | FunctionCallStmt ('comment' comment=Comment  )?
;

Expression returns Expression:
    NumeralConst | VariableRef | ComparisonOp | BooleanConst | Not | LogicOp | Opposite | ArithmeticOp | FunctionCall
;

Entrypoint returns Entrypoint:
    {Entrypoint} 'let' 'void' 'entry' '()' '{' (statements+=Statement)* '}'
;

FunctionDef returns FunctionDef:
    'FunctionDef' '{' ('name' name=String0  )? ('returnType' returnType=FunctionType  )? 'statements' '{' statements+=Statement  ("," statements+=Statement  )* '}' ('parameters' '{' parameters+=Parameter  ("," parameters+=Parameter  )* '}' )? '}'
;

Comment returns Comment:
    {Comment} 'Comment' '{' ('value' value=String0  )? '}'
;

SetSpeedStmt returns SetSpeedStmt:
    'setSpeed(' value=Expression ')'
;

IfStmt returns IfStmt:
    'IfStmt' '{' ('then' '{' then+=Statement  ("," then+=Statement  )* '}' )? 'condition' condition=Expression  ('else' '{' else+=Statement  ("," else+=Statement  )* '}' )? '}'
;

LoopStmt returns LoopStmt:
    'LoopStmt' '{'  ('instruction' '{' instruction+=Statement  ("," instruction+=Statement  )* '}' )? 'condition' condition=Expression  '}'
;

VariableDeclStmt returns VariableDeclStmt:
    'VariableDeclStmt' '{' ('newAttribute' newAttribute=VarType  )? 'variable' variable=Variable  'initialexpr' initialexpr=Expression  '}'
;

MovementStmt returns MovementStmt:
    'MovementStmt' '{' ('direction' direction=Direction  )? 'expr' expr=Expression  '}'
;

RotationStmt returns RotationStmt:
    'RotationStmt' '{' ('rotation' rotation=RotationDirection  )? 'degrees' degrees=Expression  '}'
;

FunctionCallStmt returns FunctionCallStmt:
    {FunctionCallStmt} 'FunctionCallStmt' '{' ('voidfct' voidfct=[FunctionDef:STRING ] )? ('parameters' '{' parameters+=Expression  ("," parameters+=Expression  )* '}' )? '}'
;

String0 returns MyString:
    'String'
;

Unit returns Unit:
    Unit_MM | Unit_CM
;
Unit_MM returns Unit_MM: 'mm' ;
Unit_CM returns Unit_CM: 'cm' ;

NumeralConst returns NumeralConst:
    {NumeralConst} (value=DOUBLE) 'in' (unit=Unit)? ;

VariableRef returns VariableRef:
    'VariableRef' '{' ('unit' unit=Unit  )? 'decl' decl=[VariableDeclStmt:STRING ] '}'
;

ComparisonOp returns ComparisonOp:
    'ComparisonOp' '{' ('unit' unit=Unit  )? ('operator' operator=ComparisonOperator  )? 'expr1' expr1=Expression  'expr2' expr2=Expression  '}'
;

BooleanConst returns BooleanConst:
    {BooleanConst} 'BooleanConst' '{' ('unit' unit=Unit  )? ('value' value=Boolean  )? '}'
;

Not returns Not:
    'Not' '{' ('unit' unit=Unit  )? 'expr' expr=Expression  '}'
;

LogicOp returns LogicOp:
    'LogicOp' '{' ('unit' unit=Unit  )? ('operator' operator=BooleanOperator  )? 'expr1' expr1=Expression  'expr2' expr2=Expression  '}'
;

Opposite returns Opposite:
    'Opposite' '{' ('unit' unit=Unit  )? 'expr' expr=Expression  '}'
;

ArithmeticOp returns ArithmeticOp:
    'ArithmeticOp' '{' ('unit' unit=Unit  )? ('operator' operator=ArithmeticOperator  )? 'expr1' expr1=Expression  'expr2' expr2=Expression  '}'
;

FunctionCall returns FunctionCall:
    'FunctionCall' '{' ('unit' unit=Unit  )? 'ref' ref=[FunctionDef:STRING ] ('parameters' '{' parameters+=Expression  ("," parameters+=Expression  )* '}' )? '}'
;

ComparisonOperator returns ComparisonOperator:
    ComparisonOperator_LOWERTHAN | ComparisonOperator_LOWERTHANEQUAL | ComparisonOperator_EQUAL | ComparisonOperator_GREATERTHANEQUAL | ComparisonOperator_GREATERTHAN
;
ComparisonOperator_LOWERTHAN returns ComparisonOperator_LOWERTHAN: 'LOWERTHAN' ;
ComparisonOperator_LOWERTHANEQUAL returns ComparisonOperator_LOWERTHANEQUAL: 'LOWERTHANEQUAL' ;
ComparisonOperator_EQUAL returns ComparisonOperator_EQUAL: 'EQUAL' ;
ComparisonOperator_GREATERTHANEQUAL returns ComparisonOperator_GREATERTHANEQUAL: 'GREATERTHANEQUAL' ;
ComparisonOperator_GREATERTHAN returns ComparisonOperator_GREATERTHAN: 'GREATERTHAN' ;

Boolean returns Boolean:
    'Boolean'
;

BooleanOperator returns BooleanOperator:
    BooleanOperator_AND | BooleanOperator_OR
;
BooleanOperator_AND returns BooleanOperator_AND: 'AND' ;
BooleanOperator_OR returns BooleanOperator_OR: 'OR' ;

ArithmeticOperator returns ArithmeticOperator:
    ArithmeticOperator_PLUS | ArithmeticOperator_MINUS | ArithmeticOperator_MULT | ArithmeticOperator_DIV
;
ArithmeticOperator_PLUS returns ArithmeticOperator_PLUS: 'PLUS' ;
ArithmeticOperator_MINUS returns ArithmeticOperator_MINUS: 'MINUS' ;
ArithmeticOperator_MULT returns ArithmeticOperator_MULT: 'MULT' ;
ArithmeticOperator_DIV returns ArithmeticOperator_DIV: 'DIV' ;

Variable returns Variable:
    {Variable} 'Variable' '{' ('name' name=String0  )? '}'
;

VarType returns VarType:
    VarType_NUMBER | VarType_BOOLEAN
;
VarType_NUMBER returns VarType_NUMBER: 'NUMBER' ;
VarType_BOOLEAN returns VarType_BOOLEAN: 'BOOLEAN' ;

Direction returns Direction:
    Direction_FORWARD | Direction_BACKWARD | Direction_LEFT | Direction_RIGHT
;
Direction_FORWARD returns Direction_FORWARD: 'FORWARD' ;
Direction_BACKWARD returns Direction_BACKWARD: 'BACKWARD' ;
Direction_LEFT returns Direction_LEFT: 'LEFT' ;
Direction_RIGHT returns Direction_RIGHT: 'RIGHT' ;

RotationDirection returns RotationDirection:
    RotationDirection_CLOCKWISE | RotationDirection_COUNTERCLOCKWISE
;
RotationDirection_CLOCKWISE returns RotationDirection_CLOCKWISE: 'CLOCKWISE' ;
RotationDirection_COUNTERCLOCKWISE returns RotationDirection_COUNTERCLOCKWISE: 'COUNTERCLOCKWISE' ;

Parameter returns Parameter:
    {Parameter} 'Parameter' '{' ('name' name=String0  )? ('type' ^type=VarType  )? '}'
;

FunctionType returns FunctionType:
    FunctionType_VOID | FunctionType_NUMBER | FunctionType_BOOLEAN
;
FunctionType_VOID returns FunctionType_VOID: 'VOID' ;
FunctionType_NUMBER returns FunctionType_NUMBER: 'NUMBER' ;
FunctionType_BOOLEAN returns FunctionType_BOOLEAN: 'BOOLEAN' ;
