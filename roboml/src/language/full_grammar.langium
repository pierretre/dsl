
grammar RoboML


terminal DOUBLE returns number: INT '.' INT | INT; 
terminal BOOLEAN returns boolean: 'true' | 'false';
terminal ID returns string:'^'? ('a' ..'z' | 'A' ..'Z' | '_' )('a' ..'z' | 'A' ..'Z' | '_' | '0' ..'9' )* ;
terminal INT returns number:'0' ..'9' +;
terminal STRING returns string:'"' ('\\' . |  !('\\' | '"' ))*'"'  | "'" ('\\' . |  !('\\' | "'" ))*"'"  ;
hidden terminal ML_COMMENT returns string:'/*'  -> '*/'  ;
hidden terminal SL_COMMENT returns string:'//'  !('\n' | '\r' )('\r'? '\n' )?  ;
hidden terminal WS returns string:(' ' | '\t' | '\r' | '\n' )+;
terminal ANY_OTHER returns string:.;


type VarType = VarType_NUMBER | VarType_BOOLEAN;
type VarType_NUMBER = 'number';
type VarType_BOOLEAN = 'bool';

type FunctionType = FunctionType_VOID | FunctionType_NUMBER | FunctionType_BOOLEAN;
type FunctionType_VOID = 'void';
type FunctionType_NUMBER = 'number';
type FunctionType_BOOLEAN = 'bool';

type Unit = Unit_MM | Unit_CM;
type Unit_MM = 'mm';
type Unit_CM = 'cm';

type Direction = Direction_FORWARD | Direction_BACKWARD | Direction_LEFT | Direction_RIGHT;
type Direction_FORWARD = 'forward';
type Direction_BACKWARD = 'backward';
type Direction_LEFT = 'left';
type Direction_RIGHT = 'right';

type RotationDirection = RotationDirection_CLOCKWISE | RotationDirection_COUNTERCLOCKWISE;
type RotationDirection_CLOCKWISE = 'clockwise';
type RotationDirection_COUNTERCLOCKWISE = 'counterclockwise';

type ComparisonOperator = ComparisonOperator_LOWERTHAN | ComparisonOperator_LOWERTHANEQUAL | ComparisonOperator_EQUAL | ComparisonOperator_GREATERTHANEQUAL | ComparisonOperator_GREATERTHAN;
type ComparisonOperator_LOWERTHAN = '<';
type ComparisonOperator_LOWERTHANEQUAL = '<=';
type ComparisonOperator_EQUAL = '==';
type ComparisonOperator_GREATERTHANEQUAL = '>=';
type ComparisonOperator_GREATERTHAN = '>';
type ComparisonOperator_NOTEQUAL = '!=';

type BooleanOperator = BooleanOperator_AND | BooleanOperator_OR;
type BooleanOperator_AND = 'and';
type BooleanOperator_OR = 'or';

type ArithmeticOperator = ArithmeticOperator_PLUS | ArithmeticOperator_MINUS | ArithmeticOperator_MULT | ArithmeticOperator_DIV;
type ArithmeticOperator_PLUS = '+';
type ArithmeticOperator_MINUS = '-';
type ArithmeticOperator_MULT = '*';
type ArithmeticOperator_DIV = '/';

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
	value?: string
}

interface FunctionDef {
	statements: Statement[]
	name?: string
	parameters: Parameter[]
	returnType?: FunctionType
}

interface Parameter {
	name?: string
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
	type?: VarType
}

