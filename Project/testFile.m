% Read data from the Excel file
projectDataCell = readcell('EGProjectData.xlsx');

% Extract relevant columns (1,2,3,4,5)
correctData = projectDataCell(:, [1, 2, 3, 4, 5]);

[rows, cols] = size(correctData);

% yticks([2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])

% Initialize structure and variables
s = struct();
currentCountryName = '';
currentData = [];



% Manual overrides for specific cleaned country names
nameOverrides = containers.Map( ...
    {'bruneidarussalam', 'ctedivoire', 'hongkongchina', ...
    'laopeoplesdemocraticrepublic', 'palestinestateof', ...
    'russianfederation', 'syrianarabrepublic'}, ...
    {'Brunei', 'Ivory Coast', 'Hong Kong', ...
    'Laos', 'Palestine', 'Russia', 'Syria'} ...
    );

smallWords = {'and', 'the', 'of', 'in', 'for', 'to', 'on', 'at', 'with'};

% Loop through the data starting from row 3 to create struct `s`
for i = 3:rows
    countryName = correctData{i, 2};

    if ~strcmp(countryName, currentCountryName)
        if ~isempty(currentData)
            % Clean and capitalize
            nameBeforeParen = regexp(currentCountryName, '^[^()]*', 'match', 'once');
            tempName = strtrim(nameBeforeParen);

            words = strsplit(tempName);
            for w = 1:length(words)
                if ~ismember(lower(words{w}), smallWords)
                    words{w} = [upper(words{w}(1)), lower(words{w}(2:end))];
                else
                    words{w} = lower(words{w});
                end
            end
            cleanName = strjoin(words, ' ');

            lookupKey = lower(strrep(cleanName, ' ', ''));
            if isKey(nameOverrides, lookupKey)
                structName = nameOverrides(lookupKey);
            else
                structName = cleanName;
            end

            structName = strrep(structName, '''', '_');
            structName = strrep(structName, ' ', '_');
            structName = matlab.lang.makeValidName(structName);

            s.(structName) = currentData;
        end

        currentCountryName = countryName;
        currentData = correctData(i, :);
    else
        currentData = [currentData; correctData(i, :)];
    end

    if i == rows && ~isempty(currentData)
        nameBeforeParen = regexp(currentCountryName, '^[^()]*', 'match', 'once');
        tempName = strtrim(nameBeforeParen);

        words = strsplit(tempName);
        for w = 1:length(words)
            if ~ismember(lower(words{w}), smallWords)
                words{w} = [upper(words{w}(1)), lower(words{w}(2:end))];
            else
                words{w} = lower(words{w});
            end
        end
        cleanName = strjoin(words, ' ');

        lookupKey = lower(strrep(cleanName, ' ', ''));
        if isKey(nameOverrides, lookupKey)
            structName = nameOverrides(lookupKey);
        else
            structName = cleanName;
        end

        structName = strrep(structName, '''', '_');
        structName = strrep(structName, ' ', '_');
        structName = matlab.lang.makeValidName(structName);

        s.(structName) = currentData;
    end
end

% Fix alternate spellings
s.Ivory_Coast = s.C_te_D_ivoire;
s.Laos = s.Lao_People_s_Democratic_Republic;
s.Guinea_Bissau = s.Guinea_bissau;
s.Hong_Kong = s.Hong_Kong__China;
s.Palestine = s.Palestine__State_of;
s.Timor_Leste = s.Timor_leste;
s.Vietnam = s.Viet_Nam;

% List of North American countries
northAmericanCountries = {'Antigua_and_Barbuda', 'Bahamas', 'Barbados', 'Belize', 'Canada', ...
    'Costa_Rica', 'Cuba', 'Dominica', 'Dominican_Republic', 'El_Salvador', ...
    'Grenada', 'Guatemala', 'Haiti', 'Honduras', 'Jamaica', 'Mexico', ...
    'Nicaragua', 'Panama', 'Saint_Kitts_and_Nevis', 'Saint_Lucia', ...
    'Saint_Vincent_and_the_Grenadines', 'Trinidad_and_Tobago', 'United_States'};

%% ===================== BUILD SINGLE NORTH AMERICA STRUCT ======================

% Define the three metrics to include
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };

northAmericaCell = cell(36, 5);  % 12 rows × 3 metrics

rowOffset = 0;  % tracks current start row for each metric block

for m = 1:length(metricLabels)
    metricName = metricLabels{m};

    avgMatrix = zeros(12, 1);   % Sum of values by year
    countMatrix = zeros(12, 1); % Count of valid entries by year
    yearVector = [];

    for i = 1:length(northAmericanCountries)
        rawName = northAmericanCountries{i};
        structName = matlab.lang.makeValidName(rawName);

        if ~isfield(s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end

        data = s.(structName);
        found = false;

        for j = 1:size(data,1) - 11
            if strcmp(data{j, 3}, metricName)
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));

                if isempty(yearVector)
                    yearVector = years;
                end

                for k = 1:12
                    if ~isnan(values(k))
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end

                found = true;
                break;
            end
        end

        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end

    averageValues = avgMatrix ./ countMatrix;

    % Fill in the 36x5 array starting at correct row
    for i = 1:12
        rowIdx = rowOffset + i;
        northAmericaCell{rowIdx, 3} = metricName;
        northAmericaCell{rowIdx, 4} = yearVector(i);
        northAmericaCell{rowIdx, 5} = averageValues(i);
    end

    rowOffset = rowOffset + 12;
end

% Store all 3 metrics together in s.North_America
s.North_America = northAmericaCell;

% List of South American countries
southAmericanCountries = {'Argentina', 'Bolivia', 'Brazil', 'Chile', 'Colombia', ...
    'Ecuador', 'Guyana', 'Paraguay', 'Peru', ...
    'Suriname', 'Uruguay', 'Venezuela'};

%% ===================== BUILD SINGLE SOUTH AMERICA STRUCT ======================

% Define the three metrics to include
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };

southAmericaCell = cell(36, 5);  % 12 rows × 3 metrics
rowOffset = 0;  % tracks current start row for each metric block

for m = 1:length(metricLabels)
    metricName = metricLabels{m};

    avgMatrix = zeros(12, 1);   % Sum of values by year
    countMatrix = zeros(12, 1); % Count of valid entries by year
    yearVector = [];

    for i = 1:length(southAmericanCountries)
        rawName = southAmericanCountries{i};
        structName = matlab.lang.makeValidName(rawName);

        if ~isfield(s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end

        data = s.(structName);
        found = false;

        for j = 1:size(data,1) - 11
            if strcmp(data{j, 3}, metricName)
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));

                if isempty(yearVector)
                    yearVector = years;
                end

                for k = 1:12
                    if ~isnan(values(k))
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end

                found = true;
                break;
            end
        end

        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end

    averageValues = avgMatrix ./ countMatrix;

    % Fill in the 36x5 array starting at correct row
    for i = 1:12
        rowIdx = rowOffset + i;
        southAmericaCell{rowIdx, 3} = metricName;
        southAmericaCell{rowIdx, 4} = yearVector(i);
        southAmericaCell{rowIdx, 5} = averageValues(i);
    end

    rowOffset = rowOffset + 12;
end

% Store all 3 metrics together in s.South_America
s.South_America = southAmericaCell;

% List of Asian countries
asiaCountries = {'Afghanistan', 'Armenia', 'Azerbaijan', 'Bahrain', 'Bangladesh', ...
    'Bhutan', 'Brunei', 'Cambodia', 'China', 'Georgia', ...
    'India', 'Indonesia', 'Iran', 'Iraq', 'Israel', 'Japan', ...
    'Jordan', 'Kazakhstan', 'Kuwait', 'Kyrgyzstan', 'Lao_People_s_Democratic_Republic', ...
    'Lebanon', 'Malaysia', 'Maldives', 'Mongolia', 'Myanmar', ...
    'Nepal', 'North_Korea', 'Oman', 'Pakistan', 'Palestine', ...
    'Philippines', 'Qatar', 'Saudi_Arabia', 'Singapore', 'South_Korea', ...
    'Sri_Lanka', 'Syria', 'Tajikistan', 'Thailand', 'Timor_Leste', ...
    'Turkey', 'Turkmenistan', 'United_Arab_Emirates', 'Uzbekistan', 'Vietnam', 'Yemen'};

