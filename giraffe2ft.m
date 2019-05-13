
%% Node Files
toolboxLocation = '/home/common/matlab/fieldtrip';

saveLocation = '~/project/giraffe2ft/'; 

%
categoryName = 'fieldtrip';
filenames = dir(fullfile(toolboxLocation, 'ft_*.m'));
filenames = filenames(~[filenames(:).isdir]);

nF = 1;
nodes = [];
for j = 1:length(filenames)

    file = fullfile(toolboxLocation, filenames(j).name);
    f = fopen(file);
    numberOfPorts = 0;
    ports = [];
    while true
        line = fgetl(f);
        if strfind(line, '%') ~= 1  
            break;
        end
        if strfind(line, '%   cfg.') == 1
            disp(line)
%             numberOfPorts = numberOfPorts + 1;
%             ports(numberOfPorts).input = true;
%             ports(numberOfPorts).output = true;
%             ports(numberOfPorts).visible = true;
%             ports(numberOfPorts).editable = true;
%             ports(numberOfPorts).name = line(5:end);
%             code = [];
%             code.language = categoryName;
%             code.argument.name = line(5:end);
%             ports(numberOfPorts).code = {code};
        end
    end
    fclose(f);
    title = [];
%     title.web_url = ['https://github.com/TimVanMourik/OpenFmriAnalysis/tree/master/Interface/', filenames(j).name];
%     title.name = filenames(j).name(1:end - 2);
    title.code = [];
    code = [];
    code.language = categoryName;
    code.comment  = '';
%     code.argument.name = filenames(j).name(1:end - 2);
    title.code = {code};
%     nodes(nF).category = {categoryName, filenames(i).name};
%     nodes(nF).title = title;
%     nodes(nF).ports = ports;

    nF = nF + 1;
end

%%
f = fopen(fullfile(saveLocation, 'tvm.JSON'), 'w');
options.ParseLogical = true;
fwrite(f, savejson('nodes', nodes, options));
fclose(f);







