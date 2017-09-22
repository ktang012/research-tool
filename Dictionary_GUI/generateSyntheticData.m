function [data, labels] = ...
    generateSyntheticData()
% Input parameters will be added later

% The kinds of patterns to embed into the data
% A: positive half cycle of sine wave
% B: negative half cycle of sine wave
% C: square top
% D: square bottom
% E: whole sine wave
% F: flipped sine wave

% A class can be multiples of patterns for another class.
% For example, class_1: AAA and class_2: A.
% Can the algorithm discern the two classes?

% The lengths of the noise segment before and after a region of interest
noiseLengthStart = 600;
noiseLengthEnd = 1200;

% Number of classes in the data
numClasses = 4;

% Class distribution: how often will an object be one of the following
% classes? NOT USED
classDist = [0.3 0.25 0.25 0.2];

% Number of objects in the data
numObjects = 150;

% The range of the number of objects that can exist in the region of interest
objectsPerClassRegion = [1 5];

data = [];
labels = [];

%{
if length(numClasses) ~= length(classDist)
    disp('Number of classes must match class distribution');
    return;
end

if sum(classDist) ~= 1
    disp('Class distribution must equal 1');
    return;
end
%}

% Classes are currently defined as:
% class 1: {A} -- a positive half cycle of a sine wave
% class 2: {B,D} -- polymorphic class: negative half cycle of a sine wave
% and square bottom
% class 3: 3*{C} -- three consecutive square tops
% class 4: 3*{A} -- three consecutive half cycle of a sinve wave
CLASS_1 = 1;
CLASS_2 = 2;
CLASS_3 = 3;
CLASS_4 = 4;

% Objects will be created with a length within the following intervals
CLASS_1_LENGTH = [60 70];
CLASS_2_LENGTH = [80 100];
CLASS_3_LENGTH = [25 35]; % multiplied by 3
CLASS_4_LENGTH = [25 35]; % multiplied by 3

% Used to create consecutive patterns class
patternRepeat = [1 1 3 3];

% Noise intensity for patterns
noiseLevelPattern = 0.15;

% Noise intensity
noiseWeight = 0.75;

