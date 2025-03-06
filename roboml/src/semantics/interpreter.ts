import { Robot, Timestamp } from "../web/simulator/entities.js";
import { BaseScene, Scene } from "../web/simulator/scene.js";
import {
    ArithmeticOp,
    BinaryOp,
    Block,
    BooleanConst,
    ComparisonOp,
    ElseIf,
    Entrypoint,
    Expression,
    FunctionCall,
    FunctionCallStmt,
    FunctionDef,
    IfStmt,
    LiteralExpression,
    LogicOp,
    LoopStmt,
    MovementStmt,
    Not,
    NumeralConst,
    Opposite,
    ReturnStmt,
    RoboMlVisitor,
    RoboProgram,
    RotationStmt,
    SensorFunctionCall,
    SetSpeedStmt,
    Statement,
    UnaryOp,
    Variable,
    VariableAffStmt,
    VariableRef,
    VariableValue
} from "./robo-ml-visitor.js";

export class RoboMlInterpreter implements RoboMlVisitor {

    public scene: Scene;
    private robot: Robot;
    private varTable: Map<string, any>;
    private funcTable: Map<string, FunctionDef>;

    constructor() {
        this.scene = new BaseScene();
        this.robot = this.scene.robot;
        this.varTable = new Map<string, any>();
        this.funcTable = new Map<string, FunctionDef>();
    }

    visitElseIf(node: ElseIf) {
        console.log("visitElseIf")
        throw new Error("Method not implemented.");
    }

    visitExpression(node: Expression) {
        console.log("visitExpression")
        throw new Error("Method not implemented.");
    }

    visitArithmeticOp(node: ArithmeticOp) {
        console.log("visitArithmeticOp")
        const left = node.left.accept(this);
        if (!node.right) {
            return left;
        }

        console.log("left", left)
        const right = node.right.accept(this);
        console.log("right", right)
        switch (node.operator) {
            case '+': return left + right;
            case '-': return left - right;
            case '*': return left * right;
            case '/': return left / right;
            default: throw new Error('Unsupported arithmetic operator');
        }
    }

    visitComparisonOp(node: ComparisonOp) {
        console.log("visitComparisonOp", node.left, node.operator, node.right)
        const left = node.left.accept(this);
        const right = node.right.accept(this);
        switch (node.operator) {
            case '==': return left === right;
            case '!=': return left !== right;
            case '<': return left < right;
            case '>': return left > right;
            case '<=': return left <= right;
            case '>=': return left >= right;
            default: throw new Error('Unsupported comparison operator');
        }
    }

    visitLogicOp(node: LogicOp) {
        console.log("visitLogicOp")
        const left = node.left.accept(this);
        if (!node.right) {
            return left;
        }

        const right = node.right.accept(this);
        switch (node.operator) {
            case 'and': return left && right;
            case 'or': return left || right;
            default: throw new Error('Unsupported logical operator');
        }
    }

    visitLiteralExpression(node: LiteralExpression) {
        console.log("visitLiteralExpression")
        throw new Error("Method not implemented.");
    }

    visitSensorFunctionCall(node: SensorFunctionCall) {
        console.log("visitSensorFunctionCall")
        throw new Error("Method not implemented.");
    }

    visitUnaryOp(node: UnaryOp) {
        console.log("visitUnaryOp")
        return node.expr.accept(this);
    }

    visitNot(node: Not) {
        console.log("visitNot")
        return !node.expr.accept(this);
    }

    visitOpposite(node: Opposite) {
        console.log("visitOpposite")
        return - node.expr.accept(this);
    }

    visitFunctionDef(node: FunctionDef) {
        console.log("visitFunctionDef")
        throw new Error("Method not implemented.");
    }

    visitStatement(node: Statement) {
        console.log("visitStatement")
        throw new Error("Method not implemented.");
    }

    visitFunctionCallStmt(node: FunctionCallStmt) {
        console.log("visitFunctionCallStmt")
        throw new Error("Method not implemented.");
    }

    visitSetSpeedStmt(node: SetSpeedStmt) {
        console.log("visitSetSpeedStmt")
        throw new Error("Method not implemented.");
    }

    visitVariable(node: Variable) {
        console.log("visitVariable")
        this.varTable.set(node.name, node.value.accept(this));
    }

