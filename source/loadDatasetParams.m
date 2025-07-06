function params = loadDatasetParams(datasetName, jsonPath)
    if ~isfile(jsonPath)
        error('Parameter file "%s" does not exist.', jsonPath);
    end
    fid = fopen(jsonPath, 'r');
    if fid == -1
        error('Cannot open parameter file "%s"', jsonPath);
    end
    raw = fread(fid, inf, 'char');
    fclose(fid);

    jsonStr = char(raw');
    all_params = jsondecode(jsonStr);

    if isfield(all_params, datasetName)
        params = all_params.(datasetName);
    else
        error('Dataset parameter named "%s" not found in JSON file.', datasetName);
    end
end
