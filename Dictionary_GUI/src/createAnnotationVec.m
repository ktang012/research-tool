function [AV,cmp] = createAnnotationVec(mp,mpData,subLen,type)
% Returns a choice of annotation vector for a matrix profile and the
% corrected matrix profile

AV = zeros(size(mp));

% Simplicity bias - want to bias MP away from simple motifs by using the
% complexity invariant distance
if strcmp(type,'simple')
    for i=1:length(mpData) - subLen + 1
        subseq = mpData(i:i+subLen-1);
        AV(i) = sqrt(sum(diff(subseq).^2));
    end
    AV = AV - min(AV);
    AV = AV / max(AV);    
end

cmp = mp + ((1 - AV) * max(mp));


end