% === BUILD SINGLE ASIA STRUCT (36x5) ===
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };

asiaCell = cell(36, 5);
rowOffset = 0;

for m = 1:length(metricLabels)
    metricName = metricLabels{m};

    avgMatrix = zeros(12, 1);
    countMatrix = zeros(12, 1);
    yearVector = [];

    for i = 1:length(asiaCountries)
        rawName = asiaCountries{i};
        structName = matlab.lang.makeValidName(rawName);

        if ~isfield(s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end

        data = s.(structName);
        found = false;

        for j = 1:size(data,1) - 11
            if strcmp(data{j, 3}, metricName)
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));

                if isempty(yearVector)
                    yearVector = years;
                end

                for k = 1:12
                    if ~isnan(values(k))
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end

                found = true;
                break;
            end
        end

        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end

    averageValues = avgMatrix ./ countMatrix;

    for i = 1:12
        rowIdx = rowOffset + i;
        asiaCell{rowIdx, 3} = metricName;
        asiaCell{rowIdx, 4} = yearVector(i);
        asiaCell{rowIdx, 5} = averageValues(i);
    end

    rowOffset = rowOffset + 12;
end

% Store result in struct
s.Asia = asiaCell;

% List of European countries
europeCountries = {'Albania', 'Andorra', 'Armenia', 'Austria', 'Azerbaijan', ...
    'Belarus', 'Belgium', 'Bosnia_and_Herzegovina', 'Bulgaria', 'Croatia', ...
    'Cyprus', 'Czechia', 'Denmark', 'Estonia', 'Finland', 'France', ...
    'Georgia', 'Germany', 'Greece', 'Hungary', 'Iceland', ...
    'Ireland', 'Italy', 'Kazakhstan', 'Kosovo', 'Latvia', ...
    'Liechtenstein', 'Lithuania', 'Luxembourg', 'Malta', 'Moldova', ...
    'Monaco', 'Montenegro', 'Netherlands', 'North_Macedonia', 'Norway', ...
    'Poland', 'Portugal', 'Romania', 'Russia', 'San_Marino', ...
    'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', ...
    'Switzerland', 'Turkey', 'Ukraine', 'United_Kingdom'};

% === BUILD SINGLE EUROPE STRUCT (36x5) ===
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };

europeCell = cell(36, 5);
rowOffset = 0;

for m = 1:length(metricLabels)
    metricName = metricLabels{m};

    avgMatrix = zeros(12, 1);
    countMatrix = zeros(12, 1);
    yearVector = [];

    for i = 1:length(europeCountries)
        rawName = europeCountries{i};
        structName = matlab.lang.makeValidName(rawName);

        if ~isfield(s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end

        data = s.(structName);
        found = false;

        for j = 1:size(data,1) - 11
            if strcmp(data{j, 3}, metricName)
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));

                if isempty(yearVector)
                    yearVector = years;
                end

                for k = 1:12
                    if ~isnan(values(k))
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end

                found = true;
                break;
            end
        end

        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end

    averageValues = avgMatrix ./ countMatrix;

    for i = 1:12
        rowIdx = rowOffset + i;
        europeCell{rowIdx, 3} = metricName;
        europeCell{rowIdx, 4} = yearVector(i);
        europeCell{rowIdx, 5} = averageValues(i);
    end

    rowOffset = rowOffset + 12;
end

% Store result in struct
s.Europe = europeCell;

% List of African countries
africaCountries = {'Algeria', 'Angola', 'Benin', 'Botswana', 'Burkina_Faso', ...
    'Burundi', 'Cabo_Verde', 'Cameroon', 'Central_African_Republic', 'Chad', ...
    'Comoros', 'Congo', 'Cote_d_Ivoire', 'Democratic_Republic_of_the_Congo', 'Djibouti', ...
    'Egypt', 'Equatorial_Guinea', 'Eritrea', 'Eswatini', 'Ethiopia', ...
    'Gabon', 'Gambia', 'Ghana', 'Guinea', 'Guinea_Bissau', ...
    'Kenya', 'Lesotho', 'Liberia', 'Libya', 'Madagascar', ...
    'Malawi', 'Mali', 'Mauritania', 'Mauritius', 'Morocco', ...
    'Mozambique', 'Namibia', 'Niger', 'Nigeria', 'Rwanda', ...
    'Sao_Tome_and_Principe', 'Senegal', 'Seychelles', 'Sierra_Leone', 'Somalia', ...
    'South_Africa', 'South_Sudan', 'Sudan', 'Tanzania', 'Togo', ...
    'Tunisia', 'Uganda', 'Zambia', 'Zimbabwe'};

