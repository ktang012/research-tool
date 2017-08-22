function [val] = assertDictFields(dataDict)
% Checks for fields 'template', 'threshold', 'length'
val = isfield(dataDict,{'template','threshold','length'});
end

