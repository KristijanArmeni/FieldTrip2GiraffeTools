module.exports = () => {
    const LANGUAGE = 'fieldtrip';

    async function writeCode(nodes, links) {
        return "Fieldtrip test code"
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