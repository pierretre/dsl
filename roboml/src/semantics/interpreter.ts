import { Robot } from "../web/simulator/entities.js";
import { BaseScene, Scene } from "../web/simulator/scene.js";
import { ArithmeticOp, BinaryOp, Block, BooleanConst, ComparisonOp, ElseIf, Entrypoint, Expression, FunctionCall, FunctionCallStmt, FunctionDef, IfStmt, LiteralExpression, LogicOp, LoopStmt, MovementStmt, Not, NumeralConst, Opposite, ReturnStmt, RoboMlVisitor, RoboProgram, RotationStmt, SensorFunctionCall, SetSpeedStmt, Statement, UnaryOp, Variable, VariableAffStmt, VariableRef, VariableValue } from "./robo-ml-visitor.js";

export class RobMlInterpreter implements RoboMlVisitor {

    private scene: Scene;
    private robot: Robot;
    private varTable: Map<string, Expression>;
    private funcTable: Map<string, FunctionDef>;

    constructor() {
        this.scene = new BaseScene();
        this.robot = this.scene.robot;
        this.varTable = new Map<string, Expression>();
        this.funcTable = new Map<string, FunctionDef>();
    }

    visitBlock(node: Block) {
        throw new Error("Method not implemented.");
    }
    visitElseIf(node: ElseIf) {
        throw new Error("Method not implemented.");
    }
    visitEntrypoint(node: Entrypoint) {
        throw new Error("Method not implemented.");
    }
    visitExpression(node: Expression) {
        throw new Error("Method not implemented.");
    }
    visitBinaryOp(node: BinaryOp) {
        throw new Error("Method not implemented.");
    }
    visitArithmeticOp(node: ArithmeticOp) {
        throw new Error("Method not implemented.");
    }
    visitComparisonOp(node: ComparisonOp) {
        throw new Error("Method not implemented.");
    }
    visitLogicOp(node: LogicOp) {
        throw new Error("Method not implemented.");
    }
    visitLiteralExpression(node: LiteralExpression) {
        throw new Error("Method not implemented.");
    }
    visitBooleanConst(node: BooleanConst) {
        throw new Error("Method not implemented.");
    }
    visitFunctionCall(node: FunctionCall) {
        throw new Error("Method not implemented.");
    }
    visitNumeralConst(node: NumeralConst) {
        throw new Error("Method not implemented.");
    }
    visitSensorFunctionCall(node: SensorFunctionCall) {
        throw new Error("Method not implemented.");
    }
    visitVariableRef(node: VariableRef) {
        throw new Error("Method not implemented.");
    }
    visitUnaryOp(node: UnaryOp) {
        throw new Error("Method not implemented.");
    }
    visitNot(node: Not) {
        throw new Error("Method not implemented.");
    }
    visitOpposite(node: Opposite) {
        throw new Error("Method not implemented.");
    }
    visitFunctionDef(node: FunctionDef) {
        throw new Error("Method not implemented.");
    }
    visitRoboProgram(node: RoboProgram) {
        node.entrypoint.accept(this);
    }
    visitStatement(node: Statement) {
        throw new Error("Method not implemented.");
    }
    visitFunctionCallStmt(node: FunctionCallStmt) {
        throw new Error("Method not implemented.");
    }
    visitIfStmt(node: IfStmt) {
        throw new Error("Method not implemented.");
    }
    visitLoopStmt(node: LoopStmt) {
        throw new Error("Method not implemented.");
    }
    visitMovementStmt(node: MovementStmt) {
        throw new Error("Method not implemented.");
    }
    visitReturnStmt(node: ReturnStmt) {
        throw new Error("Method not implemented.");
    }
    visitRotationStmt(node: RotationStmt) {
        throw new Error("Method not implemented.");
    }
    visitSetSpeedStmt(node: SetSpeedStmt) {
        throw new Error("Method not implemented.");
    }
    visitVariableAffStmt(node: VariableAffStmt) {
        throw new Error("Method not implemented.");
    }
    visitVariable(node: Variable) {
        throw new Error("Method not implemented.");
    }
    visitVariableValue(node: VariableValue) {
        throw new Error("Method not implemented.");
    }

}


/**
 *     override visitGreeting(node: Greeting) {}

    override visitModel(node: Model) {
        node.persons.forEach(person => this.visitPerson(person));
    }
    
    override visitPerson(node: Person) {
        if (node.name.charAt(0) !== node.name.charAt(0).toUpperCase()) {
            this.validationAccept("error", "Person name should start with a capital letter.", { node: node, property: "name" });
        }
    }
 */