%% ------------------- repetition variance analysis.m-------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Estimates the fraction of total PTB angular-error variance attributable to within-participant
%          inconsistency across repeated trials. Computes total variance, repetition (trial) variance
%          from paired repeats, reports percentages, and visualizes the variance decomposition with
%          stacked bar plots.
%
% Usage:
% - Adjust: working directory (cd).
% - Run the script in MATLAB.
%
% Inputs:
% - overviewTable_P2B_Prep_complete.csv (columns incl.: SubjectID, RouteID, TrialOrder, RecalculatedAngle)
% - overviewTable_P2B_Prep_complete_withoutReps.csv (same columns; one row per Start–Target–participant)
% - uniqueTrials_routeID.mat (variable: uniqueTrials; Start–Target to RouteID mapping)
%
% Outputs:
% - Console summary:
%   - Total variance
%   - Estimated repetition (trial) variance
%   - Percentage of total variance due to repetition
%   - Remaining percentage potentially explainable by modeling
% - Figures (displayed; not saved by default):
%   - Stacked bar plots illustrating the variance decomposition
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)

%% start script
clear all;

%% adjust the following variables: 

cd '...\Analysis\P2B_controls_analysis\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];




%% load data

dataP2B = readtable('overviewTable_P2B_Prep_complete.csv');
dataP2B_withoutRep = readtable('overviewTable_P2B_Prep_complete_withoutReps.csv');

dataP2B.TrialTime = dataP2B.TimeStampBegin;

% load trial id table

stCombiIds = load('uniqueTrials_routeID.mat');
stCombiIds = stCombiIds.uniqueTrials;

% overall mean in pointing error / in duration for each participant
overviewDiffReps = table;

% calculate total performance variance
totalVariance = var(dataP2B.RecalculatedAngle);

% calculate intra-participant variance for each unique
% start-target-building combination

for index = 1:height(dataP2B_withoutRep)
   
    currentPart = dataP2B_withoutRep.SubjectID(index);
    currentSTcombi = dataP2B_withoutRep.RouteID(index);
    
    selectionPart = dataP2B.SubjectID == currentPart;
    selectionSTC = strcmp(dataP2B.RouteID, currentSTcombi);
    selectionOrder1 = dataP2B.TrialOrder == 1;
    selectionOrder2 = dataP2B.TrialOrder == 2;
    
    error1 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder1);
    error2 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder2);

    dataP2B_withoutRep.ErrorDiff(index) = error1-error2;

end

dataP2B_withoutRep.absErrorDiff = abs(dataP2B_withoutRep.ErrorDiff);

diffQ = dataP2B_withoutRep.absErrorDiff.^2;


diffQD2 = diffQ/2;

sumDiffQD2 = sum(diffQD2);

s_trialVariance2 = sumDiffQD2/(height(dataP2B_withoutRep));


fractionVarOfRepeption2 = s_trialVariance2/totalVariance;

fractionPer = fractionVarOfRepeption2*100;
fractionRemainPer = (1-fractionVarOfRepeption2)*100;

disp('----------------with Bessels correction-------')
disp(['Total variance = ', num2str(totalVariance)]);
disp(['S_trialvariance = ', num2str(s_trialVariance2)]);
disp(['percentate of repeptition variance from total variance = ', num2str(fractionPer),'%']);
disp(['percentate of remaining variance to be explained in modeling =', num2str(fractionRemainPer),'%']);



%% plot bar plot visualizations

x = 1;
y = [100,0,0; 
    round(fractionRemainPer,1),0,round(fractionPer, 1);
    round(fractionRemainPer,1) - 9.2,9.2,round(fractionPer, 1)];


figure(1)
plotty1 = bar(y,'stacked');%,'FaceColor',[0.24,0.15,0.66; 0.14,0.63,0.90]);

plotty1(1).FaceColor = [0.24,0.15,0.66];
plotty1(2).FaceColor = [0.01,0.72,0.80];
plotty1(3).FaceColor = [0.75,0.75,0.75];

ylim([-10,120])


figure(2)
x = 1;
y = [40,60];

plotty2 = bar(x,y,'stacked');%,'FaceColor',[0.24,0.15,0.66; 0.14,0.63,0.90]);

plotty2(1).FaceColor = [0.01,0.72,0.80];
plotty2(2).FaceColor = [0.01,0.72,0.80];

ylim([-10,120])




disp('done')


