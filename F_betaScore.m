function [score] = F_betaScore(precision, recall, beta)
% F beta score

score =  (1 + beta^2) .* (precision .* recall)./((beta^2 .* precision) + recall);

end