interface Variable {
	name?: string
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
	value?: boolean
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
    'FunctionDef' '{' ('name' name=STRING  )? ('returnType' returnType=FunctionType  )? 'statements' '{' statements+=Statement  ("," statements+=Statement  )* '}' ('parameters' '{' parameters+=Parameter  ("," parameters+=Parameter  )* '}' )? '}'  
;

Comment returns Comment:
    {Comment} ( value=STRING  )?
;

SetSpeedStmt returns SetSpeedStmt:
    'setSpeed(' value=Expression ')'
;

IfStmt returns IfStmt:
    'IfStmt' '{' ('then' '{' then+=Statement  ("," then+=Statement  )* '}' )? 'condition' condition=Expression  ('else' '{' else+=Statement  ("," else+=Statement  )* '}' )? '}'  
;

LoopStmt returns LoopStmt:
    'LoopStmt' '{' ('instruction' '{' instruction+=Statement  ("," instruction+=Statement  )* '}' )? 'condition' condition=Expression  '}'  
;

VariableDeclStmt returns VariableDeclStmt:
    'var' type=VarType variable=Variable  'initialexpr' initialexpr=Expression  
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
    {BooleanConst} 'BooleanConst' '{' ('unit' unit=Unit  )? ('value' value=BOOLEAN  )? '}'  
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
ComparisonOperator_LOWERTHAN returns ComparisonOperator_LOWERTHAN: '<' ;
ComparisonOperator_LOWERTHANEQUAL returns ComparisonOperator_LOWERTHANEQUAL: '<=' ;
ComparisonOperator_EQUAL returns ComparisonOperator_EQUAL: '==' ;
ComparisonOperator_GREATERTHANEQUAL returns ComparisonOperator_GREATERTHANEQUAL: '>=' ;
ComparisonOperator_GREATERTHAN returns ComparisonOperator_GREATERTHAN: '>' ;
ComparisonOperator_NOTEQUAL returns ComparisonOperator_NOTEQUAL: '!=' ;

BooleanOperator returns BooleanOperator:
    BooleanOperator_AND | BooleanOperator_OR
;
BooleanOperator_AND returns BooleanOperator_AND: 'and' ;
BooleanOperator_OR returns BooleanOperator_OR: 'or' ;

ArithmeticOperator returns ArithmeticOperator:
    ArithmeticOperator_PLUS | ArithmeticOperator_MINUS | ArithmeticOperator_MULT | ArithmeticOperator_DIV
;
ArithmeticOperator_PLUS returns ArithmeticOperator_PLUS: '+' ;
ArithmeticOperator_MINUS returns ArithmeticOperator_MINUS: '-' ;
ArithmeticOperator_MULT returns ArithmeticOperator_MULT: '*' ;
ArithmeticOperator_DIV returns ArithmeticOperator_DIV: '/' ;

Variable returns Variable:
    {Variable} name=STRING
;

VarType returns VarType:
    VarType_NUMBER | VarType_BOOLEAN
;
VarType_NUMBER returns VarType_NUMBER: 'number' ;
VarType_BOOLEAN returns VarType_BOOLEAN: 'bool' ;

Direction returns Direction:
    Direction_FORWARD | Direction_BACKWARD | Direction_LEFT | Direction_RIGHT
;
Direction_FORWARD returns Direction_FORWARD: 'forward' ;
Direction_BACKWARD returns Direction_BACKWARD: 'backward' ;
Direction_LEFT returns Direction_LEFT: 'left' ;
Direction_RIGHT returns Direction_RIGHT: 'right' ;

RotationDirection returns RotationDirection:
    RotationDirection_CLOCKWISE | RotationDirection_COUNTERCLOCKWISE
;
RotationDirection_CLOCKWISE returns RotationDirection_CLOCKWISE: 'clockwise' ;
RotationDirection_COUNTERCLOCKWISE returns RotationDirection_COUNTERCLOCKWISE: 'counterclockwise' ;

Parameter returns Parameter:
    {Parameter} 'Parameter' '{' ('name' name=STRING  )? ('type' ^type=VarType  )? '}'  
;

FunctionType returns FunctionType:
    FunctionType_VOID | FunctionType_NUMBER | FunctionType_BOOLEAN
;
FunctionType_VOID returns FunctionType_VOID: 'void' ;
FunctionType_NUMBER returns FunctionType_NUMBER: 'number' ;
FunctionType_BOOLEAN returns FunctionType_BOOLEAN: 'bool' ;

