function change_paths(file_name, operation)
%change_paths Change MATLAB path folders

    data = read_file(file_name);
    paths = string(data{:});

    if operation == 1
        add_paths(paths);
    elseif operation == 2
        remove_paths(paths);
    end
end


function data = read_file(file_name)
    FID = fopen(file_name);
    data = textscan(FID,'%s');
    fclose(FID);
end


function add_paths(paths)
len_paths = length(paths);
    for i=1:len_paths
        generated_path = genpath(paths(i));
        addpath(generated_path)
    end
end


function remove_paths(paths)
    len_paths = length(paths);
    for i=1:len_paths
        rmpath(paths(i));
    end
end


