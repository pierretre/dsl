import { ArithmeticOp, BinaryOp, Block, BooleanConst, ComparisonOp, ElseIf, Entrypoint, Expression, FunctionCall, FunctionCallStmt, FunctionDef, IfStmt, LiteralExpression, LogicOp, LoopStmt, MovementStmt, Not, NumeralConst, Opposite, ReturnStmt, RoboMlValidationVisitor, RoboProgram, RotationStmt, SensorFunctionCall, SetSpeedStmt, Statement, UnaryOp, Variable, VariableAffStmt, VariableRef, VariableValue } from "./robo-ml-visitor.js";

export class RobMlInterpreter extends RoboMlValidationVisitor {
    override visitBlock(node: Block) {
        throw new Error("Method not implemented.");
    }
    override visitElseIf(node: ElseIf) {
        throw new Error("Method not implemented.");
    }
    override visitEntrypoint(node: Entrypoint) {
        throw new Error("Method not implemented.");
    }
    override visitExpression(node: Expression) {
        throw new Error("Method not implemented.");
    }
    override visitBinaryOp(node: BinaryOp) {
        throw new Error("Method not implemented.");
    }
    override visitArithmeticOp(node: ArithmeticOp) {
        throw new Error("Method not implemented.");
    }
    override visitComparisonOp(node: ComparisonOp) {
        throw new Error("Method not implemented.");
    }
    override visitLogicOp(node: LogicOp) {
        throw new Error("Method not implemented.");
    }
    override visitLiteralExpression(node: LiteralExpression) {
        throw new Error("Method not implemented.");
    }
    override visitBooleanConst(node: BooleanConst) {
        throw new Error("Method not implemented.");
    }
    override visitFunctionCall(node: FunctionCall) {
        throw new Error("Method not implemented.");
    }
    override visitNumeralConst(node: NumeralConst) {
        throw new Error("Method not implemented.");
    }
    override visitSensorFunctionCall(node: SensorFunctionCall) {
        throw new Error("Method not implemented.");
    }
    override visitVariableRef(node: VariableRef) {
        throw new Error("Method not implemented.");
    }
    override visitUnaryOp(node: UnaryOp) {
        throw new Error("Method not implemented.");
    }
    override visitNot(node: Not) {
        throw new Error("Method not implemented.");
    }
    override visitOpposite(node: Opposite) {
        throw new Error("Method not implemented.");
    }
    override visitFunctionDef(node: FunctionDef) {
        throw new Error("Method not implemented.");
    }
    override visitRoboProgram(node: RoboProgram) {
        throw new Error("Method not implemented.");
    }
    override visitStatement(node: Statement) {
        throw new Error("Method not implemented.");
    }
    override visitFunctionCallStmt(node: FunctionCallStmt) {
        throw new Error("Method not implemented.");
    }
    override visitIfStmt(node: IfStmt) {
        throw new Error("Method not implemented.");
    }
    override visitLoopStmt(node: LoopStmt) {
        throw new Error("Method not implemented.");
    }
    override visitMovementStmt(node: MovementStmt) {
        throw new Error("Method not implemented.");
    }
    override visitReturnStmt(node: ReturnStmt) {
        throw new Error("Method not implemented.");
    }
    override visitRotationStmt(node: RotationStmt) {
        throw new Error("Method not implemented.");
    }
    override visitSetSpeedStmt(node: SetSpeedStmt) {
        throw new Error("Method not implemented.");
    }
    override visitVariableAffStmt(node: VariableAffStmt) {
        throw new Error("Method not implemented.");
    }
    override visitVariable(node: Variable) {
        throw new Error("Method not implemented.");
    }
    override visitVariableValue(node: VariableValue) {
        throw new Error("Method not implemented.");
    }
}