    visitVariableValue(node: VariableValue) {
        console.log("visitVariableValue")
        return node.value;
    }

    visitRoboProgram(node: RoboProgram) {
        console.log("visitRoboProgram")
        try {
            node.defs.forEach(d => d.accept(this));
            node.entrypoint.accept(this);
        } catch (e) {
            console.error(e);
        }
        console.log(this.scene.timestamps)
    }

    visitBlock(node: Block) {
        console.log("visitBlock")
        node.statements.forEach(s => s.accept(this));
    }

    visitEntrypoint(node: Entrypoint) {
        console.log("visitEntrypoint")
        node.body.accept(this);
    }

    visitNumeralConst(node: NumeralConst) {
        console.log("visitNumeralConst")
        return node.value;
    }

    visitBooleanConst(node: BooleanConst) {
        console.log("visitBooleanConst")
        return node.value;
    }

    visitVariableRef(node: VariableRef) {
        console.log("visitVariableRef")
        const varName = node.decl.ref?.name;
        if (varName == undefined) {
            throw new Error("Unknown variable ref: " + varName);
        }
        return this.varTable.get(varName);
    }

    visitVariableAffStmt(node: VariableAffStmt) {
        console.log("visitVariableAffStmt")
        if (node.decl && node.expr) {
            const varName = node.decl.ref?.name;
            if (varName == undefined) {
                throw new Error("Unknown variable ref: " + varName);
            }
            this.varTable.set(varName, node.expr.accept(this));
        }
    }

    visitBinaryOp(node: BinaryOp) {
        console.log("visitBinaryOp")
        switch (node.$type) {
            case 'ArithmeticOp':
                return this.visitArithmeticOp(node as ArithmeticOp);
            case 'ComparisonOp':
                return this.visitComparisonOp(node as ComparisonOp);
            case 'LogicOp':
                return this.visitLogicOp(node as LogicOp);
            default: return;
        }
    }

    visitIfStmt(node: IfStmt) {
        console.log("visitIfStmt")
        if (node.condition.accept(this)) {
            node.thenBlock.accept(this);
        } else if (node.elseBlock) {
            node.elseBlock.accept(this);
        }
    }

    visitLoopStmt(node: LoopStmt) {
        console.log("visitLoopStmt")
        while (node.condition.accept(this)) {
            node.block.accept(this);
        }
    }

    visitMovementStmt(node: MovementStmt) {
        console.log("visitMovementStmt", node)
        const distance = node.expr.accept(this);
        console.log("distance", distance)
        switch (node.direction) {
            case 'Forward':
                this.robot.move(distance);
                break;
            case 'Backward':
                this.robot.move(-distance);
                break;
            case 'Left':
                this.robot.side(distance);
                break;
            case 'Right':
                this.robot.side(-distance);
                break;
            default: throw new Error('Unsupported movement direction');
        }

        this.saveMove();
    }

    visitRotationStmt(node: RotationStmt) {
        console.log("visitRotationStmt")
        const degrees = node.degrees.accept(this);

        switch (node.rotation) {
            case 'CounterClock':
                this.robot.turn(degrees);
                break;
            case 'Clock':
                this.robot.turn(-degrees);
                break;
            default: throw new Error('Unsupported rotation direction');
        }

        this.saveMove();
    }

    saveMove() {
        const time = this.scene.timestamps[this.scene.timestamps.length - 1].time + 1000;
        this.scene.timestamps.push(new Timestamp(time, this.robot));
    }

    visitFunctionCall(node: FunctionCall) {
        console.log("visitFunctionCall")
        const funcName = node.ref.ref?.name
        if (funcName == null) {
            throw new Error("Unknown func: " + funcName);
        }
        const func = this.funcTable.get(funcName);
        if (!func) throw new Error(`Function ${node.ref.ref?.name} not found`);

        const paramValues = node.parameters.map(p => p.accept(this));

        func.parameters.forEach((param, i) => {
            this.varTable.set(param.name, paramValues[i]);
        });

        return func.body.accept(this);
    }

    visitReturnStmt(node: ReturnStmt) {
        console.log("visitReturnStmt")
        return node.expr.accept(this);
    }
}