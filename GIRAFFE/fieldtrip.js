module.exports = () => {
    const LANGUAGE = 'fieldtrip';
    const newline = '\n';

    function writePreamble(){
      return `% Code generated by GiraffeTools`
    }

    function parameterToCode(parameter){
      const codeArgument = parameter.code && parameter.code.find((a) => a.language === LANGUAGE);
      return `cfg.${codeArgument.name} = ${parameter.value} % ${codeArgument.comment};` + newline;
    }

    function itemToCode(node){
      let code = "";
      code += "cfg = [];" + newline;
      // #TODO add in parameters
      code += node.parameters
        .filter(parameter => parameter.value !== undefined && parameter.value !== "")
        .map(parameter => parameterToCode(parameter))
        .join("");

      const codeArgument = node.code && node.code.find((a) => a.language === LANGUAGE);
      code += `${codeArgument.argout} = ${codeArgument.call};` + newline;

      return code;
    }

    function writeNodes(nodes, links){
      return nodes.map(node => itemToCode(node)).join(newline);
    }

    function writePostamble() {
      return "% end of script"
    }

    async function writeCode(nodes, links) {
        const preamble = writePreamble();
        const nodeCode = writeNodes(nodes, links);
        const postAmble = writePostamble();
        return [preamble, nodeCode, postAmble].join(newline);
    }

    async function writeFiles(nodes, links) {
        const fieldtripFilename = 'GIRAFFE/code/fieldtrip.m';
        return {
            [fieldtripFilename]: await writeCode(nodes)
        }
    }

    return {
        writeCode,
        writeFiles,
    }
}