% === BUILD SINGLE AFRICA STRUCT (36x5) ===
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };

africaCell = cell(36, 5);
rowOffset = 0;

for m = 1:length(metricLabels)
    metricName = metricLabels{m};

    avgMatrix = zeros(12, 1);
    countMatrix = zeros(12, 1);
    yearVector = [];

    for i = 1:length(africaCountries)
        rawName = africaCountries{i};
        structName = matlab.lang.makeValidName(rawName);

        if ~isfield(s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end

        data = s.(structName);
        found = false;

        for j = 1:size(data,1) - 11
            if strcmp(data{j, 3}, metricName)
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));

                if isempty(yearVector)
                    yearVector = years;
                end

                for k = 1:12
                    if ~isnan(values(k))
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end

                found = true;
                break;
            end
        end

        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end

    averageValues = avgMatrix ./ countMatrix;

    for i = 1:12
        rowIdx = rowOffset + i;
        africaCell{rowIdx, 3} = metricName;
        africaCell{rowIdx, 4} = yearVector(i);
        africaCell{rowIdx, 5} = averageValues(i);
    end

    rowOffset = rowOffset + 12;
end

% Store result in struct
s.Africa = africaCell;

% List of Oceania countries
oceaniaCountries = {'Australia', 'Fiji', 'Kiribati', 'Marshall_Islands', 'Micronesia', ...
    'Nauru', 'New_Zealand', 'Palau', 'Papua_New_Guinea', ...
    'Samoa', 'Solomon_Islands', 'Tonga', 'Tuvalu', 'Vanuatu'};

% === BUILD SINGLE OCEANIA STRUCT (36x5) ===
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };
% Set up a blank cell to hold Oceania data:
oceaniaCell = cell(36, 5);
% Starting row index offset
rowOffset = 0;
% Loop through all the metrics (GNI, Life Expectancy, Schooling)
for m = 1:length(metricLabels)
    % Current metric type
    metricName = metricLabels{m};
    % Initialize total and count matrices for 12 years of data
    avgMatrix = zeros(12, 1);
    countMatrix = zeros(12, 1);
    yearVector = [];
    % Go through each country in Oceania
    for i = 1:length(oceaniaCountries)
        % Raw country name from list
        rawName = oceaniaCountries{i};
        % Clean it for use as a struct field
        structName = matlab.lang.makeValidName(rawName);
        % If the country isn't in the struct, warn and skip
        if ~isfield(s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end
        % Pull data for the country
        data = s.(structName);
        % Track if metric was found in the table
        found = false;
        % Search through the country’s data to find the metric block
        for j = 1:size(data,1) - 11
            if strcmp(data{j, 3}, metricName)
                % Grab the 12-year chunk of values and years
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));
                % Store the year labels only the first time
                if isempty(yearVector)
                    yearVector = years;
                end
                % Add values and counts for non-missing entries
                for k = 1:12
                    if ~isnan(values(k))
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end
                % Mark that we found the metric
                found = true;
                break;
            end
        end
        % If never found the metric for this country, warn the user
        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end
    % Calculate averages for all 12 years using matrix math
    averageValues = avgMatrix ./ countMatrix;
    % Fill the oceaniaCell with metric info, year, and calculated average
    for i = 1:12
        rowIdx = rowOffset + i;
        oceaniaCell{rowIdx, 3} = metricName;
        oceaniaCell{rowIdx, 4} = yearVector(i);
        oceaniaCell{rowIdx, 5} = averageValues(i);
    end
    % Move down 12 rows to get ready for the next metric
    rowOffset = rowOffset + 12;
end

% Store result in struct
s.Oceania = oceaniaCell;

% BUILD SINGLE WORLD STRUCT (36x5)

