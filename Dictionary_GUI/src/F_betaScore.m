function [score] = F_betaScore(precision, recall, beta)
% F beta score
betaSq = beta^2;
score =  (1 + betaSq) .* (precision .* recall)./((betaSq .* precision) + recall);

end

