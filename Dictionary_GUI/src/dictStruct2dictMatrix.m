function [dictMatrix] = dictStruct2dictMatrix(dictStruct)
% Converts a dictionary mat file to a n x m matrix, where each column is a
% template
% (1,m) is the label of the template
% (2,m) is the threshold of the template
% (3,m) is the length of the template
% (4:n,m) are the values of the z-normalized template
% n is the length of the longest template in the dictionary
% Shorter templates are NaN-padded

maxLen = 0;
for i=1:length(dictStruct)
    templateLen = length(dictStruct(i).template);
    if templateLen > maxLen
       maxLen = templateLen; 
    end
end

dictMatrix = ones(maxLen+4-1,length(dictStruct)) * NaN;
for i=1:length(dictStruct)
   dictMatrix(1,i) = dictStruct(i).label;
   dictMatrix(2,i) = dictStruct(i).threshold;
   dictMatrix(3,i) = dictStruct(i).length;
   
   templateLen = length(dictStruct(i).template);
   dictMatrix(4:templateLen+4-1,i) = dictStruct(i).template;
end
end

