

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
    
    lineCount = 0;
    
    code = [];
    while true
        
        % write parsed code elements in this var
        code.language = categoryName;
        
        lineCount = lineCount + 1;
        
        line = fgetl(f);
        if line == -1
            break
        end
        
        % check if there are output arguments in function definition (= line 1)
        if lineCount == 1 && ~isempty(regexp(line, 'function.*=', 'once'))
        
            % look for any text between 'function' and '=' sign
            outputArg = regexp(line, '(?<=function.)(.*)(?=.=)', 'match');
            if ~isempty(outputArg)
                hasOutput = true;
                %outputArg{1}(regexp(outputArg{1}, '[\[,\]]')) = []; % remove '[' and ']'
            end
        
            code.argout.exist = hasOutput;
            code.argout.name = outputArg;
            
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
            
             % parse the parameter option string
             template = '%%  cfg.%s = %s';
             parsed = textscan(line, template);
             [parameter, comment] = deal(parsed{:});
             ports(numberOfPorts).name = parameter{1};
            
             code.cfgfields.name = line(5:end);
             ports(numberOfPorts).code = {code};
        end
        
        
    end
    % fprintf('\n%d Found %s output argument for %s', lineCount, outputArg{1}, filenames(j).name(1:end - 2))

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
f = fopen(fullfile(saveLocation, 'fieldtrip-test.JSON'), 'w');
options.ParseLogical = true;
% options.Compact = true;
fwrite(f, savejson('toolboxes', {ft}, options));
fclose(f);
