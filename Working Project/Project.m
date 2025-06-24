function Project(app)

% Read data from the Excel file
projectDataCell = readcell('EGProjectData.xlsx');

% Extract relevant columns (1,2,3,4,5)
correctData = projectDataCell(:, [1, 2, 3, 4, 5]);
% gets size of data
[rows, cols] = size(correctData);

% Initialize structure and variables
app.s = struct();
currentCountryName = '';
currentData = [];

%% New function containers.Map for fancy list
% Manual overrides for specific cleaned country names
nameOverrides = containers.Map( ...
    {'bruneidarussalam', 'ctedivoire', 'hongkongchina', ...
    'laopeoplesdemocraticrepublic', 'palestinestateof', ...
    'russianfederation', 'syrianarabrepublic'}, ...
    {'Brunei', 'Ivory Coast', 'Hong Kong', ...
    'Laos', 'Palestine', 'Russia', 'Syria'} ...
    );
% hardcode words that should be lower cas
smallWords = {'and', 'the', 'of', 'in', 'for', 'to', 'on', 'at', 'with'};

% Loop through the data starting from row 3 to create struct `s`
for i = 3:rows
    % pulls country name from original cell array
    countryName = correctData{i, 2};
    % makes sure on a new country
    if ~strcmp(countryName, currentCountryName)
        %% New function isempty for checking data
        % makes sure I have data
        if ~isempty(currentData)
            %% New function regexp for finding patterns and updating values in the string
            % Clean and capitalize
            nameBeforeParen = regexp(currentCountryName, '^[^()]*', 'match', 'once');
            %% New function strtrim for removing useless space from string
            tempName = strtrim(nameBeforeParen);
            %% New function strsplit for splitting words in string
            % passes temporary name into usable words
            words = strsplit(tempName);
            % loops through words
            for w = 1:length(words)
                %% New function ismember for checking if array is unique
                % runs when lower case word is there
                if ~ismember(lower(words{w}), smallWords)
                    % makes first letter capital
                    words{w} = [upper(words{w}(1)), lower(words{w}(2:end))];
                else
                    words{w} = lower(words{w});
                end
            end
            %% New function strjoin to put string back together
            cleanName = strjoin(words, ' ');
            % replaces space
            lookupKey = lower(strrep(cleanName, ' ', ''));
            %% New function isKey for container.map
            % runs when key matches to overrides and fixes them
            if isKey(nameOverrides, lookupKey)
                structName = nameOverrides(lookupKey);
            else
                structName = cleanName;
            end
            % replaces underlines and makes structure valid
            structName = strrep(structName, '''', '_');
            structName = strrep(structName, ' ', '_');
            structName = matlab.lang.makeValidName(structName);
            % adds data to structure
            app.s.(structName) = currentData;
        end
        % passes data into country
        currentCountryName = countryName;
        currentData = correctData(i, :);
    else
        currentData = [currentData; correctData(i, :)];
    end
    % runs through more data
    if i == rows && ~isempty(currentData)
        % Clean and capitalize
        nameBeforeParen = regexp(currentCountryName, '^[^()]*', 'match', 'once');
        % removes useless space from string
        tempName = strtrim(nameBeforeParen);
        % passes temporary name into usable words
        words = strsplit(tempName);
        % loops through words
        for w = 1:length(words)
            % runs when lower case word is there
            if ~ismember(lower(words{w}), smallWords)
                words{w} = [upper(words{w}(1)), lower(words{w}(2:end))];
            else
                words{w} = lower(words{w});
            end
        end
        % puts string back together
        cleanName = strjoin(words, ' ');
        % runs when key matches to overrides and fixes them
        lookupKey = lower(strrep(cleanName, ' ', ''));
        if isKey(nameOverrides, lookupKey)
            structName = nameOverrides(lookupKey);
        else
            structName = cleanName;
        end
        % replaces underlines and makes structure valid
        structName = strrep(structName, '''', '_');
        structName = strrep(structName, ' ', '_');
        structName = matlab.lang.makeValidName(structName);
        % adds data to structure
        app.s.(structName) = currentData;
    end
end

% Fix alternate spellings
app.s.Ivory_Coast = app.s.C_te_D_ivoire;
app.s.Laos = app.s.Lao_People_s_Democratic_Republic;
app.s.Guinea_Bissau = app.s.Guinea_bissau;
app.s.Hong_Kong = app.s.Hong_Kong__China;
app.s.Palestine = app.s.Palestine__State_of;
app.s.Timor_Leste = app.s.Timor_leste;
app.s.Vietnam = app.s.Viet_Nam;

% List of North American countries
northAmericanCountries = {'Antigua_and_Barbuda', 'Bahamas', 'Barbados', 'Belize', 'Canada', ...
    'Costa_Rica', 'Cuba', 'Dominica', 'Dominican_Republic', 'El_Salvador', ...
    'Grenada', 'Guatemala', 'Haiti', 'Honduras', 'Jamaica', 'Mexico', ...
    'Nicaragua', 'Panama', 'Saint_Kitts_and_Nevis', 'Saint_Lucia', ...
    'Saint_Vincent_and_the_Grenadines', 'Trinidad_and_Tobago', 'United_States'};

% BUILD SINGLE NORTH AMERICA STRUCT

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
        %% New function isfield for creating struct
        if ~isfield(app.s, structName)
            %% New function warning for displaying warning
            warning('%s not found in struct.', structName);
            %% New function continue for continuing
            continue;
        end
        % passes data into struct
        data = app.s.(structName);
        found = false;
        % Loop through each row in the country's data, minus 11 to allow 12-year blocks
        for j = 1:size(data,1) - 11
            % Check if the current row matches the desired metric name
            if strcmp(data{j, 3}, metricName)
                % Extract 12 values from column 5 (data values)
                values = cell2mat(data(j:j+11, 5));
                % Extract 12 years from column 4 and convert to numbers
                years = str2double(data(j:j+11, 4));
                % Save the yearVector only once for this metric block
                if isempty(yearVector)
                    yearVector = years;
                end
                % Loop through all 12 values
                for k = 1:12
                    % Only use valid (non-NaN) values
                    if ~isnan(values(k))
                        % Accumulate values for averaging
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        % Track how many valid entries were added
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end
                % Mark that the metric was found
                found = true;
                %% New function break for existing loop
                % Exit the loop once the metric is processed
                break;
            end
        end
        % If the metric wasn't found for the country, issue a warning
        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end
    % Calculate the average values by dividing sum by count using matrix
    % math
    averageValues = avgMatrix ./ countMatrix;

    % Fill in the 36x5 array starting at correct row
    for i = 1:12
        rowIdx = rowOffset + i;
        northAmericaCell{rowIdx, 3} = metricName;
        northAmericaCell{rowIdx, 4} = yearVector(i);
        northAmericaCell{rowIdx, 5} = averageValues(i);
    end
    % Move the offset down for the next metric (12 rows per metric)
    rowOffset = rowOffset + 12;
end

% Store all 3 metrics together in s.North_America
app.s.North_America = northAmericaCell;

% List of South American countries
southAmericanCountries = {'Argentina', 'Bolivia', 'Brazil', 'Chile', 'Colombia', ...
    'Ecuador', 'Guyana', 'Paraguay', 'Peru', ...
    'Suriname', 'Uruguay', 'Venezuela'};

% BUILD SINGLE SOUTH AMERICA STRUCT

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
    % Loop through each country in the South American countries list
    for i = 1:length(southAmericanCountries)
        % Get the raw country name
        rawName = southAmericanCountries{i};
        % Convert country name to a valid struct field name
        structName = matlab.lang.makeValidName(rawName);
        % Check if the country exists in the struct
        if ~isfield(app.s, structName)
            % If not found, show a warning and skip this country
            warning('%s not found in struct.', structName);
            continue;
        end
        % Access the data table for this country
        data = app.s.(structName);
        % Flag to check if find the correct metric in the data
        found = false;
        % Loop through rows to find the block with the correct metric
        for j = 1:size(data,1) - 11
            % Check if this row matches the metric interested in
            if strcmp(data{j, 3}, metricName)
                % Extract 12 data values from column 5
                values = cell2mat(data(j:j+11, 5));
                % Extract the corresponding 12 years from column 4
                years = str2double(data(j:j+11, 4));
                % Save yearVector only once for the metric
                if isempty(yearVector)
                    yearVector = years;
                end
                % Add valid data to the total sum and count
                for k = 1:12
                    if ~isnan(values(k))
                        % Add to sum
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        % Increment valid count
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end
                % Mark that the metric was found and stop looping
                found = true;
                break;
            end
        end
        % If metric block was not found in country data, issue a warning
        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end
    % Compute the average values for each year by dividing sum by count
    % using matrix math
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
app.s.South_America = southAmericaCell;

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

% BUILD SINGLE ASIA STRUCT
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };
% Preallocate a cell array to hold Asia's data: 12 years × 3 metrics = 36 rows
asiaCell = cell(36, 5);
% Used to track row position while inserting each metric block
rowOffset = 0;
% Loop through each development metric (GNI, Life Expectancy, Schooling)
for m = 1:length(metricLabels)
    % Get the current metric name
    metricName = metricLabels{m};
    % Initialize matrices to accumulate values and counts for averaging
    avgMatrix = zeros(12, 1);
    countMatrix = zeros(12, 1);
    % Will store the year labels only once
    yearVector = [];
    % Loop through each country in the Asia list
    for i = 1:length(asiaCountries)
        % Original name with underscores
        rawName = asiaCountries{i};
        % Convert to valid struct field name
        structName = matlab.lang.makeValidName(rawName);
        % Skip country if it's not found in the data struct
        if ~isfield(app.s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end
        % Grab the country's data from the main struct
        data = app.s.(structName);
        % Flag to track if the correct metric was located
        found = false;
        % Search through the data rows to find a block matching the metric
        for j = 1:size(data,1) - 11
            if strcmp(data{j, 3}, metricName)
                % Convert 12 values and their corresponding years
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));
                % Save year vector only once
                if isempty(yearVector)
                    yearVector = years;
                end
                % Loop through values to compute sum and count for each year
                for k = 1:12
                    if ~isnan(values(k))
                        % Add to total
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        % Increment valid entry count
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end
                % found the data block looking for
                found = true;
                break;
            end
        end
        % If couldn’t find the metric block for this country, issue warning
        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end
    % Compute the average for each year across all valid countries using
    % matrix math
    averageValues = avgMatrix ./ countMatrix;
    % Add the averaged metric data to the Asia cell array
    for i = 1:12
        rowIdx = rowOffset + i;
        asiaCell{rowIdx, 3} = metricName;
        asiaCell{rowIdx, 4} = yearVector(i);
        asiaCell{rowIdx, 5} = averageValues(i);
    end
    % Move rowOffset to the next block (i.e., next metric section)
    rowOffset = rowOffset + 12;
