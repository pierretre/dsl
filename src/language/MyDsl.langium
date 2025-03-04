grammar MyDsl
import 'Terminals'
import 'idm-types'
import 'XMLType-types'

entry RoboProgram returns RoboProgram:
    'RoboProgram' '{' 'entrypoint' entrypoint=Entrypoint  ('function' '{' function+=FunctionDef  ("," function+=FunctionDef  )* '}' )? '}'  
;

Statement returns Statement:
    SetSpeedStmt | IfStmt | LoopStmt | VariableDeclStmt | MovementStmt | RotationStmt | FunctionCallStmt 
;

Expression returns Expression:
    NumeralConst | VariableRef | ComparisonOp | BooleanConst | Not | LogicOp | Opposite | ArithmeticOp | FunctionCall 
;

Entrypoint returns Entrypoint:
    {Entrypoint} 'Entrypoint' '{' ('statements' '{' statements+=Statement  ("," statements+=Statement  )* '}' )? '}'  
;

FunctionDef returns FunctionDef:
    'FunctionDef' '{' ('name' name=String0  )? ('returnType' returnType=FunctionType  )? 'statements' '{' statements+=Statement  ("," statements+=Statement  )* '}' ('parameters' '{' parameters+=Parameter  ("," parameters+=Parameter  )* '}' )? '}'  
;

Comment returns Comment:
    {Comment} 'Comment' '{' ('value' value=String0  )? '}'  
;

SetSpeedStmt returns SetSpeedStmt:
    'SetSpeedStmt' '{' ('comment' comment=Comment  )? 'value' value=Expression  '}'  
;

IfStmt returns IfStmt:
    'IfStmt' '{' ('comment' comment=Comment  )? ('then' '{' then+=Statement  ("," then+=Statement  )* '}' )? 'condition' condition=Expression  ('else' '{' else+=Statement  ("," else+=Statement  )* '}' )? '}'  
;

LoopStmt returns LoopStmt:
    'LoopStmt' '{' ('comment' comment=Comment  )? ('instruction' '{' instruction+=Statement  ("," instruction+=Statement  )* '}' )? 'condition' condition=Expression  '}'  
;

VariableDeclStmt returns VariableDeclStmt:
    'VariableDeclStmt' '{' ('newAttribute' newAttribute=VarType  )? ('comment' comment=Comment  )? 'variable' variable=Variable  'initialexpr' initialexpr=Expression  '}'  
;

MovementStmt returns MovementStmt:
    'MovementStmt' '{' ('direction' direction=Direction  )? ('comment' comment=Comment  )? 'expr' expr=Expression  '}'  
;

RotationStmt returns RotationStmt:
    'RotationStmt' '{' ('rotation' rotation=RotationDirection  )? ('comment' comment=Comment  )? 'degrees' degrees=Expression  '}'  
;

FunctionCallStmt returns FunctionCallStmt:
    {FunctionCallStmt} 'FunctionCallStmt' '{' ('voidfct' voidfct=[FunctionDef:STRING ] )? ('comment' comment=Comment  )? ('parameters' '{' parameters+=Expression  ("," parameters+=Expression  )* '}' )? '}'  
;

String0 returns String:
    'String' 
;

Unit returns Unit:
    Unit_NONE | Unit_MM | Unit_CM
;
Unit_NONE returns Unit_NONE: 'NONE' ;
Unit_MM returns Unit_MM: 'MM' ;
Unit_CM returns Unit_CM: 'CM' ;

NumeralConst returns NumeralConst:
    {NumeralConst} 'NumeralConst' '{' ('unit' unit=Unit  )? ('value' value=Double  )? '}'  
;

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

Double returns Double:
    'Double' 
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

