function setup_nerds
%SETUP_NERDS include path for nerds

if isunix
    path(path);
    path(path, [pwd, '/utilities']);
    path(path, [pwd, '/spgl1_extend']);
elseif ispc
    path(path);
    path(path, [pwd, '\utilities']);
    path(path, [pwd, '\spgl1_extend']);
else
    path(path);
    path(path, [pwd, '/utilities']);
    path(path, [pwd, '/spgl1_extend']);
end

end