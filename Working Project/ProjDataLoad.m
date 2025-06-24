%% ProjDataLoad
% The following code loads an excel file with the data for the group
% project

% Author: Henry Richards
% Date: 3/24/25

%% Loads the Data
projData = readtable("EG Project Data.xlsx","TextType","string");

%% Organizes the Data
% Finds the size of the data
[nRows,nCols] = size(projData);