currNumObjects = 0;
while (currNumObjects < numObjects)  
    % Need to implement drawing from some distribution
    % [~, class] = min(abs(classDist - rand(1)));
    % Right now, classes are drawn from a uniform distribution
    
    class = randsample([1 2 3 4],1);
    
    numObjectsToGenerate = randsample(objectsPerClassRegion,1);
    currNumObjects = currNumObjects + numObjectsToGenerate;
    
    switch class
        case CLASS_1
            dataSnippet = [];
            labelSnippet = [];
            for i=1:numObjectsToGenerate
                patternLen = round((CLASS_1_LENGTH(2)-CLASS_1_LENGTH(1)).*rand(1) + CLASS_1_LENGTH(1));
                pattern = generatePosHalfSine(patternLen, noiseLevelPattern);
                if numObjectsToGenerate > 1
                    noiseDuringLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
                    noiseDuring = smooth(randn(1,noiseDuringLength) * noiseWeight)';
                    dataSnippet = [dataSnippet pattern noiseDuring];
                    labelSnippet = [labelSnippet CLASS_1 * ones(1,length([pattern noiseDuring]))];
                else
                    dataSnippet = pattern;
                    labelSnippet = CLASS_1 * ones(1,length(pattern));
                end
            end
        case CLASS_2
            dataSnippet = [];
            labelSnippet = [];
            for i=1:numObjectsToGenerate
                patternLen = round((CLASS_2_LENGTH(2)-CLASS_2_LENGTH(1)).*rand(1) + CLASS_2_LENGTH(1));
                
                % Which subclass should it be?
                if rand(1) > 0.5
                    pattern = generateNegHalfSine(patternLen, noiseLevelPattern);
                else
                    pattern = generateSquareBot(patternLen, noiseLevelPattern);
                end
                
                if numObjectsToGenerate > 1
                    noiseDuringLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
                    noiseDuring = smooth(randn(1,noiseDuringLength) * noiseWeight)';
                    dataSnippet = [dataSnippet pattern noiseDuring];
                    labelSnippet = [labelSnippet CLASS_2 * ones(1,length([pattern noiseDuring]))];
                else
                    dataSnippet = pattern;
                    labelSnippet = CLASS_2* ones(1,length(pattern));
                end
            end
        case CLASS_3
            dataSnippet = [];
            labelSnippet = [];
            for i=1:numObjectsToGenerate
                patternLen = round((CLASS_3_LENGTH(2)-CLASS_3_LENGTH(1)).*rand(1) + CLASS_3_LENGTH(1));
                pattern = [];
                for j=1:patternRepeat(CLASS_3)
                    p = generateSquareTop(patternLen, noiseLevelPattern);
                    pattern = [pattern p];
                end
                
                if numObjectsToGenerate > 1
                    noiseDuringLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
                    noiseDuring = smooth(randn(1,noiseDuringLength) * noiseWeight)';
                    dataSnippet = [dataSnippet pattern noiseDuring];
                    labelSnippet = [labelSnippet CLASS_3 * ones(1,length([pattern noiseDuring]))];
                else
                    dataSnippet = pattern;
                    labelSnippet = CLASS_3 * ones(1,length(pattern));
                end
            end
        case CLASS_4
            dataSnippet = [];
            labelSnippet = [];
            for i=1:numObjectsToGenerate
                patternLen = round((CLASS_4_LENGTH(2)-CLASS_4_LENGTH(1)).*rand(1) + CLASS_4_LENGTH(1));
                pattern = [];
                for j=1:patternRepeat(CLASS_4)
                    p = generatePosHalfSine(patternLen, noiseLevelPattern);
                    pattern = [pattern p];
                end
                
                if numObjectsToGenerate > 1
                    noiseDuringLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
                    noiseDuring = smooth(randn(1,noiseDuringLength) * noiseWeight)';
                    dataSnippet = [dataSnippet pattern noiseDuring];
                    labelSnippet = [labelSnippet CLASS_4 * ones(1,length([pattern noiseDuring]))];
                else
                    dataSnippet = pattern;
                    labelSnippet = CLASS_4 * ones(1,length(pattern));
                end
            end
    end
    
    % Calculate lengths of noise objects
    noiseBeforeLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
    noiseAfterLength = abs(round((noiseLengthEnd-noiseLengthStart)*rand(1) + noiseLengthStart));
    
    % Create noise objects
    noiseBefore = smooth(randn(1,noiseBeforeLength) * noiseWeight)';
    noiseAfter = smooth(randn(1,noiseAfterLength) * noiseWeight)';
    
    % Concatenate noise objects to data
    data = [data noiseBefore dataSnippet noiseAfter];
    labels = [labels zeros(1,length(noiseBefore)) labelSnippet zeros(1,length(noiseAfter))];
    
end
end

% TODO: Make a function to build patterns...
function [dataSnippet, labelSnippet] = ...
    generatePattern(patternType, patternLengths, numToGenerate)


end


function [pos_half] = generatePosHalfSine(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
x = 0:pi/(patternLen):2*pi;
y = sin(x);
pos_half = y + randn(1,length(y)) * noiseLevel;
pos_half = pos_half(1:round(length(pos_half)/2));
end

function [neg_half] = generateNegHalfSine(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
x = 0:pi/(patternLen):2*pi;
y = sin(x);
neg_half = y + randn(1,length(y)) * noiseLevel;
neg_half = neg_half(round(length(neg_half)/2):end);
end

function [sq_top] = generateSquareTop(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
sq_top = [];
for i=1:patternLen
    if i < patternLen/3
        sq_top = [sq_top -1];
    elseif i >= patternLen/3 && i <= (patternLen*2)/3
        sq_top = [sq_top 1];
    else
        sq_top = [sq_top -1];
    end
end
sq_top = sq_top + randn(1,length(sq_top)) * noiseLevel;
end

function [sq_bot] = generateSquareBot(patternLen, noiseLevel)
if ~exist('noiseLevel','var')
    noiseLevel = 0.3;
end
sq_bot = [];
for i=1:patternLen
    if i < patternLen/3
        sq_bot = [sq_bot 1];
    elseif i >= patternLen/3 && i <= (patternLen*2)/3
        sq_bot = [sq_bot -1];
    else
        sq_bot = [sq_bot 1];
    end
end
sq_bot = sq_bot + randn(1,length(sq_bot)) * noiseLevel;
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


