import type { ValidationAcceptor, ValidationChecks } from 'langium';
import { type RoboMlAstType, type RoboProgram, type FunctionDef, Block, isIfStmt, isLoopStmt, isReturnStmt, Expression, FunctionType, ReturnStmt, isNumeralConst, isArithmeticOp, isBooleanConst, isLogicOp, isVariableRef, isFunctionCallStmt } from './generated/ast.js';
import type { RoboMlServices } from './robo-ml-module.js';

/**
 * Register custom validation checks.
 */
export function registerValidationChecks(services: RoboMlServices) {
    const registry = services.validation.ValidationRegistry;
    const validator = services.validation.RoboMlValidator;
    const checks: ValidationChecks<RoboMlAstType> = {
        RoboProgram: [
            validator.checkUniqueDefs,
            validator.checkFunctionReturns,
            validator.checkFunctionParameters,
        ],
        FunctionDef: validator.checkUniqueParams
    };
    registry.register(checks, validator);
}

/**
 * Implementation of custom validations.
 */
export class RoboMlValidator {
    // our new validation function for defs
    checkUniqueDefs(model: RoboProgram, accept: ValidationAcceptor): void {
        // create a set of visited functions
        // and report an error when we see one we've already seen
        const reported = new Set();
        model.defs.forEach(d => {
            if (reported.has(d.name)) {
                accept('error', `Def has non-unique name '${d.name}'.`, { node: d, property: 'name' });
            }
            reported.add(d.name);
        });
    }

    checkUniqueParams(def: FunctionDef, accept: ValidationAcceptor): void {
        const reported = new Set();
        def.parameters.forEach(p => {
            if (reported.has(p.name)) {
                accept('error', `Param ${p.name} is non-unique for Def '${def.name}'`, { node: p, property: 'name' });
            }
            reported.add(p.name);
        });
    }

    checkFunctionReturns(model: RoboProgram, accept: ValidationAcceptor): void {
        model.defs.forEach(func => {
            if (func.returnType !== 'void') {
                if (!this.hasValidReturn(func.body, func.returnType, accept, func)) {
                    accept("error", `Function '${func.name}' of type '${func.returnType}' does not return a value for all execution paths.`, { node: func });
                }
            }
        });
    }

    private hasValidReturn(block: Block | undefined, expectedType: FunctionType, accept: ValidationAcceptor, func: FunctionDef): boolean {
        if (!block || !block.statements || block.statements.length === 0) {
            return false;
        }

        let hasReturn = false;

        for (const stmt of block.statements) {
            if (isReturnStmt(stmt)) {
                hasReturn = true;
                this.checkReturnType(stmt, expectedType, accept, func);
            }

            if (isIfStmt(stmt)) {
                const thenHasReturn = this.hasValidReturn(stmt.then, expectedType, accept, func);
                const elseHasReturn = stmt.else ? this.hasValidReturn(stmt.else, expectedType, accept, func) : false;

                if (thenHasReturn && elseHasReturn) {
                    hasReturn = true;
                }
            }

            if (isLoopStmt(stmt)) {
                continue;
            }
        }

        return hasReturn;
    }

    private checkReturnType(returnStmt: ReturnStmt, expectedType: FunctionType, accept: ValidationAcceptor, func: FunctionDef): void {
        const expr = returnStmt.expr;

        if (!expr) {
            accept("error", `The return statement in function '${func.name}' must return value of type '${expectedType}' but is empty`, { node: returnStmt });
            return;
        }

        const actualType = this.inferExpressionType(expr);

        if (actualType !== expectedType) {
            accept("error", `The return statement in function '${func.name}' must return value of type '${expectedType}' but returns '${actualType}'.`, { node: returnStmt });
        }
    }

    private inferExpressionType(expr: Expression): FunctionType {
        if (isNumeralConst(expr) || isArithmeticOp(expr)) {
            return "number";
        }
        if (isBooleanConst(expr) || isLogicOp(expr)) {
            return "bool";
        }
        if (isVariableRef(expr)) {
            return expr.decl.ref?.type ?? "void";
        }
        return "void";
    }

    checkFunctionParameters(model: RoboProgram, accept: ValidationAcceptor): void {
        model.defs.forEach(func => {
            func.parameters.forEach(param => {
                if (param.type !== 'number' && param.type !== 'bool') {
                    accept("error", `Function '${func.name}' has an invalid parameter type '${param.type}'. Expected 'number' or 'bool'.`, { node: param });
                }
            });
        });

        this.checkFunctionCalls(model, accept);
    }

    private checkFunctionCalls(model: RoboProgram, accept: ValidationAcceptor): void {
        const functionMap = new Map<string, FunctionDef>();

        model.defs.forEach(func => functionMap.set(func.name, func));

        model.defs.forEach(func => {
            this.checkFunctionCallsInBlock(func.body, functionMap, accept);
        });

        this.checkFunctionCallsInBlock(model.entrypoint.body, functionMap, accept);
    }

    private checkFunctionCallsInBlock(block: Block | undefined, functionMap: Map<string, FunctionDef>, accept: ValidationAcceptor): void {
        if (!block || !block.statements) return;

        block.statements.forEach(stmt => {
            if (isFunctionCallStmt(stmt)) {
                const funcDef = functionMap.get(stmt.voidfct?.ref?.name || "");

                if (!funcDef) {
                    accept("error", `Function '${stmt.voidfct?.ref?.name}' is not defined.`, { node: stmt });
                    return;
                }

                const expectedParams = funcDef.parameters;
                const actualParams = stmt.parameters;

                if (expectedParams.length !== actualParams.length) {
                    accept("error", `Function '${funcDef.name}' expects ${expectedParams.length} parameters but got ${actualParams.length}.`, { node: stmt });
                    return;
                }

                for (let i = 0; i < expectedParams.length; i++) {
                    const expectedType = expectedParams[i].type;
                    const actualType = this.inferExpressionType(actualParams[i]);

                    if (expectedType !== actualType) {
                        accept("error", `Function '${funcDef.name}': parameter ${i + 1} expects type '${expectedType}' but got '${actualType}'.`, { node: stmt });
                    }
                }
            }

            if (isIfStmt(stmt)) {
                this.checkFunctionCallsInBlock(stmt.then, functionMap, accept);
                if (stmt.else) this.checkFunctionCallsInBlock(stmt.else, functionMap, accept);
                if (stmt.elseif) this.checkFunctionCallsInBlock(stmt.elseif, functionMap, accept);
            }

            if (isLoopStmt(stmt)) {
                this.checkFunctionCallsInBlock(stmt.block, functionMap, accept);
            }
        });
    }

}
