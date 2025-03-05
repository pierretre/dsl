
grammar RoboML


terminal DOUBLE returns number: INT '.' INT | INT;
terminal BOOLEAN returns boolean: 'true' | 'false';
terminal ID returns string:'^'? ('a' ..'z' | 'A' ..'Z' | '_' )('a' ..'z' | 'A' ..'Z' | '_' | '0' ..'9' )* ;
terminal INT returns number:'0' ..'9' +;
terminal STRING returns string:'"' ('\\' . |  !('\\' | '"' ))*'"'  | "'" ('\\' . |  !('\\' | "'" ))*"'"  ;
hidden terminal ML_COMMENT returns string: '//' !('\n' | '\r')* ;
hidden terminal SL_COMMENT returns string:'//'  !('\n' | '\r' )('\r'? '\n' )?  ;
hidden terminal WS returns string: (' ' | '\t' | '\r' | '\n' )+;
terminal ANY_OTHER returns string:.;

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
	function: FunctionDef[]
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
	parameters: Parameter[]
	returnType: FunctionType
    body: Block
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
	condition: Expression
	then: Block
	else?: Block
    elseif?: Block
}

interface ReturnStmt extends Statement {
	expr: Expression
}

interface LoopStmt extends Statement {
	condition: Expression
	block: Block 
}

interface Variable extends Statement {
    name: string
	type: VarType
	variable: VariableValue
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

Entrypoint returns Entrypoint:
    {Entrypoint} 'let' 'void' 'entry' '()' body=Block
;

FunctionDef returns FunctionDef:
    'let' returnType=FunctionType name=ID ('()' | ( '('parameters+=Parameter  ("," parameters+=Parameter  )* ) ')' ) body=Block
;

Block returns Block: '{' statements+=Statement* '}';

Statement returns Statement:
    (SetSpeedStmt | IfStmt | LoopStmt | VariableAffStmt | Variable | MovementStmt | RotationStmt | FunctionCallStmt | ReturnStmt)
;

ReturnStmt returns ReturnStmt: 'return' expr=Expression;

Expression returns Expression: NumeralExpression | BooleanExpression;

NumeralExpression returns ArithmeticOp:
    expr1=MultiplicativeExpression (operator=('+' | '-') expr2=MultiplicativeExpression)*;

MultiplicativeExpression returns ArithmeticOp:
    expr1=UnaryExpression (operator=('*' | '/') expr2=UnaryExpression)*
;

UnaryExpression returns Expression: (Opposite | NumeralPrimaryExpression);

Opposite returns Opposite: '-' expr=NumeralPrimaryExpression;

NumeralPrimaryExpression returns Expression: NumeralConst | LiteralExpression;

NumeralConst returns NumeralConst:
    {NumeralConst} value=DOUBLE ('in' unit=Unit)?
;

SensorFunctionCall returns SensorFunctionCall:
    {SensorFunctionCall} ('getDistance()' | 'getTimestamp()') ('in' unit=Unit)?
;

BooleanExpression returns LogicOp:
    expr1=AndExpression (operator='or' expr2=AndExpression)*
;

AndExpression returns LogicOp:
     expr1=ComparisonExpression (operator='and' expr2=ComparisonExpression)*
;

ComparisonExpression returns ComparisonOp:
    (expr1=NumeralPrimaryExpression (operator=ComparisonOperator expr2=NumeralPrimaryExpression)?) | BooleanPrimaryExpression
;

BooleanPrimaryExpression returns Expression:
    BooleanConst | LiteralExpression
;

BooleanConst returns BooleanConst: {BooleanConst} value=BOOLEAN;

Not returns Not: 'not' expr=BooleanPrimaryExpression;

LiteralExpression returns Expression:
    VariableRef | FunctionCall | Not | '(' Expression ')' | SensorFunctionCall
;

FunctionCall returns FunctionCall:
    ref=[FunctionDef:ID ] ( '()' | '(' parameters+=Expression  ("," parameters+=Expression  )* ')')
; 

VariableRef returns VariableRef:
    decl=[Variable:ID]
;

IfStmt returns IfStmt:
    'if' condition=Expression 'then' then=Block
    ( 'else' 'if' condition=Expression 'then' elseif=Block )*
    ( 'else' else=Block )?
;

LoopStmt returns LoopStmt: 'loop' condition=Expression block=Block;

Variable returns Variable: 
    'var' type=VarType name=ID '=' variable=VariableValue
;

VariableAffStmt returns VariableAffStmt:
    {VariableAffStmt} decl=[Variable:ID ]  '=' expr=Expression  
;

MovementStmt returns MovementStmt: direction=Direction expr=Expression;

RotationStmt returns RotationStmt: rotation=RotationDirection degrees=Expression;

SetSpeedStmt returns SetSpeedStmt: 'setSpeed(' value=Expression ')';

FunctionCallStmt returns FunctionCallStmt:
    {FunctionCallStmt} voidfct=[FunctionDef:ID ] ( '()' | '(' parameters+=Expression  ("," parameters+=Expression  )* ')')
;

Unit returns Unit: 'mm' | 'cm';

ComparisonOperator returns ComparisonOperator: '<' | '<=' | '==' | '>=' | '>' | '!=';

VariableValue returns VariableValue: {VariableValue} value=Expression;

VarType returns VarType: 'number' | 'bool' ;

Direction returns Direction: 'Forward' | 'Backward' | 'Left' | 'Right';

RotationDirection returns RotationDirection: 'Clock' | 'CounterClock';

Parameter returns Parameter: {Parameter} ^type=VarType name=ID;

FunctionType returns FunctionType: VarType | 'void';