% Get all country names in the struct except the aggregated ones
allFields = fieldnames(s);
excludedFields = {'North_America', 'South_America', 'Asia', 'Africa', 'Europe', 'Oceania', 'World'};
countryFields = setdiff(allFields, excludedFields);

% Define the three metrics to include
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };

worldCell = cell(36, 5);
rowOffset = 0;

for m = 1:length(metricLabels)
    metricName = metricLabels{m};

    avgMatrix = zeros(12, 1);
    countMatrix = zeros(12, 1);
    yearVector = [];

    for i = 1:length(countryFields)
        structName = countryFields{i};
        data = s.(structName);
        found = false;

        for j = 1:size(data, 1) - 11
            if strcmp(data{j, 3}, metricName)
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));

                if isempty(yearVector)
                    yearVector = years;
                end

                for k = 1:12
                    if ~isnan(values(k))
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end

                found = true;
                break;
            end
        end

        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end

    averageValues = avgMatrix ./ countMatrix;

    for i = 1:12
        rowIdx = rowOffset + i;
        worldCell{rowIdx, 3} = metricName;
        worldCell{rowIdx, 4} = yearVector(i);
        worldCell{rowIdx, 5} = averageValues(i);
    end

    rowOffset = rowOffset + 12;
end

% Save result to struct
s.World = worldCell;


% NorthAmerica

yearsVec = s.Albania(1:12,4);

years = cell2mat(s.North_America(1:12,4));

countryCell = fieldnames(s);


whichIndex = input('GNI, Life Expectancy, Mean Years of Schooling: ', 's');

