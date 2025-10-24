%% ------------------- drawGraphMap_WB.m-----------------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Visualizes each participant's gaze graph on top of the Westbrook city map by drawing
%          edges between buildings and plotting nodes at building coordinates.
%
% Usage:
% - Adjust: savepath, imagepath, clistpath, working directory (cd), and PartList.
% - Run the script in MATLAB.
% - Note: The map image is vertically flipped to match MATLAB's axis conventions for these coordinates.
%
% Inputs:
% - Per participant graph: <ParticipantID>_Graph_WB.mat (variable: graphy)
% - Map image: additional_Files/map_natural_white_flipped.png
% - Building list CSV: additional_Files/building_collider_list.csv (columns include building names and transformed_collidercenter_x/y)
%
% Outputs (to savepath):
% - <ID>_Graph_visualizationMap.* (graph overlaid on map; saved via saveas)
% - <ID>_Graph_nodeDegree_600dpi.png (exported 600 dpi figure)
% - Missing_Participant_Files (CSV of missing graph files)
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)

clear all;


%% adjust the following variables: 
% savepath, imagepath, clistpath, current folder and participant list!-----

savepath = '...\Analysis\visualizations\graph_plots\';
imagepath = '...\Github\gaze-graphs-in-spatial-navigation\additional_Files\'; % path to the map image location
clistpath = '...\Github\gaze-graphs-in-spatial-navigation\additional_Files\'; % path to the coordinate list location

cd '...\Pre-processsing_pipeline\graphs\';


% participant list
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

% can be also adjusted to change the color map for the node degree
% visualization
nodecolor = parula; % colormap parula

%--------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


% load map
% !!! Note: the map matches the default coordinate system in python only
% Matlab uses a different coordinate system, therefore, the map needs to be
% flipped on the vertical axis for the coordniates to be correct in Matlab
% plots. Before saving, the image then needs to be flipped back!
% there are more complicated transformations of the coordinates possible,
% but this is the easiest workaround to receive a correct map visualization
% plot!!!

% map = imread (strcat(imagepath,'map_white_flipped.png'));
map = imread (strcat(imagepath,'map_natural_white_flipped.png'));

% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);




for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_Graph_WB.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2

        % load graph      
        graphy = load(file);
        graphy= graphy.graphy;
        
        nodeTable = graphy.Nodes;
        edgeTable = graphy.Edges;
        edgeCell = edgeTable.EndNodes;
                
        % display map
        figure(1)
        imshow(map);
        alpha(0.3)
        hold on;
            
        title(strcat('Graph & degree centrality values - participant: ',num2str(currentPart)));
    
        % add edges into map-----------------------------------------------
        
        for ee = 1:length(edgeCell)
            [Xhouse,Xindex] = ismember(edgeCell(ee,1),houseList.target_collider_name);
            
            [Yhouse,Yindex] = ismember(edgeCell(ee,2),houseList.target_collider_name);
            

            
            x1 = houseList.transformed_collidercenter_x(Xindex);
            y1 = houseList.transformed_collidercenter_y(Xindex);
            
            x2 = houseList.transformed_collidercenter_x(Yindex);
            y2 = houseList.transformed_collidercenter_y(Yindex);
            
            line([x1,x2],[y1,y2],'Color','k','LineWidth',0.1);             
            
        end
 %---------comment code until here to only show nodes without edges--------
  %% plot nodes
  
        node = ismember(houseList.target_collider_name,nodeTable.Name);

        x = houseList.transformed_collidercenter_x(node);
        y = houseList.transformed_collidercenter_y(node);
        
         % plot visualization
         plotty = scatter(x, y, 15 ,'k','filled');
         
         set(gca,'xdir','normal','ydir','normal')
        
        
%         saveas(gcf,strcat(savepath,num2str(currentPart),'_Graph_visualizationMap.png'),'png');
        saveas(gcf,strcat(savepath,num2str(currentPart),'_Graph_visualizationMap'));
        ax = gca;
        exportgraphics(ax,strcat(savepath,num2str(currentPart),'_Graph_nodeDegree_600dpi.png'),'Resolution',600)
        
        hold off
        
    
    else
        disp('something went really wrong with participant list');
    end

end
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');