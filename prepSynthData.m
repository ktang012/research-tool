numObjects = 60;
noiseLengthStart = 300;
noiseLengthEnd = 600;

objectLengthStart = 150;
objectLengthEnd = 250;

indexSoFar = 1;

synData = [];
synBounds = [];
synLabels = [];

for i=1:numObjects
    % variable length noise
    randomLengthStart = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
    randomLengthEnd = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
    noiseStart = randn(1,randomLengthStart) * 0.35;
    noiseEnd = randn(1,randomLengthEnd) * 0.35;
    
    randomLengthObject = abs(round((objectLengthEnd-objectLengthStart)*rand(1) + objectLengthStart));
    
    rngesus = rand(1);
    if rngesus >= 0.80
        % generate class A
        object = [];
        for i=1:randomLengthObject
            if i < randomLengthObject/3
                object = [object -1];
            elseif i >= randomLengthObject/3 && i <= (randomLengthObject*2)/3
                object = [object 1];
            else
                object = [object -1];
            end
        end
        object = object + randn(1,length(object)) * 0.25;
    elseif rngesus >= 0.60
        % generate class B - flipped and smoothed sine wave
        x = 0:pi/randomLengthObject:2*pi;
        y = sin(x);
        object = y + randn(1,length(y)) * 0.5;
        object = smooth(fliplr(object))';
    else
        % generate class C - sine wave
        x = 0:pi/randomLengthObject:2*pi;
        y = sin(x);
        object = y + randn(1,length(y)) * 0.5;
    end
    
    
    synData = [synData noiseStart object noiseEnd];
    synBounds = [synBounds; indexSoFar indexSoFar+length(noiseStart)];
    indexSoFar = indexSoFar + length(noiseStart);
    synBounds = [synBounds; indexSoFar indexSoFar+length(object)];
    indexSoFar = indexSoFar + length(object);
    synBounds = [synBounds; indexSoFar indexSoFar+length(noiseEnd)];
    indexSoFar = indexSoFar + length(noiseEnd);
      
    synLabels = [synLabels;0;1;0];  
end
synData = synData';

queryLabel = 1;
mpData = [];
for i=1:length(synLabels)
    if synLabels(i) == queryLabel
       startInd = synBounds(i,1);
       endInd = synBounds(i,2);
       m = synData(startInd:endInd);
       mpData = [mpData; m];
    end
end

data = synData;
regions = synBounds;
regionLabels = synLabels;

%plotNNs(synData,[],0,synBounds,synLabels,1)
save('synSet2', 'data','regions','regionLabels');



