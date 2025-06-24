function schoolingGraphFunc(app)
% The following function creates the dot plot of GNI or Life expectancy versus
% mean years schooling and then displays it in the app.

%% Set Parameters
% Gets the country from the app
country = app.EnterCountryEditField.Value;

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
    % Error message already displayed through statisticsFunc
    % Stops the rest of the code from executing if the country is invaid
    return
end

% If country input is valid, makes the font black
app.EnterCountryEditField.FontColor = 'k';

% Finds the countries index
for iV = 1:length(app.countries)
    if strcmpi(country,app.countries{iV})
        countryIndex = iV;
    end
end

% Finds the desired stat from the app
selectedButton = string(app.ChoosePlotButtonGroup.SelectedObject.Text);

% Finds the statistic associated with the button selected
switch selectedButton
    case "GNI"
        stat = app.totalGNIstats;
    case "Life Expectancy"
        stat = app.totalLEstats;
end

%% Data Collection
% Sets the amount of years of data there is
years = 12;

% Sets zero vectors for the two stats
schoolVec = zeros(1,years);
dataVec = zeros(1,years);

% Gets a vector of mean years schooling
for iV = 1:years
    schoolVec(iV) = app.totalSchoolStats{iV}{countryIndex};
end

% Finds the indicated statistic and puts it into a vector
for iV = 1:years
    dataVec(iV) = stat{iV}{countryIndex};
end

%% Plot Data
% Gets a label for y axis based on user selection
switch selectedButton
    case "GNI"
        ytitle = "GNI (thousands of dollars)";
    case "Life Expectancy"
        ytitle = "Life Expectancy (years)";
end

% Plots the statistic over all years
plot(app.schoolingAxes,schoolVec,dataVec,'bo',MarkerFaceColor='b')
title(app.schoolingAxes,selectedButton+' vs. Schooling')
xlabel(app.schoolingAxes,'Mean Years of Schooling')
ylabel(app.schoolingAxes,ytitle)
