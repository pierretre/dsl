import { EmptyFileSystem, URI } from 'langium';
import { startLanguageServer } from 'langium/lsp';
import { BrowserMessageReader, BrowserMessageWriter, createConnection } from 'vscode-languageserver/browser.js';
import { createRoboMlServices } from './robo-ml-module.js';
import { RoboProgram } from './generated/ast.js';

declare const self: DedicatedWorkerGlobalScope;

const messageReader = new BrowserMessageReader(self);
const messageWriter = new BrowserMessageWriter(self);

const connection = createConnection(messageReader, messageWriter);

const { shared } = createRoboMlServices({ connection, ...EmptyFileSystem });

startLanguageServer(shared);

function getModelFromUri(uri: string): RoboProgram | undefined {
    const document = shared.workspace.LangiumDocuments.getDocument(URI.parse(uri));
    if (document && document.diagnostics === undefined || document?.diagnostics?.filter((i) => i.severity === 1).length === 0) {
        return document.parseResult.value as RoboProgram;
    }
    return undefined;
}

connection.onNotification("custom/hello", (uri: string) => connection.sendNotification("custom/hello", getModelFromUri(uri)));

