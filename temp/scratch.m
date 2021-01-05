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
[sinRef, cosRef, refAnglesRad] = angles2sinoids(refAnglesDeg, false);

%[or2, d] = sinoids2angles(s, c, 'origin', or1)


%% get needed training dataset infos to reconstruct angles by output
% M number of sensor array members
M = trainDS.Info.SensorArrayOptions.SensorCount;

% N number of angles
N = trainDS.Info.UseOptions.nAngles;

% voltages, offset and bridge outputs
Voff = trainDS.Info.SensorArrayOptions.Voff;
VcosTrain = trainDS.Data.Vcos;
VsinTrain = trainDS.Data.Vsin;


%% analyze training dataset
% build table data step by step
head = {};
data = [];
rows = string(1:N);

% offset voltage, referenct vector
head{1} = 'VOff [V]';
data = [data, ones(N, 1) * Voff];

% cosinus offset error absolute/ relative
head{2} = 'VcosOff [V]';
data = [data, ones(N, 1) * mean2(VcosTrain)];
head{3} = 'E(VcosOff) [V]';
data = [data, abs(data(:,1) - data(:,2))];
head{4} = 'E(VcosOff) [%]';
data = [data, 100 * (data(:,3) ./ data(:,1))];

% cosinus output normal distribution, cleaned from offset
head{5} = 'Mu(Vcos) [V]';
data = [data, mean(squeeze(reshape(VcosTrain, M, 1, N)), 1)' - data(:,2)];
head{6} = 'Std(Vcos) [V]';
data = [data, std(squeeze(reshape(VcosTrain, M, 1, N)), 1, 1)'];
head{7} = 'Var(Vcos) [V]';
data = [data, var(squeeze(reshape(VcosTrain, M, 1, N)), 1, 1)'];

% cosinus 95% confidence interval (z=1.96)
head{8} = 'CI95L(Vcos) [V]';
data = [data, data(:,5) - 1.96 * data(:,6) / sqrt(M)];
head{9} = 'CI95U(Vcos) [V]';
data = [data, data(:,5) + 1.96 * data(:,6) / sqrt(M)];
head{10} = 'CI95D(Vcos) [V]';
data = [data, data(:,9) - data(:,8)];

% cosinus relative dispersion
head{11} = 'Disp(Vcos) [%]';
data = [data, 100 * (data(:,6) ./ (data(:,5) + data(:,2)))];

% sinus offset error absolute/ relative
head{12} = 'VsinOff [V]';
data = [data, ones(N, 1) * mean2(VsinTrain)];
head{13} = 'E(SinOff) [V]';
data = [data, abs(data(:,1) - data(:,12))];
head{14} = 'E(SinOff) [%]';
data = [data, data(:,13) ./ data(:,1)];

% sinus output normal distribution
head{15} = 'Mu(Vsin) [V]';
data = [data, mean(squeeze(reshape(VsinTrain, M, 1, N)), 1)' - data(:,12)];
head{16} = 'Std(Vsin) [V]';
data = [data, std(squeeze(reshape(VsinTrain, M, 1, N)), 1, 1)'];
head{17} = 'Var(Vsin) [V]';
data = [data, var(squeeze(reshape(VsinTrain, M, 1, N)), 1, 1)'];

% sinus 95% confidence interval (z=1.96)
head{18} = 'CI95L(Vsin) [V]';
data = [data, data(:,15) - 1.96 * data(:,16) / sqrt(M)];
head{19} = 'CI95U(Vsin) [V]';
data = [data, data(:,15) + 1.96 * data(:,16) / sqrt(M)];
head{20} = 'CI95D(Vsin) [V]';
data = [data, data(:,19) - data(:,18)];

% sinus relative dispersion
head{21} = 'Disp(Vsin) [%]';
data = [data, 100 * (data(:,16) ./ (data(:,15) + data(:,12)))];

% reference angles in degree
head{22} = 'Ref. Angle [°]';
data = [data, refAnglesDeg'];

% compute angles from mean of Vcos, Vsin
[a, da] = sinoids2angles(data(:,15)', data(:,5)', 'origin', refAnglesRad);
head{23} = 'Angle(Vsin,Vcos) [°]';
data = [data, a' * 180 / pi];
head{24} = 'E(Angle) [°]';
data = [data, abs(da)' * 180 / pi];
head{25} = 'E(Angle) [%]';
a0 = refAnglesDeg == 0;
er0 = data(a0, 24) * 100 / 360; % abstract  0° to 360° else divide by zero
data = [data, 100 * (data(:,24) ./ data(:,22))];
data(a0,25) = er0;
head{26} = 'E(Abs/360°) [%]';
data = [data, data(:,24) * 100 / 360];

% create data table
TrainingDataTable = array2table(data, 'VariableNames', head);

% compute mean and max of each data table column and append as extra rows
rows = [rows, "mean", "max"];
MeanRow = varfun(@mean, TrainingDataTable);
MeanRow.Properties.VariableNames = TrainingDataTable.Properties.VariableNames;
MaxRow = varfun(@max, TrainingDataTable);
MaxRow.Properties.VariableNames = TrainingDataTable.Properties.VariableNames;

% add extra rows to table
TrainingDataTable = [TrainingDataTable; MeanRow; MaxRow];
TrainingDataTable.Properties.RowNames = rows;

% show table
disp(TrainingDataTable(end-1:end,:));


%% second try train gp model for prediction
aTrain = refAnglesDeg';
y1Train = cosRef';
X1Train = zeros(N, M);
x1Off = mean2(VcosTrain);
for n = 1:N, X1Train(n,:) = reshape(VcosTrain(:,:,n),1,M) - x1Off; end
%X1Train = wiener2(X1Train, [1 8]);
beta1 = y1Train ./ mean(X1Train,2);
cgpm = fitrgp(X1Train, y1Train, ...
    'KernelFunction', @forbeniusNormKernel, ...
    'KernelParameters', log([1; 2]), ...
    ...'BasisFunction', @hfcn2, ...
    ...'Beta', beta1,...
    'verbose', 1);
%disp(cgpm);
[y1Res, s1Res, ci1Res] = resubPredict(cgpm, 'Alpha', 0.01);

y2Train = sinRef';
X2Train = zeros(N, M);
x2Off = mean2(VsinTrain);
for n = 1:N, X2Train(n,:) = reshape(VsinTrain(:,:,n),1,M) - x2Off; end
%X2Train = wiener2(X2Train, [1 8]);
beta2 = y2Train ./ mean(X2Train,2);
sgpm = fitrgp(X2Train, y2Train, ...
    'KernelFunction', @forbeniusNormKernel, ...
    'KernelParameters', log([1; 2]), ...
    ...'BasisFunction', @hfcn2, ...
    ...'Beta', beta2,...
    'verbose', 1);
%disp(sgpm);
[y2Res, s2Res, ci2Res] = resubPredict(sgpm, 'Alpha', 0.01);

aTest = testDS.Data.angles';
o1Test = cosd(aTest);
o2Test = sind(aTest);
y1Pred = zeros(720, 1);
s1Pred = zeros(720, 1);
ci1Pred = zeros(720, 2);
y2Pred = zeros(720, 1);
s2Pred = zeros(720, 1);
ci2Pred = zeros(720, 2);
for n = 1:720
    X1Test = reshape(testDS.Data.Vcos(:,:,n),1,M) - x1Off;
    X2Test = reshape(testDS.Data.Vsin(:,:,n),1,M) - x2Off;
    %X1Test = wiener2(X1Test, [1 8]);
    %X2Test = wiener2(X2Test, [1 8]);
    [y1Pred(n), s1Pred(n), ci1Pred(n,:)] = predict(cgpm, X1Test);
    [y2Pred(n), s2Pred(n), ci2Pred(n,:)] = predict(sgpm, X2Test);
end

aPred = unwrap(atan2(y2Pred,y1Pred));
mean(abs(aTest - aPred*180/pi))
max(abs(aTest - aPred*180/pi))

%% plot prediction
close all;
pause(1);
figure('WindowState', 'maximized');
tiledlayout(2,1);
nexttile;
p1 = plot(aTest, o1Test, 'm-.', 'LineWidth', 1.2);
hold on;
p2 = stem(aTrain, y1Train, 'ko', 'LineWidth', 1.2);
p3 = errorbar(aTrain, y1Res, abs(ci1Res(:,1)-y1Res), abs(ci1Res(:,2)-y1Res), ...
    'ro', 'LineWidth', 1.2, 'CapSize', 10);
p4 = plot(aTest, y1Pred, 'b', 'LineWidth', 1.2);
p5 = patch([aTest; flipud(aTest)], [ci1Pred(:,1); flipud(ci1Pred(:,2))], 'k', 'FaceAlpha', 0.1);
hold off;
grid on;
legend([p1, p2, p3, p4, p5], {'cos', 'reference', 'confidence 99%', 'gp', '99% confidence'}, 'Location', 'best');
xticks(aTrain');
%yticks(sort(cosRef));
xlim([0 360]);
ylim([-1.2 1.2]);

nexttile;
p1 = plot(aTest, o2Test, 'm-.', 'LineWidth', 1.2);
hold on;
p2 = stem(aTrain, y2Train, 'ko', 'LineWidth', 1.2);
p3 = errorbar(aTrain, y2Res, abs(ci2Res(:,1)-y2Res), abs(ci2Res(:,2)-y2Res), ...
    'ro', 'LineWidth', 1.2, 'CapSize', 10);
p4 = plot(aTest, y2Pred, 'b', 'LineWidth', 1.2);
p5 = patch([aTest; flipud(aTest)], [ci2Pred(:,1); flipud(ci2Pred(:,2))], 'k', 'FaceAlpha', 0.1);
hold off;
grid on;
legend([p1, p2, p3, p4, p5], {'sin', 'reference', 'confidence 99%', 'gp', '99% confidence'}, 'Location', 'best');
xticks(aTrain');
%yticks(sort(sinRef));
xlim([0 360]);
ylim([-1.2 1.2]);


%% custom basis function
%y1=refAnglesRad';
%y1=linspace(0,2*pi,16)';
y1=atan2(sinRef', cosRef');
%X=[mean(squeeze(reshape(trainDS.Data.Vcos,M,1,N)),1)'-Voff, ...
%   mean(squeeze(reshape(trainDS.Data.Vsin,M,1,N)),1)'-Voff];
%X=[cos(y1),sin(y1)];
X=[cosRef',sinRef'];
%beta = hfcn(X)./y1;
%beta(1) = 1;
beta = ones(N,1);
sigma = mean(std(atan2(X2Train,X1Train),1,2));
gp=fitrgp(X,y1, ...
    'BasisFunction', @hfcn, 'Beta', beta, ...
    'Sigma', sigma, ...
    'KernelFunction', @forbeniusNormKernel2, ...
    'KernelParameters', [1; 2]);
max(abs(resubPredict(gp)-y1))
y2=testDS.Data.angles'*pi/180;
X2=[mean(squeeze(reshape(testDS.Data.Vcos,M,1,720)),1)'-Voff,...
    mean(squeeze(reshape(testDS.Data.Vsin,M,1,720)),1)'-Voff];
yp=zeros(720,1);
for n=1:720
    yp(n) = predict(gp,X2(n,:));
end
mean(abs(y2-unwrap(yp))*180/pi)
max(abs(y2-unwrap(yp))*180/pi)

figure('WindowState', 'maximized');
plot(y2)
hold on
plot(unwrap(yp))
plot(aPred)

function h = hfcn(X)
    h = atan2(X(:,2),X(:,1));
end

function h = hfcn2(X)
    h = mean(X,2);
end

%% custom kernel function
function KMN = forbeniusNormKernel2(XM, XN , theta)
    params = exp(theta);
    sigmaL = params(1);
    sigma2F = params(2);
    M = size(XM, 1);
    N = size(XN, 1);
    KMN = zeros(M,N);
    for m = 1:M
        for n = 1:N
            dX1 = XM(m,1) - XN(n,1);
            dX2 = XM(m,2) - XN(n,2);
            r2 = sum(dX1(:).^2) + sum(dX2(:).^2);
            c = 1 / (sigmaL + r2);
            KMN(m,n) = sigma2F * c;
        end
    end
end


function KMN = forbeniusNormKernel(XM, XN , theta)
    params = exp(theta);
    sigmaL = params(1);
    sigma2F = params(2);
    M = size(XM, 1);
    N = size(XN, 1);
    KMN = zeros(M,N);
    for m = 1:M
        for n = 1:N
            dX = XM(m,:) - XN(n,:);
            r2 = sum(dX(:).^2);
            c = 1 / (sigmaL + r2);
            KMN(m,n) = sigma2F * c;
        end
    end
end


%% angles2sinoids
% helper function to convert angles (rad or degree) to sinus and cosinus waves
% using built in functions cos, and sin, compute with amplitude scale
% factor and which gives the posibility to scale to one, additional returns
% angles in rad if passed in degree and differences to sinus and cosinus if
% compare vectors for each is passed, it is also posible to multiple the periods
% of given angles by period factor.
% varargout 1: angles in rad
% varargout 2: sinus diff
% varargout 3: cosinus diff
function [sinus, cosinus, varargout] = angles2sinoids(angles, rad, amp, pf, namedargs)
    arguments
        % validate angles and origins as row vectors of same length
        angles (1,:) double {mustBeVector, mustBeReal}
        % validate rad option flag as boolean with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
        % validate amplitude vector as real scalar factor with default 1
        amp (1,1) double {mustBeReal} = 1
        % validate period factor as real, positive scalar with default 1
        pf (1,1) double {mustBePositive} = 1
        namedargs.sinus (1,:) double {mustBeReal, mustBeEqualSize(angles, namedargs.sinus)}
        namedargs.cosinus (1,:) double {mustBeReal, mustBeEqualSize(angles, namedargs.cosinus)}
    end
    
    % if rad flag is false and angles in degree convert to rad
    if ~rad, angles = angles * pi / 180; end
    
    % calculate sinoids
    sinus = amp * sin(pf * angles);
    cosinus = amp * cos(pf * angles);
    
    % angles in rad
    if nargout > 2
        varargout{1} = angles;
    end
    % sinus difference
    if nargout > 3
        if isfield(namedargs, 'sinus')
            varargout{2} = diff([sinus; namedargs.sinus], 1, 1);
        else
            varargout{2} = NaN(1, length(angles));
        end
    end
    % cosinus difference
    if nargout > 4
        if isfield(namedargs, 'cosinus')
            varargout{3} = diff([cosinus; namedargs.cosinus], 1, 1);
        else
            varargout{3} = NaN(1, length(angles));
        end
    end
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
function [angles, varargout] = sinoids2angles(sinus, cosinus, rad, pf, namedargs)
    arguments
        % validate sinus, cosinus and origin as row vectors of the same length
        sinus (1,:) double {mustBeVector, mustBeReal}
        cosinus (1,:) double {mustBeReal, mustBeEqualSize(sinus, cosinus)}
        % validate rad option flag as boolean with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
        % validate period factor as real, positive scalar with default 1
        pf (1,1) double {mustBePositive} = 1
        % validate angles origin as vector of same length as sinoids
        namedargs.origin (1,:) double {mustBeReal, mustBeEqualSize(cosinus, namedargs.origin)}
    end
    
    % convert sinoids vector componets to rad angles, atan2 provides angles
    % btween 0° and 180° and abstracts angles between 180° and  360° to negative
    % quadrant from -180 to 0°
    angles = atan2(sinus, cosinus);
    
    % correct angles from 0° to 360° (0 to 2pi) with period factor if multiple
    % periods abstarcts angles between 0° and 360°
    angles = unwrap(angles) / pf;
    
        
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
            varargout{1} = NaN(1, length(angles));
        end
    end
    
    % origin in rad if passed in degree, converted in nargout > 1, ~rad
    if nargout > 2
        if isfield(namedargs, 'origin')
            varargout{2} = namedargs.origin;
        else
            varargout{2} = NaN(1, length(angles));
        end
    end
end


%% mustBeEqualSize
% Custom validation function
function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'Size of sinus, cosinus and angles must be equal.';
        throwAsCaller(MException(eid,msg))
    end
end