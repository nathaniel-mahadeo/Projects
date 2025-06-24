function statisticsFunc2(app)
% Writes a function to update the statistics in the second question of the 
% app (HDI rank and percent increase of statistic).

%% Set Parameters

% Finds the desired country
firstCountry = app.CountryRegion1EditField.Value;
secondCountry = app.CountryRegion2EditField.Value;

% Finds the selected statistic and assigns the stat to it
selectedButton = app.SelectComparisonDropDown.Value;

switch selectedButton
    case "Mean Years of Schooling"
        stat = app.totalSchoolStats;
    case "Life Expectancy"
        stat = app.totalLEstats;
    case "GNI"
        stat = app.totalGNIstats;
end

% Finds the selected Major Event
selectedButton2 = app.MajorEventDropDown.Value;

% Uses a switch statement to connect a year index to the event and a
% comparrison year that will be used.
switch selectedButton2
    case '2002 Financial Crisis'
        yearIndex = 2;
    case '2008 Recession'
        yearIndex = 5;
    case '2020 Covid-19 Pandemic'
        yearIndex = 11;
end

% Sets country index at 0 for purposes of checking if the country index 
% was found.
country1Index = 0;
country2Index = 0;

% Finds the index of selected country 1
for iV = 1:length(app.countries)
    if strcmpi(firstCountry,app.countries{iV})
        country1Index = iV;
    end
end

% Finds the index of selected country 2
for iX = 1:length(app.countries)
    if strcmpi(secondCountry,app.countries{iX})
        country2Index = iX;
    end
end

% Keeps the code from executing if the index was not found, meaning the
% country was not valid. An error message is shown though the function
% "Plot.m"
if country1Index == 0 || country2Index == 0
    return
end

%% Finds the percent increase in stats

% Finds the stat from 2 previous year before crisis
previous1Stat = stat{yearIndex-1,1}{country1Index,1};
previous2Stat = stat{yearIndex-1,1}{country2Index,1};

% Finds statistic in the crisis
current1Stat = stat{yearIndex,1}{country1Index,1};
current2Stat = stat{yearIndex,1}{country2Index,1};

% Finds the change in stat
Change1 = round(current1Stat-previous1Stat,2);
Change2 = round(current2Stat-previous2Stat,2);

% Displays the change of coutry 1 to app (adds a + if positive)
% Uses concatenated string statements for precision
% Changes the interpreter to html in order to split the script and force
% the text to wrap. Otherwise, text would need to be too small to view.
% Looked up how to do this online and with documentation.
app.country1ChangeLabel.Interpreter = 'html';

if Change1 > 0 && app.SelectComparisonDropDown.Value == "GNI"
    app.country1ChangeLabel.Text = '<html>' + string(firstCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was +$' + string(Change1)...
        + '</html>';
elseif Change1 < 0 && app.SelectComparisonDropDown.Value == "GNI"
    app.country1ChangeLabel.Text = '<html>' + string(firstCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was -$' + string(abs(Change1))...
        + '</html>';
elseif Change1 > 0 && app.SelectComparisonDropDown.Value == "Mean Years of Schooling"
    app.country1ChangeLabel.Text = '<html>' + string(firstCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was +'+ string(Change1)+...
        ' years'+ '</html>';
elseif Change1 < 0 && app.SelectComparisonDropDown.Value == "Mean Years of Schooling"
    app.country1ChangeLabel.Text = '<html>' + string(firstCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was '+ string(Change1)+...
        ' years'+ '</html>';
elseif Change1 > 0 && app.SelectComparisonDropDown.Value == "Life Expectancy"
    app.country1ChangeLabel.Text = '<html>' + string(firstCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was +'+ string(Change1)+...
        ' years'+ '</html>';
elseif Change1 < 0 && app.SelectComparisonDropDown.Value == "Life Expectancy"
    app.country1ChangeLabel.Text = '<html>' + string(firstCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was '+ string(Change1)+...
        ' years' + '</html>';
end

% Displays the change of country 2 to app (adds a + if positive)
% Uses concatenated string statements for precision
% Changes the interpreter to html in order to split the script and force
% the text to wrap. Otherwise, text would need to be too small to view.
app.country2ChangeLabel.Interpreter = 'html';

if Change2 > 0 && app.SelectComparisonDropDown.Value == "GNI"
    app.country2ChangeLabel.Text = '<html>' + string(secondCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was +$' + string(Change2)...
        + '</html>';
elseif Change2 < 0 && app.SelectComparisonDropDown.Value == "GNI"
    app.country2ChangeLabel.Text = '<html>' + string(secondCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was -$' + string(abs(Change2))...
        + '</html>';
elseif Change2 > 0 && app.SelectComparisonDropDown.Value == "Mean Years of Schooling"
    app.country2ChangeLabel.Text = '<html>' + string(secondCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was +'+ string(Change2)+...
        ' years'+ '</html>';
elseif Change2 < 0 && app.SelectComparisonDropDown.Value == "Mean Years of Schooling"
    app.country2ChangeLabel.Text = '<html>' + string(secondCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was '+ string(Change2)+...
        ' years'+ '</html>';
elseif Change2 > 0 && app.SelectComparisonDropDown.Value == "Life Expectancy"
    app.country2ChangeLabel.Text = '<html>' + string(secondCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was +'+ string(Change2)+...
        ' years'+ '</html>';
elseif Change2 < 0 && app.SelectComparisonDropDown.Value == "Life Expectancy"
    app.country2ChangeLabel.Text = '<html>' + string(secondCountry) +'''s '+...
        string(app.SelectComparisonDropDown.Value) + ' change due to <br>the '+...
        string(app.MajorEventDropDown.Value) + ' was -'+ string(Change2)+...
        ' years' + '</html>';
end

