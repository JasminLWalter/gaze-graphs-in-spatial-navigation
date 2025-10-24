%% ------------------ task_repetition_plots_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Quantifies repetition effects in PTB performance. Computes per-participant mean/variance
%          of angular error and duration for first vs. second trials, derives per-participant trial
%          sequence indices, and analyzes error differences between repeated trials.
%
% Usage:
% - Adjust: savepath, working directory (cd), and PartList.
% - Run the script in MATLAB.
%
% Inputs:
% - overviewTable_P2B_Prep_complete.csv (columns incl.: SubjectID, TimeStampBegin, TrialOrder,
%   RecalculatedAngle, TrialDuration, RouteID)
% - overviewTable_P2B_Prep_complete_withoutReps.csv (same columns; repetitions removed/averaged)
% - uniqueTrials_routeID.mat (variable: uniqueTrials; map of Start–Target to RouteID)
%
% Outputs (to savepath):
% - Difference in pointing error between repetitions error 1 - error 2.png
% - Mean pointing error over trialsblue = rep 1, green = rep 2.png
% - All angular pointing error separated by trial order.png
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)


clear all;

%% adjust the following variables:  

savepath = '...\Analysis\P2B_controls_analysis\RepetitionAnalysis\';

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


% how error and duration changes over the time of the task


for index = 1:length(PartList)
    
     currentPart = PartList(index);   
    
     selectionPart = currentPart == dataP2B.SubjectID;
     
     
     selectionTrial1 = dataP2B.TrialOrder == 1;
     selectionTrial2 = dataP2B.TrialOrder == 2;
     
     overviewDiffReps.Participant(index) = currentPart;
     
     % trial 1
     overviewDiffReps.MeanError_Trial_1(index) = mean(dataP2B.RecalculatedAngle(selectionPart&selectionTrial1));
     overviewDiffReps.VarianceError_Trial_1(index) = var(dataP2B.RecalculatedAngle(selectionPart&selectionTrial1));

     overviewDiffReps.MeanDuration_Trial_1(index) = mean(dataP2B.TrialDuration(selectionPart&selectionTrial1));
     overviewDiffReps.VarianceDuration_Trial_1(index) = var(dataP2B.TrialDuration(selectionPart&selectionTrial1));

     % trial 2
     overviewDiffReps.MeanError_Trial_2(index) = mean(dataP2B.RecalculatedAngle(selectionPart&selectionTrial2));
     overviewDiffReps.VarianceError_Trial_2(index) = var(dataP2B.RecalculatedAngle(selectionPart&selectionTrial2));

     overviewDiffReps.MeanDuration_Trial_2(index) = mean(dataP2B.TrialDuration(selectionPart&selectionTrial2));
     overviewDiffReps.VarianceDuration_Trial_2(index) = var(dataP2B.TrialDuration(selectionPart&selectionTrial2));
   
     
     startTS = min(dataP2B.TimeStampBegin(selectionPart));
     dataP2B.TrialTime(selectionPart) = dataP2B.TrialTime(selectionPart)-startTS; 
     
     
     for indexTrial = 1:112
         
         minTrial = min(dataP2B.TrialTime(selectionPart));
         minIndex = dataP2B.TrialTime == minTrial;
         
         dataP2B.TrialSequence(minIndex) = indexTrial;
         
         selectionPart = selectionPart & not(minIndex); 
         
     end

     
end

for index2 = 1:height(dataP2B_withoutRep)
   
    currentPart = dataP2B_withoutRep.SubjectID(index2);
    currentSTcombi = dataP2B_withoutRep.RouteID(index2);
    
    selectionPart = dataP2B.SubjectID == currentPart;
    selectionSTC = strcmp(dataP2B.RouteID, currentSTcombi);
    selectionOrder1 = dataP2B.TrialOrder == 1;
    selectionOrder2 = dataP2B.TrialOrder == 2;
    
    error1 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder1);
    error2 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder2);

    dataP2B_withoutRep.ErrorDiff(index2) = error1-error2;

end

%% distribution differences between first and second task trial reps
% figure 1
figure(1)


plotty1 = histogram(dataP2B_withoutRep.ErrorDiff);
title({'Difference in pointing error between repetitions', 'error 1 - error 2'})

ylabel('frequency')
xlabel('angular error difference')

saveas(gcf, strcat(savepath, 'Difference in pointing error between repetitions', 'error 1 - error 2.png'));


% figure 2
edges = [0:10:100];
figure(2)
plotty2 = histogram(overviewDiffReps.MeanError_Trial_1,edges,'FaceColor','b', 'FaceAlpha',0.5);
hold on

plotty2b= histogram(overviewDiffReps.MeanError_Trial_2,edges,'FaceColor','g', 'FaceAlpha',0.5);
title({'Mean pointing error over trials','blue = rep 1, green = rep 2'})
ylabel('frequency')
xlabel('angular error')

hold off

saveas(gcf, strcat(savepath, 'Mean pointing error over trials','blue = rep 1, green = rep 2.png'));



% figure 3
figure(3)
edges3 = [0:5:180];
plotty3 = histogram(dataP2B.RecalculatedAngle(dataP2B.TrialOrder == 1),edges3,'FaceColor','b', 'FaceAlpha',0.5);
hold on

plotty3b= histogram(dataP2B.RecalculatedAngle(dataP2B.TrialOrder == 2),edges3,'FaceColor','g', 'FaceAlpha',0.5);
title({'All angular pointing error separated by trial order','blue = rep 1, green = rep 2'})
ylabel('frequency')
xlabel('angular error')

hold off

saveas(gcf, strcat(savepath, 'All angular pointing error separated by trial order.png'));

