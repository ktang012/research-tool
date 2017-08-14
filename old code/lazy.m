function [B] = lazy(b)
% formatting data from google sheets
B = zeros(length(b)-1,2);
for i=1:length(b)-1
    if i == 1
        B(i,1) = b(i);
        B(i,2) = b(i+1);
    else
        B(i,1) = b(i) + 1;
        B(i,2) = b(i+1);
    end
end
end

