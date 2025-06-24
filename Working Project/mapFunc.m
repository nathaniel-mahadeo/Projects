function mapFunc(app)
% Creates a heat map of life expectancy, average years schooling, and GNI.
% This uses a downloaded toolbox and a downloaded zip file containing
% bordersm which is a file to create the map outline. Other parts of the
% script come from the course videos on maps.

% Read in data that has country names
countryData = load('borderdata.mat');

% Sets the year based on user input from the app
year = app.EnterYearEditField.Value;

% If the year input is invalid, the code stops and an error message is
% displayed
if year > 2022 || year < 2000 || rem(year,2) ~= 0
    % Displays a pop up message to the user using the function uialert
    % which is done in statisticsFunc
    % Stops the rest of the code from running
    return
end

% Uses a switch statement to change the year to an index
switch year
    case 2000
        yearIndex = 1;
    case 2002
        yearIndex = 2;
    case 2004
        yearIndex = 3;
    case 2006
        yearIndex = 4;
    case 2008
        yearIndex = 5;
    case 2010
        yearIndex = 6;
    case 2012
        yearIndex = 7;
    case 2014
        yearIndex = 8;
    case 2016
        yearIndex = 9;
    case 2018
        yearIndex = 10;
    case 2020
        yearIndex = 11;
    case 2022
        yearIndex = 12;
end

% Create a new figure
figure

% Create overall border map
% This is a downloaded function with many diffferent files within it that
% allow the function to create a map. This was used in tandem with a
% tutorial video to get the map to work
% Needed downloads: bordersm zip file and internal mapping toolbox in
% matlab
bordersm

% Turn on hold on so each country is added
hold on

% Finds the selected button
selectedButton = string(app.ButtonGroup.SelectedObject.Text);

switch selectedButton
    case "Mean Years of School"
    % Map for the average years scooling a country
        for iCountry = 1:length(app.countries)
            cName = lower(app.countries{iCountry,1});
            cName = char(cName);

            cValue = app.totalSchoolStats{yearIndex,1}{iCountry,1};
        
            if sum(strcmpi(cName,countryData.places))
        
                if cValue < 2
                    bordersm(cName,'facecolor','[0.6350 0.0780 0.1840]')
                elseif cValue < 3
                    bordersm(cName,'facecolor','r')
                elseif cValue < 4
                    bordersm(cName,'facecolor','[0.9290 0.6940 0.1250]')
                elseif cValue < 5
                    bordersm(cName,'facecolor','y')
                elseif cValue < 6
                    bordersm(cName,'facecolor','g')
                elseif cValue < 7
                    bordersm(cName,'facecolor','[0.3010 0.7450 0.9330]')
                elseif cValue < 8
                    bordersm(cName,'facecolor','b')
                elseif cValue < 9
                else
                   bordersm(cName,'facecolor','[0.4940 0.1840 0.5560]')
                end
            end
        end
    case "Life Expectancy"    
        % Map for the life expectancy of a country
        for iCountry = 1:length(app.countries)
            cName = lower(app.countries{iCountry,1});
            cName = char(cName);

            cValue = app.totalLEstats{yearIndex,1}{iCountry,1};
        
            if sum(strcmpi(cName,countryData.places))
        
                if cValue < 60
                    bordersm(cName,'facecolor','[0.6350 0.0780 0.1840]')
                elseif cValue < 65
                    bordersm(cName,'facecolor','r')
                elseif cValue < 68.5
                    bordersm(cName,'facecolor','[0.9290 0.6940 0.1250]')
                elseif cValue < 70
                    bordersm(cName,'facecolor','y')
                elseif cValue < 72.5
                    bordersm(cName,'facecolor','g')
                elseif cValue < 75
                    bordersm(cName,'facecolor','[0.3010 0.7450 0.9330]')
                elseif cValue < 80
                    bordersm(cName,'facecolor','b')
                elseif cValue < 85
                else
                   bordersm(cName,'facecolor','[0.4940 0.1840 0.5560]')
                end
            end
        end
    case "GNI"   
        % Map for the GNI of a country
        for iCountry = 1:length(app.countries)
            cName = lower(app.countries{iCountry,1});
            cName = char(cName);

            cValue = app.totalGNIstats{yearIndex,1}{iCountry,1};
        
            if sum(strcmpi(cName,countryData.places))
        
                if cValue < 5000
                    bordersm(cName,'facecolor','[0.6350 0.0780 0.1840]')
                elseif cValue < 10000
                    bordersm(cName,'facecolor','r')
                elseif cValue < 20000
                    bordersm(cName,'facecolor','[0.9290 0.6940 0.1250]')
                elseif cValue < 30000
                    bordersm(cName,'facecolor','y')
                elseif cValue < 40000
                    bordersm(cName,'facecolor','g')
                elseif cValue < 50000
                    bordersm(cName,'facecolor','[0.3010 0.7450 0.9330]')
                elseif cValue < 60000
                    bordersm(cName,'facecolor','b')
                elseif cValue < 70000
                else
                   bordersm(cName,'facecolor','[0.4940 0.1840 0.5560]')
                end
            end
        end
end
        
        
DateTimeStr = string(datetime);
DateTimeStr = replace(DateTimeStr,":","_");
filename = "Image" + DateTimeStr + ".png";
saveas(gca,filename)
app.heatMap.ImageSource = filename;
close all







