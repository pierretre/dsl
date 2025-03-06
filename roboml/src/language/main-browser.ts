import { EmptyFileSystem, URI } from 'langium';
import { startLanguageServer } from 'langium/lsp';
import { BrowserMessageReader, BrowserMessageWriter, createConnection } from 'vscode-languageserver/browser.js';
import { createRoboMlServices } from './robo-ml-module.js';
import { RoboProgram } from '../semantics/robo-ml-visitor.js';

declare const self: DedicatedWorkerGlobalScope;

const messageReader = new BrowserMessageReader(self);
const messageWriter = new BrowserMessageWriter(self);

const connection = createConnection(messageReader, messageWriter);

const { shared, RoboMl } = createRoboMlServices({ connection, ...EmptyFileSystem });

startLanguageServer(shared);

function getModelFromUri(uri: string): RoboProgram | undefined {
    const document = shared.workspace.LangiumDocuments.getDocument(URI.parse(uri));
    if (document && document.diagnostics === undefined || document?.diagnostics?.filter((i) => i.severity === 1).length === 0) {
        return document.parseResult.value as RoboProgram;
    }
    return undefined;
}

function execute(uri: string) {
    console.log("rec oya")
    const model = getModelFromUri(uri) as RoboProgram;
    const interpreter = RoboMl.visitors.RoboMlInterpreter;
    interpreter.visitRoboProgram(model);
    console.log("scene: ", interpreter.scene)
    connection.sendNotification("custom/result", interpreter.scene);
}

connection.onNotification("custom/validate", (uri: string) => connection.sendNotification("custom/validate", getModelFromUri(uri)));
connection.onNotification("custom/execute", (uri) => execute(uri));

