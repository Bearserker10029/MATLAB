% CheckDuplicates.m
files = dir('*.m'); 
hashes = containers.Map();

for i = 1:length(files)
    file_content = fileread(files(i).name);
    file_hash = DataHash(file_content); % Usa DataHash en lugar de hash
    
    if hashes.isKey(file_hash)
        fprintf('🚨 Archivos duplicados:\n- %s\n- %s\n\n', files(i).name, hashes(file_hash));
    else
        hashes(file_hash) = files(i).name;
    end
end

if hashes.Count == length(files)
    disp('✅ No hay archivos duplicados.');
end