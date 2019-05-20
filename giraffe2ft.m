

%% Execute this script (not just this block) to 
rootDirectory = mfilename('fullpath');
rootDirectory = rootDirectory(1:end - length(mfilename()));
cd(rootDirectory);
rootDirectory = pwd();

%%
toolboxLocation = '/home/common/matlab/fieldtrip';
saveLocation = fullfile(rootDirectory, 'GIRAFFE'); 

%
categoryName = 'fieldtrip';
filenames = dir(fullfile(toolboxLocation, 'ft_*.m'));
filenames = filenames(~[filenames(:).isdir]);

nodes = cell(1, length(filenames));
for j = 1:length(filenames)

    node = [];
    file = fullfile(toolboxLocation, filenames(j).name);
    f = fopen(file);
    numberOfPorts = 0;
    ports = [];
    while true
        
        line = fgetl(f);
        if line == -1
            break
        end
        
        if strfind(line, '%') ~= 1
            continue;
        end
        if strfind(line, '%   cfg.') == 1
             numberOfPorts = numberOfPorts + 1;
             ports(numberOfPorts).input = true;
             ports(numberOfPorts).output = true;
             ports(numberOfPorts).visible = true;
             ports(numberOfPorts).editable = true;
            
             template = '%%  cfg.%s = %s';
             parsed = textscan(line, template);
             [parameter, comment] = deal(parsed{:});
             ports(numberOfPorts).name = parameter{1};
            
             code = [];
             code.language = categoryName;
             code.argument.name = line(5:end);
             ports(numberOfPorts).code = {code};
        end
    end
    fclose(f);
    node.toolbox = categoryName;
    node.category = {categoryName};
    node.name = filenames(j).name(1:end - 2);
    node.code = {code};
    node.web_url = ['https://github.com/fieldtrip/fieldtrip/tree/master/' node.name '.m'];
    node.ports = ports;

    nodes{j} = node;
end

toolbox = [];
ft = [];
ft.name = categoryName;
ft.nodes = nodes;

%%
f = fopen(fullfile(saveLocation, 'fieldtrip.JSON'), 'w');
options.ParseLogical = true;
% options.Compact = true;
fwrite(f, savejson('toolboxes', {ft}, options));
fclose(f);







