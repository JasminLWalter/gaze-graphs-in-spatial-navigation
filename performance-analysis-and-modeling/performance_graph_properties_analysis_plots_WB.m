%% ------------------ performance_graph_properties_analysis_plots_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


% Purpose: Relates PTB performance to graph properties. Loads per-participant gaze graphs, computes
%          node/edge counts, density, diameter, and merges with Hierarchy Index; saves an overview
%          table and plots histograms and performance scatter plots with regression lines.
%
% Usage:
% - Adjust: savepath, working directory (cd), graphPath, hiPath, and PartList.
% - Ensure required input files exist (see below). Run the script in MATLAB.
%
% Inputs:
% - overviewTable_P2B_Prep_complete.csv (for participant IDs; optional context)
% - overviewPerformance.csv (columns incl.: Participants, meanPerformance)
% - HierarchyIndex_Table.mat (variable: HierarchyIndex with field Slope)
% - Per participant graphs (graphPath): <ParticipantID>_Graph_WB.mat (variable: graphy)
%
% Outputs (to savepath):
% - overviewGraphMeasures.mat/.csv (columns: Participants, nrViewedHouses, nrEdges, density, diameter, hierarchyIndex, plus performance)
% - PNG figures:
%   - histogram_nrViewedHouses.png; scatter_performance_nrViewedHouses.png
%   - histogram_nrEdges.png; scatter_performance_nrEdges.png
%   - histogram_density.png; scatter_performance_density.png
%   - histogram_diameter.png; scatter_performance_diameter.png
%   - histogram_hierarchyIndex.png; scatter_performance_hierarchyIndex.png
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)

%% start script
clear all;

%% adjust the following variables: 

savepath = '...\Analysis\P2B_controls_analysis\performance_graph_properties_analysis\';

cd '...\Analysis\P2B_controls_analysis\';


graphPath = '...\Pre-processsing_pipeline\graphs\';

% path to hierarchy index overview
hiPath = '...\Analysis\HierarchyIndex\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];


%% load the data overview
dataP2B = readtable('overviewTable_P2B_Prep_complete.csv');
variableNames = dataP2B.Properties.VariableNames;

%% load overview of the mean performance of each participant
overviewPerformance = readtable('overviewPerformance.csv');

%% load hierarchy index

hierarchyIndex = load(strcat(hiPath, 'HierarchyIndex_Table.mat'));

hierarchyIndex = hierarchyIndex.HierarchyIndex;


%% load graphs and calculate graph measures


overviewGraphMeasures = overviewPerformance; 



for index = 1:length(PartList)
    currentPart = PartList(index);   
    
    file = strcat(graphPath,num2str(currentPart),'_Graph_WB.mat');
   
    %load graph
    graphy = load(file);
    graphy= graphy.graphy;
    
    % calculate graph measures
    nrNodes = height(graphy.Nodes);
    nrEdges = height(graphy.Edges);
    maxEdges = (nrNodes * (nrNodes -1)) / 2;
    density = height(graphy.Edges) / maxEdges;
    
    % get diameter
    distanceM = distances(graphy);
    checkInf = isinf(distanceM);
    distanceM(checkInf) = 0;
    diameter = max(max(distanceM));
      
    
    % add data to overview
    
    overviewGraphMeasures.nrViewedHouses(index) = nrNodes;
    overviewGraphMeasures.nrEdges(index) = nrEdges;
    overviewGraphMeasures.density(index) = density;
    overviewGraphMeasures.diameter(index) = diameter;
        

end

overviewGraphMeasures.hierarchyIndex = hierarchyIndex.Slope;

%% save overviews
save([savepath 'overviewGraphMeasures'],'overviewGraphMeasures');
writetable(overviewGraphMeasures, [savepath, 'overviewGraphMeasures.csv']);


%% plots
%% nr viewed houses
edges1 = (220:1:245);
figure(1)

plotty1 = histogram(overviewGraphMeasures.nrViewedHouses,edges1);

xlabel('number of viewed houses')
ylabel('frequency')
title({'histogram: number of viewed houses', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, 'histogram_nrViewedHouses.png'),'Resolution',600)

% plot scatter of measure with performance

figure(2)
x= overviewGraphMeasures.nrViewedHouses;
y = overviewPerformance.meanPerformance;
plotty2 = scatter(x,y,'filled');
xlabel('nr viewed houses')
ylabel('mean error')
title('Number of viewed houses and performance')

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_nrViewedHouses.png'),'Resolution',600)

%% nr edges
figure(3)

plotty3 = histogram(overviewGraphMeasures.nrEdges);

xlabel('number of edges')
ylabel('frequency')
title({'histogram: number of edges', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, 'histogram_nrEdges.png'),'Resolution',600)

% plot scatter of measure with performance

figure(4)
x= overviewGraphMeasures.nrEdges;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel('nr edges')
ylabel('mean error')
title('Number of edges and performance')

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_nrEdges.png'),'Resolution',600)

%% density

% edges1 = [210:1:245];
figure(5)

edges5 = (0.02:0.005:0.08);
plotty5 = histogram(overviewGraphMeasures.density, edges5);

xlabel('density')
ylabel('frequency')
title({'histogram: graph density', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, 'histogram_density.png'),'Resolution',600)

% plot scatter of measure with performance

figure(6)
x= overviewGraphMeasures.density;
y = overviewPerformance.meanPerformance;
plotty6 = scatter(x,y,'filled');
xlabel('density')
ylabel('mean error')
title('Graph density and performance')

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_density.png'),'Resolution',600)


%% diameter

figure(7)

plotty7 = histogram(overviewGraphMeasures.diameter);

xlabel('diameter')
ylabel('frequency')
title({'histogram: graph diameter', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, 'histogram_diameter.png'),'Resolution',600)

% plot scatter of measure with performance

figure(8)
x= overviewGraphMeasures.diameter;
y = overviewPerformance.meanPerformance;
plotty8 = scatter(x,y,'filled');
xlabel('diameter')
ylabel('mean error')
title('Graph diameter and performance')
xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_diameter.png'),'Resolution',600)

%% hierarchy index

figure(9)

plotty9 = histogram(overviewGraphMeasures.hierarchyIndex);

xlabel('hierarchy index')
ylabel('frequency')
title({'histogram: hierarchy index', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, 'histogram_hierarchyIndex.png'),'Resolution',600)

% plot scatter of measure with performance

figure(10)
x= overviewGraphMeasures.hierarchyIndex;
y = overviewPerformance.meanPerformance;
plotty10 = scatter(x,y,'filled');
xlabel('hierarchyIndex')
ylabel('mean error')
title('Hierarchy index and performance')
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_hierarchyIndex.png'),'Resolution',600)




