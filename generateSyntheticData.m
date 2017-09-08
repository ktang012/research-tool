function [data, labels] = ...
    generateSyntheticData();
% Lots of parameters..

% There are several kinds of patterns to embed into the synthetic data
% A: positive half cycle of sine wave
% B: negative half cycle of sine wave
% C: positive square top
% D: negative square top
% E: whole sine wave
% F: flipped sine wave

% Patterns can be multiples of patterns for one class, whereas the other
% class is simply one instance of the pattern. Can the algorithm discern
% the two classes?

% Range of lengths for noise
noiseLengthStart = 300;
noiseLengthEnd = 500;

numClasses = 4;

patternRepeat = [1 1 3 3];
classDist = [0.3 0.25 0.25 0.2];
numObjects = 100;
objectsPerClassRegion = [1 3];

indexSoFar = 1;

data = [];
labels = [];

%{
if length(numClasses) ~= length(classDist)
    disp('Number of classes must match class distribution');
end

if sum(classDist) ~= 1
    disp('Class distribution must equal 1');
end
%}

% For now generate class {A}, {B,D}, 3*{C}, 3*{A}
% Lengths 70, 120, 90, 90
CLASS_A = 1;
CLASS_B = 2;
CLASS_C = 3;
CLASS_D = 4;

CLASS_A_LENGTH = [60 65];
CLASS_B_LENGTH = [80 100];
CLASS_C_LENGTH = [25 30]; % multiplied by 3
CLASS_D_LENGTH = [25 30]; % multiplied by 3

% Noise added to patterns
noiseLevel = 0.2;
% Noise added to noise
noiseWeight = 0.4;

currNumObjects = 0;
while (currNumObjects < numObjects)    
    [~, class] = min(abs(classDist - rand(1)));
    numObjectsToGenerate = randsample(objectsPerClassRegion,1);
    currNumObjects = currNumObjects + numObjectsToGenerate;
    
    switch class
        case CLASS_A
            dataSnippet = [];
            labelSnippet = [];
            for i=1:numObjectsToGenerate
                patternLen = round((CLASS_A_LENGTH(2)-CLASS_A_LENGTH(1)).*rand(1) + CLASS_A_LENGTH(1));
                pattern = generatePosHalfSine(patternLen, noiseLevel);
                
                if numObjectsToGenerate > 1
                    noiseDuringLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
                    noiseDuring = smooth(randn(1,noiseDuringLength) * noiseWeight)';
                    dataSnippet = [dataSnippet pattern noiseDuring];
                    labelSnippet = [labelSnippet CLASS_A * ones(1,length([pattern noiseDuring]))];
                else
                    dataSnippet = pattern;
                    labelSnippet = CLASS_A * ones(1,length(pattern));
                end
            end
        case CLASS_B
            dataSnippet = [];
            labelSnippet = [];
            for i=1:numObjectsToGenerate
                patternLen = round((CLASS_B_LENGTH(2)-CLASS_B_LENGTH(1)).*rand(1) + CLASS_B_LENGTH(1));
                
                if rand(1) > 0.5
                    pattern = generateNegHalfSine(patternLen, noiseLevel);
                else
                    pattern = generateNegSquareTop(patternLen, noiseLevel);
                end
                
                if numObjectsToGenerate > 1
                    noiseDuringLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
                    noiseDuring = smooth(randn(1,noiseDuringLength) * noiseWeight)';
                    dataSnippet = [dataSnippet pattern noiseDuring];
                    labelSnippet = [labelSnippet CLASS_B * ones(1,length([pattern noiseDuring]))];
                else
                    dataSnippet = pattern;
                    labelSnippet = CLASS_B* ones(1,length(pattern));
                end
            end
        case CLASS_C
            dataSnippet = [];
            labelSnippet = [];
            for i=1:numObjectsToGenerate
                patternLen = round((CLASS_C_LENGTH(2)-CLASS_C_LENGTH(1)).*rand(1) + CLASS_C_LENGTH(1));
                pattern = [];
                for j=1:patternRepeat(CLASS_C)
                    p = generatePosSquareTop(patternLen, noiseLevel);
                    pattern = [pattern p];
                end
                
                if numObjectsToGenerate > 1
                    noiseDuringLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
                    noiseDuring = smooth(randn(1,noiseDuringLength) * noiseWeight)';
                    dataSnippet = [dataSnippet pattern noiseDuring];
                    labelSnippet = [labelSnippet CLASS_C * ones(1,length([pattern noiseDuring]))];
                else
                    dataSnippet = pattern;
                    labelSnippet = CLASS_C * ones(1,length(pattern));
                end
            end
        case CLASS_D
            dataSnippet = [];
            labelSnippet = [];
            for i=1:numObjectsToGenerate
                patternLen = round((CLASS_D_LENGTH(2)-CLASS_D_LENGTH(1)).*rand(1) + CLASS_D_LENGTH(1));
                pattern = [];
                for j=1:patternRepeat(CLASS_D)
                    p = generatePosHalfSine(patternLen, noiseLevel);
                    pattern = [pattern p];
                end
                
                if numObjectsToGenerate > 1
                    noiseDuringLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
                    noiseDuring = smooth(randn(1,noiseDuringLength) * noiseWeight)';
                    dataSnippet = [dataSnippet pattern noiseDuring];
                    labelSnippet = [labelSnippet CLASS_D * ones(1,length([pattern noiseDuring]))];
                else
                    dataSnippet = pattern;
                    labelSnippet = CLASS_D * ones(1,length(pattern));
                end
            end
    end
    
    data = [data dataSnippet];
    labels = [labels labelSnippet];
    
    noiseBeforeLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
    noiseAfterLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
    
    noiseBefore = smooth(randn(1,noiseBeforeLength) * noiseWeight)';
    noiseAfter = smooth(randn(1,noiseAfterLength) * noiseWeight)';
    
    data = [noiseBefore data noiseAfter];
    labels = [zeros(1,length(noiseBefore)) labels zeros(1,length(noiseAfter))];
    1+1;
    
