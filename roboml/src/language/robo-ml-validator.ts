import type { ValidationAcceptor, ValidationChecks } from 'langium';
import type { RoboMlAstType, Person } from './generated/ast.js';
import type { RoboMlServices } from './robo-ml-module.js';

/**
 * Register custom validation checks.
 */
export function registerValidationChecks(services: RoboMlServices) {
    const registry = services.validation.ValidationRegistry;
    const validator = services.validation.RoboMlValidator;
    const checks: ValidationChecks<RoboMlAstType> = {
        Person: validator.checkPersonStartsWithCapital
    };
    registry.register(checks, validator);
}

/**
 * Implementation of custom validations.
 */
export class RoboMlValidator {

    checkPersonStartsWithCapital(person: Person, accept: ValidationAcceptor): void {
        if (person.name) {
            const firstChar = person.name.substring(0, 1);
            if (firstChar.toUpperCase() !== firstChar) {
                accept('warning', 'Person name should start with a capital.', { node: person, property: 'name' });
            }
        }
    }

}
