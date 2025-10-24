%% ------------------ performance_analysis_plots_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Summarizes and visualizes PTB angular-error performance. Computes per-participant
%          mean/std, plots a histogram of participant means, an image-scale of per-trial errors
%          (ordered by participant mean), error-bar plots for trials and participants, and
%          visualizes task-building locations on the Westbrook map.
%
% Usage:
% - Adjust: savepath, working directory (cd), imagepath, and clistpath.
% - Ensure required files are present. Set saveAll = true to write outputs.
% - Run the script in MATLAB.
%
% Inputs:
% - overviewTable_P2B_Prep_complete.csv (columns incl.: SubjectID, RecalculatedAngle, TrialOrder,
%   StartBuildingName, TargetBuildingName)
% - Map image: additional_Files/map_natural_white_flipped.png
% - Building list CSV: additional_Files/building_collider_list.csv (includes transformed_collidercenter_x/y)
% - Optional (loaded but not required for plots): overviewTrialRepDiff_absoluteError.csv;
%   trialRepDiffAbs.mat; trialRepDiffMean.mat; trialRepDiffStd.mat
%
% Outputs (to savepath when saveAll == true):
% - overviewPerformance.mat/.csv (per-participant mean and std of RecalculatedAngle)
% - histogram_performance.png
% - imagescale_performance_participants_allTrials.png
% - errorbar_performance_allTrials.png
% - errorbar_performance_participants_vertical.png
% - taskBuildings_onMap.png (scatter of StartBuildingName locations on the map)
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)



%% start script
clear all;

%% adjust the following variables: 

savepath = '...\Analysis\P2B_controls_analysis\performance_graph_properties_analysis\';


imagepath = '...\Github\gaze-graphs-in-spatial-navigation\additional_Files\'; % path to the map image location
clistpath = '...\Github\gaze-graphs-in-spatial-navigation\additional_Files\'; % path to the coordinate list location


cd '...\Analysis\P2B_controls_analysis\';

% participant list
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

% print out stats

disp(['mean performance best participant = ', num2str(min(overviewPerformance.meanPerformance))])
disp(['mean performance worst participant = ', num2str(max(overviewPerformance.meanPerformance))])

disp(['range performance best-worst participant = ', num2str(max(overviewPerformance.meanPerformance) - min(overviewPerformance.meanPerformance))])


%% save overview
if saveAll 

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





%% create histogram

figure(1)

plotty1 = histogram(sortedOverviewPerformance.meanPerformance,edges);

ylabel('frequency')
xlabel('performance / angular error')
title({'histogram of mean performance', ' '});

ax = gca;
if saveAll
    exportgraphics(ax,strcat(savepath, 'histogram_performance.png'),'Resolution',600)
end

%% create image scale and error bar for performance in all trials

% extract the data and sort into matrix
uniqueTrials = unique(dataP2B(:,5:6),'rows');

overviewTrialPerformance = zeros(26,112);

for index3 = 1:length(sortedParticipantIDs)

    currentPart = sortedParticipantIDs(index3);
    selection = dataP2B(dataP2B.SubjectID == currentPart,:);

    firstTrials = selection.TrialOrder == 1;
    secondTrials = selection.TrialOrder ==2;

    trialPerformance = zeros(1,112);

    for index4 = 1: height(uniqueTrials)

        start = strcmp(selection.StartBuildingName, uniqueTrials{index4,1});
        target = strcmp(selection.TargetBuildingName, uniqueTrials{index4,2});


        trial1 = selection.RecalculatedAngle(start & target & firstTrials);
        trial2 = selection.RecalculatedAngle(start & target & secondTrials);


        trialPerformance(1,index4*2-1) = trial1;
        trialPerformance(1,index4*2) = trial2;


    end

    overviewTrialPerformance(index3,:) = trialPerformance;

end



figure(2)

imagescaly = imagesc(overviewTrialPerformance);
colorbar
title({'Image Scale Performance - all Trials','     '});
ax = gca;
ax.XTick = 0:10:244;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.XAxis.MinorTickValues = 1:1:244;
ax.XLabel.String = 'Trials';
ax.YLabel.String = 'Participants';

ax = gca;

if saveAll
    exportgraphics(ax,strcat(savepath, 'imagescale_performance_participants_allTrials.png'),'Resolution',600)
end



%% create the corresponding error plots

meanTrials = mean(overviewTrialPerformance);
meanParticipants = mean(overviewTrialPerformance,2);

stdTrials = std(overviewTrialPerformance);
stdParticipants = std(overviewTrialPerformance,0,2);

figure(3)
x = [1:112];
plotty3 = errorbar(meanTrials, stdTrials,'black','Linewidth',1);
xlabel('Trials')
ylabel('angular error')
% xlim([-1 27])
title({'Mean performance of each trial with error bars', ' '});
hold on

plotty3a = plot(meanTrials,'b','Linewidth',3);

hold off
ax = gca;
if saveAll
    exportgraphics(ax,strcat(savepath, 'errorbar_performance_allTrials.png'),'Resolution',600)
end

figure(4)
x = [1:26];
plotty4 = errorbar(meanParticipants, stdParticipants,'black','Linewidth',1);
xlabel('participants')
ylabel('angular error')
xlim([-1 27])
title({'Mean performance of each participant with error bars', ' '});
hold on

plotty4a = plot(meanParticipants,'b','Linewidth',3);

set(gca,'view',[90 90])
hold off


ax = gca;

if saveAll
    exportgraphics(ax,strcat(savepath, 'errorbar_performance_participants_vertical.png'),'Resolution',600)
end


%% plot the task buildings on map for visualization

% load map

map = imread (strcat(imagepath,'map_natural_white_flipped.png'));

% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);

uniqueTrialHouses = unique(dataP2B.StartBuildingName);


% plot 1 - task buildings on map

node = ismember(houseList.target_collider_name,uniqueTrialHouses);
x = houseList.transformed_collidercenter_x(node);
y = houseList.transformed_collidercenter_y(node);

% display map
figure(5)
imshow(map);
alpha(0.2)
hold on;

plotty19 = scatter(x, y,'filled');

set(gca,'xdir','normal','ydir','normal')
title('Task Buildings in Westbrook')

if saveAll
    saveas(gcf,strcat(savepath,'taskBuildings_onMap.png'));
end

