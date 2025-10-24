%% ------------------ extractData_FRS_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Extracts and summarizes FRS questionnaire data for control participants. Computes,
%          per participant, mean, std, and number of answers for each scale (Egocentric/global,
%          Survey, Cardinal), saves an overview table, and prints summary stats per scale.
%
% Usage:
% - Adjust: savepath and working directory (cd); PartList.
% - Run the script in MATLAB.
%
% Inputs:
% - FRS_Data_Complete_flattened.csv (expects columns: Condition, Participant_ID, Scale, Answer)
%
% Outputs (to savepath):
% - Overview_FRS_Data.mat
% - Overview_FRS_Data.csv
% - Console:
%   - Participant list sanity check
%   - For each scale: min mean (with SD), max mean (with SD), and range
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)

clear all;

%% adjust the following variables: 
% savepath, clistpath, current folder and participant list!----------------


savepath = '...\Analysis\P2B_controls_analysis\';

% data folder containing the FRS questionnaire data
% uploaded in the OSF repository at https://osf.io/32sqe (different from
% the repository where the eye and movement tracking dataset is uploaded
% repository folder: 6. FRS Questionnaire Analysis)
% direct link to required file: https://osf.io/32sqe/files/dtx8a
cd '...\performanceData\'; 



allData = readtable('FRS_Data_Complete_flattened.csv');



control = strcmp(allData.Condition, 'Control');
controlData = allData(control,:);


% participant list
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

% sanity check - are the participants identical to the ones in the FRS
% data?

checkParts = unique(controlData.Participant_ID);

check2 = cell2mat(PartList)';

testParts = sum(checkParts == check2);

if(testParts ==26)
    disp('participant list and participants ids in data are identical');
end

% prepare data structure
overviewFRSData = cell2table(PartList', 'VariableName', {'Participant'});

% extract the relevant data

Number = length(PartList);
noFilePartList = [];

for ii = 1:Number
    currentPart = cell2mat(PartList(ii));   
    
    % find all data of current participant
    selection = controlData.Participant_ID == currentPart;
    currentData = controlData(selection,:);
    
    % calculate mean and std for each scale
    
    % scale 1
    selectionScale1 = strcmp(currentData.Scale, 'Egocentric/global');
    questionData1 = currentData(selectionScale1,:);    
    
    overviewFRSData.Mean_egocentric_global(ii) = mean(questionData1.Answer);
    overviewFRSData.STD_egocentric_global(ii) = std(questionData1.Answer);
    overviewFRSData.NrAnswers_egocentric_global(ii) = sum(selectionScale1);
    
    % scale 2
    selectionScale2 = strcmp(currentData.Scale, 'Survey');
    questionData2 = currentData(selectionScale2,:);    
    
    overviewFRSData.Mean_survey(ii) = mean(questionData2.Answer);
    overviewFRSData.STD_survey(ii) = std(questionData2.Answer);
    overviewFRSData.NrAnswers_survey(ii) = sum(selectionScale2);
    
    % scale 3
    selectionScale3 = strcmp(currentData.Scale, 'Cardinal');
    questionData3 = currentData(selectionScale3,:);    
    
    overviewFRSData.Mean_cardinal(ii) = mean(questionData3.Answer);
    overviewFRSData.STD_cardinal(ii) = std(questionData3.Answer);
    overviewFRSData.NrAnswers_cardinal(ii) = sum(selectionScale3);

end

% 
% save overview
save([savepath 'Overview_FRS_Data.mat'],'overviewFRSData');
writetable(overviewFRSData, [savepath, 'Overview_FRS_Data.csv']);

disp('Data saved')


%% print out stats
disp('------ stats egocentric/global FRS --------')

[~, idxMin] = min(overviewFRSData.Mean_egocentric_global);
disp(['min mean response = ' num2str(overviewFRSData.Mean_egocentric_global(idxMin)) ...
', sd = ' num2str(round(overviewFRSData.STD_egocentric_global(idxMin),1))])

[~, idxMax] = max(overviewFRSData.Mean_egocentric_global);
disp(['max mean response = ' num2str(overviewFRSData.Mean_egocentric_global(idxMax)) ...
', sd = ' num2str(round(overviewFRSData.STD_egocentric_global(idxMax),1))])

disp(['range = ', num2str(overviewFRSData.Mean_egocentric_global(idxMax) - overviewFRSData.Mean_egocentric_global(idxMin))])


disp('------ stats survey FRS --------')

[~, idxMin] = min(overviewFRSData.Mean_survey);
disp(['min mean response = ' num2str(overviewFRSData.Mean_survey(idxMin)) ...
', sd = ' num2str(round(overviewFRSData.STD_survey(idxMin),1))])

[~, idxMax] = max(overviewFRSData.Mean_survey);
disp(['max mean response = ' num2str(overviewFRSData.Mean_survey(idxMax)) ...
', sd = ' num2str(round(overviewFRSData.STD_survey(idxMax),1))])

disp(['range = ', num2str(overviewFRSData.Mean_survey(idxMax) - overviewFRSData.Mean_survey(idxMin))])

disp('------ stats cardinal FRS --------')

[~, idxMin] = min(overviewFRSData.Mean_cardinal);
disp(['min mean response = ' num2str(overviewFRSData.Mean_cardinal(idxMin)) ...
', sd = ' num2str(round(overviewFRSData.STD_cardinal(idxMin),1))])

[~, idxMax] = max(overviewFRSData.Mean_cardinal);
disp(['max mean response = ' num2str(overviewFRSData.Mean_cardinal(idxMax)) ...
', sd = ' num2str(round(overviewFRSData.STD_cardinal(idxMax),1))])

disp(['range = ', num2str(overviewFRSData.Mean_cardinal(idxMax) - overviewFRSData.Mean_cardinal(idxMin))])
