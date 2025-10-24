%% ------------------ performance_analysis_plots_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Summarizes PTB angular-error performance per participant (mean/std) and plots a
%          participant-sorted boxplot of trial errors.
%
% Usage:
% - Adjust: savepath, working directory (cd), and PartList.
% - Set saveAll = true to write outputs. Run the script in MATLAB.
%
% Inputs:
% - overviewTable_P2B_Prep_complete.csv (columns incl.: SubjectID, RecalculatedAngle)
% - Optional (loaded but not required for the boxplot): overviewTrialRepDiff_absoluteError.csv;
%   trialRepDiffAbs.mat; trialRepDiffMean.mat; trialRepDiffStd.mat
%
% Outputs (to savepath when saveAll == true):
% - overviewPerformance.mat/.csv (per-participant mean and std of RecalculatedAngle)
% - boxplot_performance.png
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)


%% start script
clear all;

%% adjust the following variables: 

savepath = '...\Analysis\P2B_controls_analysis\performance_graph_properties_analysis\';


cd '...\Analysis\P2B_controls_analysis\';


PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];

saveAll = true;

%% load the data overview
dataP2B = readtable('overviewTable_P2B_Prep_complete.csv');
variableNames = dataP2B.Properties.VariableNames;

overviewTrialRepDiffAbs = readtable('overviewTrialRepDiff_absoluteError.csv');

trialRepDiffAbs = load('trialRepDiffAbs.mat');
trialRepDiffAbs = trialRepDiffAbs.trialRepDiffAbs;

trialRepDiffMean = load('trialRepDiffMean.mat');
trialRepDiffMean = trialRepDiffMean.trialRepDiffMean;

trialRepDiffStd = load('trialRepDiffStd.mat');
trialRepDiffStd = trialRepDiffStd.trialRepDiffStd;

%% create an overview of the mean performance of each participant
% also save all performance data for each participant seperately in cell

overviewPerformance = table;
overviewMeans = [];
overviewSTD = [];

performanceDataIndividual = [];

edges=(0:10:180);



for index= 1: length(PartList)
   
    currentPart = PartList(index);
    
    selection = dataP2B.SubjectID == currentPart;
    
    % save mean and std 
    overviewMeans = [overviewMeans, mean(dataP2B.RecalculatedAngle(selection))];
    overviewSTD = [overviewSTD, std(dataP2B.RecalculatedAngle(selection))];
    
end

overviewPerformance.Participants = PartList';
overviewPerformance.meanPerformance = overviewMeans';
overviewPerformance.stdPerformance = overviewSTD';

%% save overview
if saveAll 
        
    save([savepath 'overviewPerformance'],'overviewPerformance');
    save([savepath 'overviewPerformance'],'overviewPerformance');
    writetable(overviewPerformance, [savepath, 'overviewPerformance.csv']);
end


%% plot boxplot of performance data

% sort the participants according to their mean performance

sortedOverviewPerformance = sortrows(overviewPerformance,2);
sortedParticipantIDs = sortedOverviewPerformance.Participants;

% extract the individual performance and put in matrix

for index2 = 1:length(sortedParticipantIDs)
    
    currentPart = sortedParticipantIDs(index2);
    selection = dataP2B.SubjectID == currentPart;

    % save performance separately
    performanceDataIndividual = [performanceDataIndividual,dataP2B.RecalculatedAngle(selection)];
end    


figure(1)
plotty = boxchart(performanceDataIndividual, 'Notch','on');
xlabel('participants');
ylabel('performance / angual error');
title({'Performance grouped by participants - sorted by mean', ' '});
% 
hold on
plot(mean(performanceDataIndividual), '-o')  % x-axis is the intergers of position
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath, 'boxplot_performance.png'),'Resolution',600)
end