end

% Store result in struct
app.s.Asia = asiaCell;

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

% BUILD SINGLE EUROPE STRUCT 
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };
% Preallocate a cell array to hold Europe region's final results
europeCell = cell(36, 5);
% Initialize the row offset, which tracks where to insert each metric block
rowOffset = 0;
% Loop through each of the 3 metric types (GNI, Life Expectancy, Schooling)
for m = 1:length(metricLabels)
    % Current metric being processed
    metricName = metricLabels{m};
    % Initialize accumulators for sum and count for averaging
    avgMatrix = zeros(12, 1);
    countMatrix = zeros(12, 1);
    yearVector = [];
    % Loop through each European country in the list
    for i = 1:length(europeCountries)
        % Raw name from list
        rawName = europeCountries{i};
        % Clean to match struct field
        structName = matlab.lang.makeValidName(rawName);
        % Skip this country if it doesn’t exist in the struct
        if ~isfield(app.s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end
        
        data = app.s.(structName);
        found = false;
        % Loop through the dataset rows to find matching metric block
        for j = 1:size(data,1) - 11
            % Found the metric
            if strcmp(data{j, 3}, metricName)
                % Extract values and corresponding years for 12 data points
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));
                % Store the years only once
                if isempty(yearVector)
                    yearVector = years;
                end
                % Sum up all valid values and keep count for averaging
                for k = 1:12
                    if ~isnan(values(k))
                        % Add to sum
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        % Increment count
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end
                % Stop searching for this country
                found = true;
                break;
            end
        end
        % If metric was never found, display a warning
        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end
    % Compute the final average values for all 12 years using matrix math
    averageValues = avgMatrix ./ countMatrix;
    % Add the metric block into the correct section of europeCell
    for i = 1:12
        rowIdx = rowOffset + i;
        europeCell{rowIdx, 3} = metricName;
        europeCell{rowIdx, 4} = yearVector(i);
        europeCell{rowIdx, 5} = averageValues(i);
    end
     % Move to the next 12-row block for the next metric
    rowOffset = rowOffset + 12;
