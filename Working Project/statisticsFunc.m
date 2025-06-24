function statisticsFunc(app)
% Writes a function to update the statistics in the app (HDI rank and
% percent increase of statistic). Also has the code for invalid entries
% both for the country and the year.

%% Set Parameters
% Gets the year from the app
year = app.EnterYearEditField.Value;

% If the year input is invalid, the code stops and an error message is
% displayed
if year > 2022 || year < 2000 || rem(year,2) ~= 0
    % Pops up a UI alert telling the user to enter a different year and
    % gives more specific instructions.
    uialert(app.UIFigure,['Entry must be between 2000 and 2022 counting ' ...
        'by twos (ex. 2000, 2002, 2004, etc.)'],'Invalid Year Entry')
    % Stops the rest of the code from running
    return
end


% Gets the country from the app
country = app.EnterCountryEditField.Value;

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

% Sets countryIndex as 0 so if the country index never changes an error
% message can be displayed
countryIndex = 0;

% Finds the country index
for iV = 1:length(app.countries)
    if strcmpi(country,app.countries{iV})
        countryIndex = iV;
    end
end

% If the country is not a valid one, an error message displays
if countryIndex == 0
    app.EnterCountryEditField.Value = 'Not Valid Country';
    % Displays red font color for the error
    app.EnterCountryEditField.FontColor = 'r';
    return
end

% Makes the font black if the country input is valid
app.EnterCountryEditField.FontColor = 'k';

%% Finds the HDI rank of the country in 2022 (only year provided)
HDIrank2022 = app.HDIrank{countryIndex,1};

% Sends HDI rank to app
app.Label.Text = string(HDIrank2022);


%% Finds the percent increase in stats
% Finds the statistic to look for
% Finds the selected button
selectedButton = string(app.ButtonGroup.SelectedObject.Text);

switch selectedButton
    case "Mean Years of School"
        stat = app.totalSchoolStats;
    case "Life Expectancy"
        stat = app.totalLEstats;
    case "GNI"
        stat = app.totalGNIstats;
end

% Finds 2 previous year stat (if it exists)
if yearIndex >= 2
    previousStat = stat{yearIndex-1,1}{countryIndex,1};
else
    previousStat = "No year Previous";
end

% If there is no previous year display a message
if strcmp(previousStat,"No year Previous")
    app.percentChangeLabel.Text = "No year Previous";
    app.percentChangeLabel.FontSize = 12;
    % Stops the rest of the code from running if there is no previous year
    return
end
% Finds current stat
currentStat = stat{yearIndex,1}{countryIndex,1};

% Finds percent ration of new year to previous year
percent = round((currentStat/previousStat)*100,2);

% Finds the percent change
percentChange = percent-100;

% Displays percent change to app (adds a + if positive)
if percentChange > 0
    app.percentChangeLabel.Text = '+' + string(percentChange)+' %';
else
    app.percentChangeLabel.Text = string(percentChange)+' %';
end

% Increases font size
app.percentChangeLabel.FontSize = 18;