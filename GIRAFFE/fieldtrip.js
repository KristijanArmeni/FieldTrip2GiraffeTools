module.exports = () => {
    const LANGUAGE = 'Fieldtrip';

    const writeCode = () => "Fieldtrip test code"
    const writeCode = () => {
        const fieldtripFilename = 'GIRAFFE/code/Dockerfile';
        return {
            [fieldtripFilename]: await writeCode(nodes),
        }
    }

    return {
        writeCode,
        writeFiles,
    }
}


// const writePreamble = (nodes) => {
//   const preamble = `% This is a Fieldtrip generator. Warning, here be dragons.`;
//   return preamble;
// };

// const writeNodes = (nodes) => {
//   const code = nodes && nodes.map((node) => itemToCode(node));
//   return code && code.join('\r\n');
// };

// const itemToCode = (node) => {
//   const codeArgument =
//     node.code && node.code.find((a) => a.language === LANGUAGE);
//   if (!codeArgument) {
//     return '';
//   }

//   const code = ``;
//   return code;
// };

// const writePostamble = () => {
//   const code = '\r\n';
//   return code;
// };

// export function writeCode(nodes, links) {
//   const preamble = writePreamble(nodes);
//   const nodeCode = writeNodes(nodes);
//   // const parameters = writeParameters();
//   const postAmble = writePostamble();

//   // return [preamble, nodeCode, linkCode, postAmble].join("\r\n");
//   return [preamble, nodeCode, postAmble].join('\r\n');
// }
