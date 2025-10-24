%% ------------------ overview_Step1_extractData_PTB_controls_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Extracts and compiles key fields from preprocessed Point-to-Building (PTB) control data.
%          Derives StartBuildingName, computes distance to target, and saves a concise table.
%
% Usage:
% - Adjust: savepath and path to df_PTB_Ctrl_Preprocessed_UnixTS.csv.
% - Run the script in MATLAB.
%
% Inputs:
% - df_PTB_Ctrl_Preprocessed_UnixTS.csv (expects columns incl.:
%   SubjectID, TimeStampBegin, TrialDuration, StartingPositionIndex,
%   TargetBuildingName, RecalculatedAngle, ParticipantPosition_x/z,
%   TargetBuildingPosition_x/z)
%
% Outputs (to savepath):
% - selectedData_P2B_control.mat
% - selectedData_P2B_control.csv
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)

clear all;

%% adjust the following variables: 
% savepath, clistpath, current folder and participant list!----------------


savepath = '...\Analysis\P2B_controls_analysis\';

% performance data (with converted timestamp column)

allData_unix = readtable('...\Analysis\P2B_controls_analysis\df_PTB_Ctrl_Preprocessed_UnixTS.csv');


%------------------------------------------------------------------------

selectedData = table;
selectedData.SubjectID = allData_unix.SubjectID;
selectedData.TimeStampBegin = allData_unix.TimeStampBegin;
selectedData.TrialDuration = allData_unix.TrialDuration;
selectedData.StartingPositionIndex = allData_unix.StartingPositionIndex;
selectedData.StartBuildingName = cellstr(strcat('TaskBuilding_', num2str(selectedData.StartingPositionIndex+1)));
selectedData.TargetBuildingName = allData_unix.TargetBuildingName;
selectedData.RecalculatedAngle = allData_unix.RecalculatedAngle;


%%calculate distance
selectedData.DistancePart2TargetBuilding = sqrt((allData_unix.ParticipantPosition_x - allData_unix.ParticipantPosition_z).^2 + (allData_unix.TargetBuildingPosition_x - allData_unix.TargetBuildingPosition_z).^2);


save([savepath 'selectedData_P2B_control.mat'],'selectedData');
writetable(selectedData, [savepath 'selectedData_P2B_control.csv']);