end
end

% TODO: Make a function to build patterns...
function [pattern] = generatePattern(patternType, patternLengths, numToGenerate)


end


function [pos_half] = generatePosHalfSine(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
x = 0:pi/(patternLen*2):2*pi;
y = sin(x);
pos_half = y + randn(1,length(y)) * noiseLevel;
pos_half = pos_half(1:round(length(pos_half)/2));
end

function [neg_half] = generateNegHalfSine(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
x = 0:pi/(patternLen*2):2*pi;
y = sin(x);
neg_half = y + randn(1,length(y)) * noiseLevel;
neg_half = neg_half(round(length(neg_half)/2):end);
end

function [pos_top] = generatePosSquareTop(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
pos_top = [];
for i=1:patternLen
    if i < patternLen/3
        pos_top = [pos_top -1];
    elseif i >= patternLen/3 && i <= (patternLen*2)/3
        pos_top = [pos_top 1];
    else
        pos_top = [pos_top -1];
    end
end
pos_top = pos_top + randn(1,length(pos_top)) * noiseLevel;
end

function [neg_top] = generateNegSquareTop(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
neg_top = [];
for i=1:patternLen
    if i < patternLen/3
        neg_top = [neg_top 1];
    elseif i >= patternLen/3 && i <= (patternLen*2)/3
        neg_top = [neg_top -1];
    else
        neg_top = [neg_top 1];
    end
end
neg_top = neg_top + randn(1,length(neg_top)) * noiseLevel;
end

function [sine_wave] = generateSineWave(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
x = 0:pi/patternLen:2*pi;
y = sin(x);
sine_wave = y + randn(1,length(y)) * noiseLevel;
end

function [flipped_sine_wave] = generateFlippedSineWave(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
x = 0:pi/patternLen:2*pi;
y = sin(x);
flipped_sine_wave = y + randn(1,length(y)) * noiseLevel;
flipped_sine_wave = fliplr(flipped_sine_wave);
end


