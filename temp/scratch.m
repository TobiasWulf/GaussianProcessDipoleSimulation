%% clear and clean
clearvars
clc


%% load path var
load config.mat PathVariables


%% scan for training dataset
trainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));


%% scan for test dataset
testFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));


%% load training dataset
trainDS = load(fullfile(trainFiles(1).folder, trainFiles(1).name));


%% load test dataset
testDS = load(fullfile(testFiles(1).folder, testFiles(1).name));


%% build reference for training data angulars
% in degree and rad
refAnglesDeg = trainDS.Data.angles;
refAnglesRad = refAnglesDeg * pi / 180;
cosRef = cos(refAnglesRad);
sinRef = sin(refAnglesRad);

[a, d, or] = sinoids2angles(sinRef, cosRef, false, 'origin', refAnglesDeg)

%% get needed training dataset infos to reconstruct angles by output
% voltages
Voff = trainDS.Info.SensorArrayOptions.Voff;
VcosTrain = trainDS.Data.Vcos;
VsinTrain = trainDS.Data.Vsin;


%% angles2sinoids
% helper function to convert angles (rad or degree) to sinus and cosinus waves
% using built in functions cos, sin, cosd and sind, compute with amplitude scale
% factor and which gives the posibility to scale to one, also angles oppsiste
function [sinus, cosinus, sinusDiff, cosinusDiff] = angles2sinoids(angles, ...
    amp, rad)
    arguments
        % validate angles and origins as row vectors of same length
        angles (1,:) double {mustBeVector, mustBeReal}
        %sinusOrigin (1,:) double {mustBeVector, mustBeReal, mustBeEqualSize(angles, sinusOrigin)}
        %cosinusOrigin (1,:) double {mustBeVector, mustBeReal, mustBeEqualSize(sinusOrigin, cosinusOrigin)}
        % validate amplitude vector as real scalar factor with default 1
        amp (1,1) double {mustBeReal} = 1
        % validate rad option flag as boolean with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
    end
    
    % calculate sinoids dependend of source is in rad or degree
%     if rad
%         sinus = amp * sin(angles);
%         cosinus = amp * cos(angles);
%     sinusDiff = [];
%     cosinusDiff = [];
end


%% sinoids2angles
% helper function to convert sinus and cosinus values to rad or degree angles
% in compare to origin angular reference, atan2 built and correct negative
% angles along 2pi scale to unwrap atan2 result respective to full rotation
% returns angles in rad and converts origin from degrees to rad if needed
% Origin: Jünemann, Added: Wulf (argument validation, rad flag)
% namedargs: origin: origin angles
% varargout 1: anglesDiff
% varargout 2: originRad
function [angles, varargout] = sinoids2angles(sinus, cosinus, rad, namedargs)
    arguments
        % validate sinus, cosinus and origin as row vectors of the same length
        sinus (1,:) double {mustBeReal}
        cosinus (1,:) double {mustBeReal, mustBeEqualSize(sinus, cosinus)}
        % validate rad option flag as boolean with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
        namedargs.origin (1,:) double {mustBeReal, mustBeEqualSize(cosinus, namedargs.origin)}
    end
    
    % convert sinoids vector componets to rad angles, atan2 provides angles
    % btween 0° and 180° and abstracts angles between 180° and  360° to negative
    % quadrant from -180 to 0°
    angles = atan2(sinus, cosinus);
    
    % get index of negative quadrant angles
    idx = angles < 0;
    
    % correct angles from 0° to 360° (0 to 2pi)
    angles(idx) = angles(idx) + 2 * pi;
        
    % calculate difference to origin angular reference
    if nargout > 1
        if isfield(namedargs, 'origin')
            % convert to rad if rad flag is false
            if ~rad, namedargs.origin = namedargs.origin * pi / 180; end
            % claculate difference
            anglesDiff = diff([namedargs.origin; angles], 1, 1);
            % ensure calculated difference matches interval
            idx = anglesDiff > pi;
            anglesDiff(idx) = anglesDiff(idx) - 2 * pi;
            idx = anglesDiff < -pi;
            anglesDiff(idx) = anglesDiff(idx) + 2 * pi;
            varargout{1} = anglesDiff;
        else
            varargout{1} = NaN(length(angles));
        end
    end
    
    % origin in rad if passed in degree, converted in nargout > 1, ~rad
    if nargout > 2
        if isfield(namedargs, 'origin')
            varargout{2} = namedargs.origin;
        end
    end
end


%% mustBeEqualSize
% Custom validation function
function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'Size of first input must equal size of second input.';
        throwAsCaller(MException(eid,msg))
    end
end