end

% Store result in struct
app.s.Europe = europeCell;

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

% BUILD SINGLE AFRICA STRUCT
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };
% Preallocate a cell array to store Africa region’s average data
africaCell = cell(36, 5);
% Initialize offset to track where each metric block starts
rowOffset = 0;
% Loop through each metric type (GNI, Life Expectancy, Schooling)
for m = 1:length(metricLabels)
    % Current metric being processed
    metricName = metricLabels{m};
    % Initialize accumulators for total and count
    avgMatrix = zeros(12, 1);
    countMatrix = zeros(12, 1);
    yearVector = [];
    % Loop through each African country
    for i = 1:length(africaCountries)
        rawName = africaCountries{i};
        structName = matlab.lang.makeValidName(rawName);
        % If country data is missing in the struct, show warning and skip
        if ~isfield(app.s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end
        % Get country data table
        data = app.s.(structName);
        % Flag to track if metric found
        found = false;
        % Loop through data to find the correct metric row block
        for j = 1:size(data,1) - 11
            if strcmp(data{j, 3}, metricName)
                % Extract values and years for the 12-year range
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));
                % Store the year vector the first time it’s found
                if isempty(yearVector)
                    yearVector = years;
                end
                % Loop through all 12 years to accumulate valid values
                for k = 1:12
                    if ~isnan(values(k))
                        % Add value
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        % Count entry
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end
                % Metric block found for this country
                found = true;
                break;
            end
        end
        % If no data found for this metric, issue a warning
        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end
    % Compute average values by dividing totals by counts using matrix math
    averageValues = avgMatrix ./ countMatrix;
    % Store results into africaCell with corresponding year and metric
    for i = 1:12
        rowIdx = rowOffset + i;
        africaCell{rowIdx, 3} = metricName;
        africaCell{rowIdx, 4} = yearVector(i);
        africaCell{rowIdx, 5} = averageValues(i);
    end
    % Move to the next 12-row block for the next metric
    rowOffset = rowOffset + 12;
