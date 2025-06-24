function histogramFunc(app)
% The following function creates a histogram of the region of the inputted
% country and the inputted statistic.

%% Creates a list of indices of the region

% Creates regions and assigns countries to them
% This is just a list of regions found online that were then imputted into
% the regional cell arrays.
asia = {"Afghanistan", "Armenia", "Azerbaijan", "Bahrain", "Bangladesh",...
    "Brunei Darussalam", "Cambodia", "China", "India", "Indonesia",...
    "Iran (Islamic Republic of)", "Iraq", "Israel", "Japan", "Jordan",...
    "Kazakhstan", "Kuwait", "Kyrgyzstan", "Lao People's Democratic Republic",...
    "Malaysia", "Maldives", "Mongolia", "Myanmar", "Nepal", "Oman",...
    "Pakistan", "Philippines", "Qatar", "Republic of Korea", "Saudi Arabia",...
    "Singapore", "Sri Lanka", "Syrian Arab Republic", "Tajikistan",...
    "Thailand", "Timor-Leste", "Turkey", "Turkmenistan", "United Arab Emirates",...
    "Uzbekistan", "Viet Nam", "Yemen"};
africa = {"Algeria", "Angola", "Benin", "Botswana", "Burkina Faso", "Burundi",...
    "Cabo Verde", "Cameroon", "Central African Republic", "Chad", "Comoros",...
    "Congo", "Congo (Democratic Republic of the)", "Côte d'Ivoire",...
    "Djibouti", "Egypt", "Equatorial Guinea", "Eswatini (Kingdom of)",...
    "Ethiopia", "Gabon", "Gambia", "Ghana", "Guinea", "Kenya", "Lesotho",...
    "Liberia", "Libya", "Madagascar", "Malawi", "Mali", "Mauritania",...
    "Mauritius", "Morocco", "Mozambique", "Namibia", "Niger", "Nigeria",...
    "Rwanda", "Sao Tome and Principe", "Senegal", "Seychelles", "Sierra Leone",...
    "Somalia", "South Africa", "South Sudan", "Sudan",...
    "Tanzania (United Republic of)", "Togo", "Tunisia", "Uganda",...
    "Zambia", "Zimbabwe"};
europe = {"Albania", "Andorra", "Austria", "Belarus", "Belgium",...
    "Bosnia and Herzegovina", "Bulgaria", "Croatia", "Cyprus", "Czechia",...
    "Denmark", "Estonia", "Finland", "France", "Georgia", "Germany",...
    "Greece", "Hungary", "Iceland", "Ireland", "Italy", "Latvia",...
    "Liechtenstein", "Lithuania", "Luxembourg", "Malta", "Moldova (Republic of)",...
    "Monaco", "Montenegro", "Netherlands", "North Macedonia", "Norway",...
    "Poland", "Portugal", "Romania", "Russian Federation", "San Marino",...
    "Serbia", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland",...
    "Ukraine", "United Kingdom"};
northAmerica = {"Canada";"United States";"Mexico"};
southAmerica = {"Argentina", "Bolivia (Plurinational State of)", "Brazil",...
    "Chile", "Colombia", "Ecuador", "Guyana", "Paraguay", "Peru",...
    "Suriname", "Uruguay", "Venezuela (Bolivarian Republic of)"};
oceana = {"Australia", "Fiji", "Kiribati", "Micronesia (Federated States of)",...
    "New Zealand", "Palau", "Papua New Guinea", "Samoa", "Solomon Islands",...
    "Tonga", "Tuvalu", "Vanuatu"};
centralAmer_Caribbean = {"Antigua and Barbuda", "Bahamas", "Barbados", "Belize",...
    "Costa Rica", "Cuba", "Dominica", "Dominican Republic", "El Salvador",...
    "Grenada", "Guatemala", "Haiti", "Honduras", "Jamaica", "Nicaragua",...
    "Panama", "Saint Lucia", "Saint Vincent and the Grenadines",...
    "Trinidad and Tobago"};

% Finds the country from the user input in the app
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

% Makes the text black if the country input is valid
app.EnterCountryEditField.FontColor = 'k';

% The code compares the country inputted to the list of regions and finds
% that if it is a member of that list. Its index then gets put into a
% column vector of all the indices of the countries.

switch country
    case asia
       indices = find(ismember(cellstr(app.countries),cellstr(asia)));
       region = "Asia";
    case africa
       indices = find(ismember(cellstr(app.countries),cellstr(africa)));
       region = "Africa";
    case europe
       indices = find(ismember(cellstr(app.countries),cellstr(europe)));
       region = "Europe";
    case northAmerica
       indices = find(ismember(cellstr(app.countries),cellstr(northAmerica)));
       region = "North America";
    case southAmerica
       indices = find(ismember(cellstr(app.countries),cellstr(southAmerica)));
       region = "South America";
    case oceana
       indices = find(ismember(cellstr(app.countries),cellstr(oceana)));
       region = "Oceana";
    case centralAmer_Caribbean
       indices = find(ismember(cellstr(app.countries),cellstr(centralAmer_Caribbean))); 
       region = "Carribean / Central America";
end

%% Takes the list of indices and then gets the information related to 
% those countries

% Creates a zero vector as long as the length of the indices
regionalStat = zeros(1,length(indices));

% Finds the desired stat from the app
selectedButton = string(app.ButtonGroup.SelectedObject.Text);

% Finds the statistic associated with the button selected
switch selectedButton
    case "Mean Years of School"
        stat = app.totalSchoolStats;
    case "Life Expectancy"
        stat = app.totalLEstats;
    case "GNI"
        stat = app.totalGNIstats;
end

% Finds the desired year from the app
year = app.EnterYearEditField.Value;

% If the year input is invalid, the code stops and an error message is
% displayed
if year > 2022 || year < 2000 || rem(year,2) ~= 0
    % Pop up message already displayed to user through statisticsFunc
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

% Uses a for loop to get the desired statistic of the desired year and then
% puts it into the regionalStat vector
for iV = 1:length(indices)       
    regionalStat(iV) = stat{yearIndex}{indices(iV)};  
end

% Uses a switch statement to get x axis label
switch selectedButton
    case "GNI"
        xtitle = "GNI (thousands of dollars)";
    case "Life Expectancy"
        xtitle = "Life Expectancy (years)";
    case "Mean Years of School"
        xtitle = "Mean Years of Schooling";    
end

% Creates a histogram of the regional statistics and formats the histogram
histogram(app.histogramAxes,regionalStat,7)
xlabel(app.histogramAxes,xtitle)
ylabel(app.histogramAxes,'Frequency')
title(app.histogramAxes,region+'''s '+selectedButton+' in '+string(year))


        
    
