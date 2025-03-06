grammar RoboML

import 'Terminals'
import 'idm-types'
import 'XMLType-types'

entry RoboProgram returns RoboProgram:
    entrypoint=Entrypoint   defs+=FunctionDef*
;

Entrypoint returns Entrypoint:
    {Entrypoint} 'let' 'void' 'entry' '()' body=Block
;

FunctionDef returns FunctionDef:
    'let' returnType=FunctionType name=ID ('()' | ( '('parameters+=Parameter  ("," parameters+=Parameter  )* ) ')' ) body=Block
;

Parameter returns Variable:
    type=VarType name=ID;

Block returns Block:
    '{' statements+=Statement* '}';

Statement returns Statement:
    (SetSpeedStmt | IfStmt | LoopStmt | VariableAffStmt | Variable | MovementStmt | RotationStmt | FunctionCallStmt | ReturnStmt)
;

ReturnStmt returns ReturnStmt:
    'return' expr=Expression;

Expression returns Expression:
    NumeralExpression | BooleanExpression;

NumeralExpression returns ArithmeticOp:
    left=MultiplicativeExpression (operator=('+' | '-') right=MultiplicativeExpression)*;

MultiplicativeExpression returns ArithmeticOp:
    left=UnaryExpression (operator=('*' | '/') right=UnaryExpression)*
;

UnaryExpression returns Expression:
    (Opposite | NumeralPrimaryExpression);

Opposite returns Opposite:
    '-' expr=NumeralPrimaryExpression;

NumeralPrimaryExpression returns Expression:
    NumeralConst | LiteralExpression;

NumeralConst returns NumeralConst:
    {NumeralConst} value=DOUBLE ('in' unit=Unit)?
;

SensorFunctionCall returns SensorFunctionCall:
    {SensorFunctionCall} ('getDistance()' | 'getTimestamp()') ('in' unit=Unit)?
;

BooleanExpression returns LogicOp:
    left=AndExpression (operator='or' right=AndExpression)*
;

AndExpression returns LogicOp:
    left=ComparisonExpression (operator='and' right=ComparisonExpression)*
;

ComparisonExpression returns ComparisonOp:
    (left=NumeralPrimaryExpression (operator=ComparisonOperator right=NumeralPrimaryExpression)?) | BooleanPrimaryExpression
;

BooleanPrimaryExpression returns Expression:
    BooleanConst | LiteralExpression
;

BooleanConst returns BooleanConst:
    {BooleanConst} value=BOOLEAN;

Not returns Not:
    'not' expr=BooleanPrimaryExpression;

LiteralExpression returns Expression:
    VariableRef | FunctionCall | Not | '(' Expression ')' | SensorFunctionCall
;

FunctionCall returns FunctionCall:
    ref=[FunctionDef:ID] ( '()' | '(' parameters+=Expression  ("," parameters+=Expression  )* ')')
;

VariableRef returns VariableRef:
    decl=[Variable:ID]
;

IfStmt returns IfStmt:
    'if' condition=Expression 'then' then=Block
    ( 'else' 'if' condition=Expression 'then' elseif=Block )*
    ( 'else' else=Block )?
;

LoopStmt returns LoopStmt:
    'loop' condition=Expression block=Block;

Variable returns Variable:
    'var' type=VarType name=ID '=' value=VariableValue;

VariableAffStmt returns VariableAffStmt:
    {VariableAffStmt} decl=[Variable:ID] '=' expr=Expression;

MovementStmt returns MovementStmt:
    direction=Direction expr=Expression;

RotationStmt returns RotationStmt:
    rotation=RotationDirection degrees=Expression;

SetSpeedStmt returns SetSpeedStmt:
    'setSpeed(' value=Expression ')';

FunctionCallStmt returns FunctionCallStmt:
    {FunctionCallStmt} voidfct=[FunctionDef:ID] ( '()' | '(' parameters+=Expression  ("," parameters+=Expression  )* ')')
;

Unit returns Unit:
    'mm' | 'cm';

ComparisonOperator returns ComparisonOperator:
    '<' | '<=' | '==' | '>=' | '>' | '!=';

VariableValue returns VariableValue:
    {VariableValue} value=Expression;

VarType returns VarType:
    'number' | 'bool';

Direction returns Direction:
    'Forward' | 'Backward' | 'Left' | 'Right';

RotationDirection returns RotationDirection:
    'Clock' | 'CounterClock';

FunctionType returns FunctionType:
    VarType | 'void';