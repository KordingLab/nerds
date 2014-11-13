function setup_nerds
%SETUP_NERDS include path for nerds and compile SPGL1 toolbox

path_temp = pwd;

if isunix
    path(path);
    path(path, [pwd, '/utilities']);
    path(path, [pwd, '/spgl1']);
    path(path, [pwd, '/spgl1_extend']);
    cd('spgl1/')
    spgsetup
    cd(path_temp)
elseif ispc
    path(path);
    path(path, [pwd, '\utilities']);
    path(path, [pwd, '\spgl1']);
    path(path, [pwd, '\spgl1_extend']);
    cd('spgl1/')
    spgsetup
    cd(path_temp)
else
    path(path);
    path(path, [pwd, '/utilities']);
    path(path, [pwd, '/spgl1']);
    path(path, [pwd, '/spgl1_extend']);
    cd('spgl1/')
    spgsetup
    cd(path_temp)
end

end