if strcmp("GNI", whichIndex)

    checkCountry1 = input('Enter the name of a country: ', 's');

    checkCountry1U = (strrep(checkCountry1, ' ', '_'));

    checkCountry2 = input('Enter the name of a country: ', 's');

    checkCountry2U = (strrep(checkCountry2, ' ', '_'));

    checkCountryName1 = matlab.lang.makeValidName(checkCountry1U);

    checkCountryName2 = matlab.lang.makeValidName(checkCountry2U);

    found = 0;
    founda = 0;
    iterator = 1;
    counter = 1;


    if ~ismember(checkCountryName1, countryCell)
        disp("Error, " + checkCountryName1 + " not found in struct.")
        return;
    end

    if ~ismember(checkCountryName2, countryCell)
        disp("Error, " + checkCountryName2 + " not found in struct.")
        return;
    end


    while found == 0


        if strcmp("Gross National Income Per Capita (2017 PPP$)", s.(checkCountryName1)(iterator,3))
            years1 = s.(checkCountryName1)(iterator:iterator+11,4);
            country1 = cell2mat(s.(checkCountryName1)(iterator:iterator+11,5));

            found = 1;

            if counter == 207
                disp("Error, country not in list")

                found = 1;

            end
            
            counter = counter + 1;
        end


        iterator = iterator + 1;
        % counter = counter + 1;
    end

    % if found == 0
    %     disp("Error, country not in list")
    % end

    found = 0;
    iterator = 1;

    while found == 0
        if strcmp("Gross National Income Per Capita (2017 PPP$)", s.(checkCountryName2)(iterator,3))
            years2 = s.(checkCountryName2)(iterator:iterator+11,4);
            country2 = cell2mat(s.(checkCountryName2)(iterator:iterator+11,5));

            found = 1;
        end

        iterator = iterator + 1;
    end


    years1 = str2double(years1);

    years2 = str2double(years2);

    % Plot
    figure;
    plot(years, country1, '-o');
    hold on
    xlabel('Year');
    ylabel('Value');
    title(checkCountry1, 'GNI vs Year');
    xticks([2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
    grid on;

    idx2002 = 2;      % use years1 that matches country1
    xDot = 2002;
    yDot = country1(idx2002);           % y‑value for 2002
    plot(xDot, yDot, 'ro', ...
        'MarkerSize', 8, 'LineWidth', 1.5);


    % idx2008 = find(years1 == 2008, 1);      % use years1 that matches country1
    % if ~isempty(idx2008)
    %     xDot = 2008;
    %     yDot = country1(idx2008);           % y‑value for 2008
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

    % idx2020 = find(years1 == 2020, 1);      % use years1 that matches country1
    % if ~isempty(idx2020)
    %     xDot = 2020;
    %     yDot = country1(idx2020);           % y‑value for 2020
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end


    figure;
    plot(years, country2, '-o');
    hold on
    xlabel('Year');
    ylabel('Value');
    title(checkCountry2, 'GNI vs Year');
    xticks([2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
    grid on;

    idx2002 = 2;      % use years2 that matches country2
    if ~isempty(idx2002)
        xDot = 2002;
        yDot = country2(idx2002);           % y‑value for 2002
        plot(xDot, yDot, 'ro', ...
            'MarkerSize', 8, 'LineWidth', 1.5);
    end

    % idx2008 = find(years2 == 2008, 1);      % use years2 that matches country2
    % if ~isempty(idx2008)
    %     xDot = 2008;
    %     yDot = country2(idx2008);           % y‑value for 2008
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

    % idx2020 = find(years2 == 2020, 1);      % use years2 that matches country2
    % if ~isempty(idx2020)
    %     xDot = 2020;
    %     yDot = country2(idx2020);           % y‑value for 2020
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

elseif strcmp("Life Expectancy", whichIndex)

    checkCountry1 = input('Enter the name of a country: ', 's');

    checkCountry1U = (strrep(checkCountry1, ' ', '_'));

    checkCountry2 = input('Enter the name of a country: ', 's');

    checkCountry2U = (strrep(checkCountry2, ' ', '_'));

    checkCountryName1 = matlab.lang.makeValidName(checkCountry1U);

    checkCountryName2 = matlab.lang.makeValidName(checkCountry2U);

    if ~ismember(checkCountryName1, countryCell)
        disp("Error, " + checkCountryName1 + " not found in struct.")
        return;
    end

    if ~ismember(checkCountryName2, countryCell)
        disp("Error, " + checkCountryName2 + " not found in struct.")
        return;
    end

    found = 0;
    iterator = 1;
    while found == 0
        if strcmp("Life Expectancy at Birth (years)", s.(checkCountryName1)(iterator,3))
            years1 = s.(checkCountryName1)(iterator:iterator+11,4);
            country1 = cell2mat(s.(checkCountryName1)(iterator:iterator+11,5));

            found = 1;
        end

        iterator = iterator + 1;
    end

    found = 0;
    iterator = 1;

    while found == 0
        if strcmp("Life Expectancy at Birth (years)", s.(checkCountryName2)(iterator,3))
            years2 = s.(checkCountryName2)(iterator:iterator+11,4);
            country2 = cell2mat(s.(checkCountryName2)(iterator:iterator+11,5));

            found = 1;
        end

        iterator = iterator + 1;
    end

    years1 = str2double(years1);

    years2 = str2double(years2);

    % Plot
    figure;
    plot(years, country1, '-o');
    hold on
    xlabel('Year');
    ylabel('Value');
    title(checkCountry1, 'Life Expectancy vs Year');
    xticks([2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
    grid on;

    %     idx2002 = find(years1 == 2002, 1);      % use years1 that matches country1
    % if ~isempty(idx2002)
    %     xDot = 2002;
    %     yDot = country1(idx2002);           % y‑value for 2002
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

    idx2008 = find(years1 == 2008, 1);      % use years1 that matches country1
    if ~isempty(idx2008)
        xDot = 2008;
        yDot = country1(idx2008);           % y‑value for 2008
        plot(xDot, yDot, 'ro', ...
            'MarkerSize', 8, 'LineWidth', 1.5);
    end

    % idx2020 = find(years1 == 2020, 1);      % use years1 that matches country1
    % if ~isempty(idx2020)
    %     xDot = 2020;
    %     yDot = country1(idx2020);           % y‑value for 2020
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

    figure;
    plot(years, country2, '-o');
    hold on
    xlabel('Year');
    ylabel('Value');
    title(checkCountry2, 'Life Expectancy vs Year');
    xticks([2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
    grid on;

    %         idx2002 = find(years2 == 2002, 1);      % use years2 that matches country2
    % if ~isempty(idx2002)
    %     xDot = 2002;
    %     yDot = country2(idx2002);           % y‑value for 2002
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

    idx2008 = find(years2 == 2008, 1);      % use years2 that matches country2
    if ~isempty(idx2008)
        xDot = 2008;
        yDot = country2(idx2008);           % y‑value for 2008
        plot(xDot, yDot, 'ro', ...
            'MarkerSize', 8, 'LineWidth', 1.5);
    end

    % idx2020 = find(years2 == 2020, 1);      % use years2 that matches country2
    % if ~isempty(idx2020)
    %     xDot = 2020;
    %     yDot = country2(idx2020);           % y‑value for 2020
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end


elseif strcmp("Mean Years of Schooling", whichIndex)

    checkCountry1 = input('Enter the name of a country: ', 's');

    checkCountry1U = (strrep(checkCountry1, ' ', '_'));

    checkCountry2 = input('Enter the name of a country: ', 's');

    checkCountry2U = (strrep(checkCountry2, ' ', '_'));

    checkCountryName1 = matlab.lang.makeValidName(checkCountry1U);

    checkCountryName2 = matlab.lang.makeValidName(checkCountry2U);

    found = 0;
    iterator = 1;

    if ~ismember(checkCountryName1, countryCell)
        disp("Error, " + checkCountryName1 + " not found in struct.")
        return;
    end

    if ~ismember(checkCountryName2, countryCell)
        disp("Error, " + checkCountryName2 + " not found in struct.")
        return;
    end

    while found == 0
        if strcmp("Mean Years of Schooling (years)", s.(checkCountryName1)(iterator,3))
            years1 = s.(checkCountryName1)(iterator:iterator+11,4);
            country1 = cell2mat(s.(checkCountryName1)(iterator:iterator+11,5));

            found = 1;
        end

        iterator = iterator + 1;
    end

    found = 0;
    iterator = 1;

    while found == 0
        if strcmp("Mean Years of Schooling (years)", s.(checkCountryName2)(iterator,3))
            years2 = s.(checkCountryName2)(iterator:iterator+11,4);
            country2 = cell2mat(s.(checkCountryName2)(iterator:iterator+11,5));

            found = 1;
        end

        iterator = iterator + 1;
    end

    years1 = str2double(years1);

    years2 = str2double(years2);

    % Plot
    figure;
    plot(years, country1, '-o');
    hold on
    xlabel('Year');
    ylabel('Value');
    title(checkCountry1, 'Mean Years of Schooling vs Year');
    xticks([2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
    grid on;

    %     idx2002 = find(years1 == 2002, 1);      % use years1 that matches country1
    % if ~isempty(idx2002)
    %     xDot = 2002;
    %     yDot = country1(idx2002);           % y‑value for 2002
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

    % idx2008 = find(years1 == 2008, 1);      % use years1 that matches country1
    % if ~isempty(idx2008)
    %     xDot = 2008;
    %     yDot = country1(idx2008);           % y‑value for 2008
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

    idx2020 = find(years1 == 2020, 1);      % use years1 that matches country1
    if ~isempty(idx2020)
        xDot = 2020;
        yDot = country1(idx2020);           % y‑value for 2020
        plot(xDot, yDot, 'ro', ...
            'MarkerSize', 8, 'LineWidth', 1.5);
    end

    figure;
    plot(years, country2, '-o');
    hold on
    xlabel('Year');
    ylabel('Value');
    title(checkCountry2, 'Mean Years of Schooling vs Year');
    xticks([2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
    grid on;

    %         idx2002 = find(years2 == 2002, 1);      % use years2 that matches country2
    % if ~isempty(idx2002)
    %     xDot = 2002;
    %     yDot = country2(idx2002);           % y‑value for 2002
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

    % idx2008 = find(years2 == 2008, 1);      % use years2 that matches country2
    % if ~isempty(idx2008)
    %     xDot = 2008;
    %     yDot = country2(idx2008);           % y‑value for 2008
    %     plot(xDot, yDot, 'ro', ...
    %         'MarkerSize', 8, 'LineWidth', 1.5);
    % end

    idx2020 = find(years2 == 2020, 1);      % use years2 that matches country2
    if ~isempty(idx2020)
        xDot = 2020;
        yDot = country2(idx2020);           % y‑value for 2020
        plot(xDot, yDot, 'ro', ...
            'MarkerSize', 8, 'LineWidth', 1.5);
    end


end

% checkEvent = input("What year do you want to highlight? ");

disp(s);