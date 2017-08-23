function [dictStruct] = dictMatrix2dictStruct(dictMatrix)
% Converts a n x m matrix, where each column is a template, to struct
% (1,m) is the label of the template
% (2,m) is the threshold of the template
% (3,m) is the length of the template
% (4:n,m) are the values of the z-normalized template
% n is the length of the longest template in the dictionary
% Shorter templates are NaN-padded
% The fields of the struct are template, length, and threshold

% Iterate over columns
dictStruct = [];
dictEntry = struct('label',inf,'threshold',inf,'length',inf,'template',[]);
for i=1:size(dictMatrix,2)
    dictEntry.label = dictMatrix(1,i);
    dictEntry.threshold = dictMatrix(2,i);
    dictEntry.length = dictMatrix(3,i);
    dictEntry.template = dictMatrix(4:dictEntry.length+4-1)';
    dictStruct = [dictStruct; dictEntry];
end
end