end

% Store result in struct
app.s.Africa = africaCell;

% List of Oceania countries
oceaniaCountries = {'Australia', 'Fiji', 'Kiribati', 'Marshall_Islands', 'Micronesia', ...
    'Nauru', 'New_Zealand', 'Palau', 'Papua_New_Guinea', ...
    'Samoa', 'Solomon_Islands', 'Tonga', 'Tuvalu', 'Vanuatu'};

% BUILD SINGLE OCEANIA STRUCT 
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };
% Set up a blank cell to hold Oceania data: 12 rows x 3 metrics = 36 rows total
oceaniaCell = cell(36, 5);
% Starting row index offset (used to stack each metric block of 12 rows)
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
        if ~isfield(app.s, structName)
            warning('%s not found in struct.', structName);
            continue;
        end
        % Pull data for the country
        data = app.s.(structName);
        % Track if metric was found in the table
        found = false;
        % Search through the country’s data to find the metric block
        for j = 1:size(data,1) - 11
            if strcmp(data{j, 3}, metricName)
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
                % No need to keep looking
                break;
            end
        end
        % If we never found the metric for this country, warn the user
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
app.s.Oceania = oceaniaCell;

% BUILD SINGLE WORLD STRUCT (36x5)

% Get all country names in the struct except the aggregated ones
allFields = fieldnames(app.s);
excludedFields = {'North_America', 'South_America', 'Asia', 'Africa', 'Europe', 'Oceania', 'World'};
countryFields = setdiff(allFields, excludedFields);

% Define the three metrics to include
metricLabels = {
    'Gross National Income Per Capita (2017 PPP$)';
    'Life Expectancy at Birth (years)';
    'Mean Years of Schooling (years)'
    };
% Set up a blank cell to hold Oceania data
worldCell = cell(36, 5);
rowOffset = 0;
% Loop through each of the three key development metrics (GNI, Life Expectancy, Schooling)
for m = 1:length(metricLabels)
    % Current metric being analyzed
    metricName = metricLabels{m};
    % Initialize matrices to calculate average values across all countries for each year
    avgMatrix = zeros(12, 1);
    countMatrix = zeros(12, 1);
    yearVector = [];
    % Go through each individual country (excluding regional groups)
    for i = 1:length(countryFields)
        structName = countryFields{i};
        data = app.s.(structName);
        found = false;
        % Search through the country data to find the row where the current metric starts
        for j = 1:size(data, 1) - 11
            if strcmp(data{j, 3}, metricName)
                values = cell2mat(data(j:j+11, 5));
                years = str2double(data(j:j+11, 4));
                % Store the year labels only once (first country with data)
                if isempty(yearVector)
                    yearVector = years;
                end
                % Loop through all 12 years of data and update totals/counts
                for k = 1:12
                    % Only include valid data
                    if ~isnan(values(k))
                        % Add to total
                        avgMatrix(k) = avgMatrix(k) + values(k);
                        % Increment count
                        countMatrix(k) = countMatrix(k) + 1;
                    end
                end
                % We found the metric, stop searching further
                found = true;
                break;
            end
        end
        % If never found this metric for a country, log a warning
        if ~found
            warning('%s not found in %s.', metricName, structName);
        end
    end
    % Compute the average value for each year using matrix math
    averageValues = avgMatrix ./ countMatrix;
    % Store the calculated data in the worldCell
    for i = 1:12
        rowIdx = rowOffset + i;
        worldCell{rowIdx, 3} = metricName;
        worldCell{rowIdx, 4} = yearVector(i);
        worldCell{rowIdx, 5} = averageValues(i);
    end
    % Move the offset down for the next metric block
    rowOffset = rowOffset + 12;
end

% Save result to struct
app.s.World = worldCell;

% Original debug: preview year vectors from Albania and North America
yearsVec = app.s.Albania(1:12,4);

years = cell2mat(app.s.North_America(1:12,4));
