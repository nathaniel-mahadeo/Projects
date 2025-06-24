function Plot(app)
%% APP STUFF

% hardcodes year vector
app.years = cell2mat(app.s.North_America(1:12,4));
% pulls in values from app
whichIndex = app.SelectComparisonDropDown.Value;
dropDown = app.MajorEventDropDown.Value;

countryCell = fieldnames(app.s);

%% New function cla for clearing plot
cla(app.UIAxesA);    % clear left plot
cla(app.UIAxes_2A);  % clear right plot


% checks value of drop down
switch whichIndex

    case 'GNI'
        % passes the value from edit field into checkCountry1
        checkCountry1 = app.CountryRegion1EditField.Value;
        %% New function sttep for editing parts of strin
        % makes the spaces in the input an underline so I can use it in
        % struct
        checkCountry1U = (strrep(checkCountry1, ' ', '_'));
        % passes the value from edit field into checkCountry2
        checkCountry2 = app.CountryRegion2EditField.Value;
        % makes the spaces in the input an underline so I can use it in
        % struct
        checkCountry2U = (strrep(checkCountry2, ' ', '_'));
        %% New function matlab.lang.makeValidName for allowing use in Matlab
        % passes underlined text into data that can be used for struct
        checkCountryName1 = matlab.lang.makeValidName(checkCountry1U);
        % passes underlined text into data that can be used for struct
        checkCountryName2 = matlab.lang.makeValidName(checkCountry2U);
        % enumerate while loop variables
        found = 0;
        iterator = 1;

        %% New function ismember for indexing into Cell
        % see if inputted country name is not in structure
        if ~ismember(checkCountryName1, countryCell)
            % displays error message
            app.ErrorMessageLabel.Visible = 'on';
            % stops program
            return;
        end

        % see if inputted country name is not in structure
        if ~ismember(checkCountryName2, countryCell)
            % displays error message
            app.ErrorMessageLabel.Visible = 'on';
            % stops program
            return;
        end
        % runs when the value in struct is not found
        while found == 0
            if strcmp("Gross National Income Per Capita (2017 PPP$)", app.s.(checkCountryName1)(iterator,3))
                % gets iterated value and fills vector with data from that
                % point into the following variables
                years1 = app.s.(checkCountryName1)(iterator:iterator+11,4);
                app.country1 = cell2mat(app.s.(checkCountryName1)(iterator:iterator+11,5));
                % ends loop
                found = 1;
            end
            % updates iterator
            iterator = iterator + 1;
        end

        % if found == 0
        %     disp("Error")
        % end
        % enumerate while loop variables
        found = 0;
        iterator = 1;
        % runs when the value in struct is not found
        while found == 0
            if strcmp("Gross National Income Per Capita (2017 PPP$)", app.s.(checkCountryName2)(iterator,3))
                % gets iterated value and fills vector with data from that
                % point into the following variables
                years2 = app.s.(checkCountryName2)(iterator:iterator+11,4);
                app.country2 = cell2mat(app.s.(checkCountryName2)(iterator:iterator+11,5));
                % ends loop
                found = 1;
            end
            % updates iterator
            iterator = iterator + 1;
        end
        % holds year vector
        years1 = str2double(years1);
        % holds year vector
        years2 = str2double(years2);
        % hard codes global years vector 
        app.years = [2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022];

        % stops displaying error message
        app.ErrorMessageLabel.Visible = 'off';

        % Plot

        plot(app.UIAxesA, app.years, app.country1, '-o');
        % allows data to continue plotting
        hold(app.UIAxesA, 'on')
        xlabel(app.UIAxesA,'Year');
        ylabel(app.UIAxesA,'Value');
        title(app.UIAxesA, checkCountry1, 'GNI vs Year');
        %% New function xticks for plotting
        % hardcodes the x values on plot
        xticks(app.UIAxesA, [2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
        grid(app.UIAxesA, 'on');
        
        % Plot

        plot(app.UIAxes_2A, app.years, app.country2, '-o');
        % allows data to continue plotting
        hold(app.UIAxes_2A, 'on')
        xlabel(app.UIAxes_2A, 'Year');
        ylabel(app.UIAxes_2A, 'Value');
        title(app.UIAxes_2A, checkCountry2, 'GNI vs Year');
        % hardcodes the x values on plot
        xticks(app.UIAxes_2A, [2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
        grid(app.UIAxes_2A,'on');
        
        % checks value in dropdown
        switch dropDown

            case '2002 Financial Crisis'
                idx2002 = 2;     % use years2 that matches country2

                xDot = 2002;
                yDot = app.country1(idx2002);           % y‑value for 2002
                plot(app.UIAxesA, xDot, yDot, 'ro', ...
                    'MarkerSize', 8, 'LineWidth', 1.5);


                jdx2002 = 2;      % use years2 that matches country2

                xDot = 2002;
                yDot = app.country2(jdx2002);           % y‑value for 2002
                plot(app.UIAxes_2A, xDot, yDot, 'ro', ...
                    'MarkerSize', 8, 'LineWidth', 1.5);


            case '2008 Recession'
                idx2008 = 5;      % use years2 that matches country2

                xDot = 2008;
                yDot = app.country1(idx2008);           % y‑value for 2008
                plot(app.UIAxesA, xDot, yDot, 'ro', ...
                    'MarkerSize', 8, 'LineWidth', 1.5);


                jdx2008 = 5;      % use years2 that matches country2

                xDot = 2008;
                yDot = app.country2(jdx2008);           % y‑value for 2008
                plot(app.UIAxes_2A, xDot, yDot, 'ro', ...
                    'MarkerSize', 8, 'LineWidth', 1.5);


            case '2020 Covid-19 Pandemic'
                idx2020 = 11;      % use years2 that matches country2

                xDot = 2020;
                yDot = app.country1(idx2020);           % y‑value for 2020
                plot(app.UIAxesA, xDot, yDot, 'ro', ...
                    'MarkerSize', 8, 'LineWidth', 1.5);


                jdx2020 = 11;      % use years2 that matches country2

                xDot = 2020;
                yDot = app.country2(jdx2020);           % y‑value for 2020
                plot(app.UIAxes_2A, xDot, yDot, 'ro', ...
                    'MarkerSize', 8, 'LineWidth', 1.5);


                % hold(app.UIAxes, 'off')
                % hold(app.UIAxes_2, 'off')

        end

    case 'Life Expectancy'

        % passes the value from edit field into checkCountry1
        checkCountry1 = app.CountryRegion1EditField.Value;
        % makes the spaces in the input an underline so I can use it in
        % struct
        checkCountry1U = (strrep(checkCountry1, ' ', '_'));
        % passes the value from edit field into checkCountry2
        checkCountry2 = app.CountryRegion2EditField.Value;
        % makes the spaces in the input an underline so I can use it in
        % struct
        checkCountry2U = (strrep(checkCountry2, ' ', '_'));
        % passes underlined text into data that can be used for struct
        checkCountryName1 = matlab.lang.makeValidName(checkCountry1U);
        % passes underlined text into data that can be used for struct
        checkCountryName2 = matlab.lang.makeValidName(checkCountry2U);
        % enumerate while loop variables
        found = 0;
        iterator = 1;

        % see if inputted country name is not in structure
        if ~ismember(checkCountryName1, countryCell)
            % displays error message
            app.ErrorMessageLabel.Visible = 'on';
            % stops program
            return;
        end

        % see if inputted country name is not in structure
        if ~ismember(checkCountryName2, countryCell)
            % displays error message
            app.ErrorMessageLabel.Visible = 'on';
            % stops program
            return;
        end

        % runs when the value in struct is not found
        while found == 0
            if strcmp("Life Expectancy at Birth (years)", app.s.(checkCountryName1)(iterator,3))
                % gets iterated value and fills vector with data from that
                % point into the following variables
                years1 = app.s.(checkCountryName1)(iterator:iterator+11,4);
                app.country1 = cell2mat(app.s.(checkCountryName1)(iterator:iterator+11,5));
                % ends loop
                found = 1;
            end
            % iterates value
            iterator = iterator + 1;
        end
        % enumerate while loop variables
        found = 0;
        iterator = 1;
        % runs when the value in struct is not found
        while found == 0
            if strcmp("Life Expectancy at Birth (years)", app.s.(checkCountryName2)(iterator,3))
                % gets iterated value and fills vector with data from that
                % point into the following variables
                years2 = app.s.(checkCountryName2)(iterator:iterator+11,4);
                app.country2 = cell2mat(app.s.(checkCountryName2)(iterator:iterator+11,5));
                % ends loop
                found = 1;
            end
            % iterates value
            iterator = iterator + 1;
        end
        % somewhat irrelevant year vector
        years1 = str2double(years1);
        % somewhat irrelevant year vector
        years2 = str2double(years2);

        % stops displaying error message
        app.ErrorMessageLabel.Visible = 'off';

        % Plot

        plot(app.UIAxesA, app.years, app.country1, '-o');
        % allows data to continue plotting
        hold(app.UIAxesA, 'on')
        xlabel(app.UIAxesA, 'Year');
        ylabel(app.UIAxesA, 'Value');
        title(app.UIAxesA, checkCountry1, 'Life Expectancy vs Year');
        % hardcodes the x values on plot
        xticks(app.UIAxesA, [2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
        grid(app.UIAxesA, 'on');

        plot(app.UIAxes_2A, app.years, app.country2, '-o');
        % allows data to continue plotting
        hold(app.UIAxes_2A, 'on')
        xlabel(app.UIAxes_2A, 'Year');
        ylabel(app.UIAxes_2A, 'Value');
        title(app.UIAxes_2A, checkCountry2, 'Life Expectancy vs Year');
        % hardcodes the x values on plot
        xticks(app.UIAxes_2A, [2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
        grid(app.UIAxes_2A, 'on');
        
        % checks value in dropdown
        switch dropDown

            case '2002 Financial Crisis'
                idx2002 = 2;      % use years2 that matches country2
                
                    xDot = 2002;
                    yDot = app.country1(idx2002);           % y‑value for 2002
                    plot(app.UIAxesA, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                

                jdx2002 = 2;      % use years2 that matches country2
                
                    xDot = 2002;
                    yDot = app.country2(jdx2002);           % y‑value for 2002
                    plot(app.UIAxes_2A, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                

            case '2008 Recession'
                idx2008 = find(years1 == 2008, 1);      % use years2 that matches country2
                if ~isempty(idx2008)
                    xDot = 2008;
                    yDot = app.country1(idx2008);           % y‑value for 2008
                    plot(app.UIAxesA, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                end

                jdx2008 = find(years2 == 2008, 1);      % use years2 that matches country2
                if ~isempty(jdx2008)
                    xDot = 2008;
                    yDot = app.country2(jdx2008);           % y‑value for 2008
                    plot(app.UIAxes_2A, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                end

            case '2020 Covid-19 Pandemic'
                idx2020 = 11;      % use years2 that matches country2
                
                    xDot = 2020;
                    yDot = app.country1(idx2020);           % y‑value for 2020
                    plot(app.UIAxesA, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                

                jdx2020 = 11;      % use years2 that matches country2
                if ~isempty(jdx2020)
                    xDot = 2020;
                    yDot = app.country2(jdx2020);           % y‑value for 2020
                    plot(app.UIAxes_2A, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                end
                % 
                % hold(app.UIAxes, 'off')
                % hold(app.UIAxes_2, 'off')

        end

    case 'Mean Years of Schooling'

        % passes the value from edit field into checkCountry1
        checkCountry1 = app.CountryRegion1EditField.Value;
        % makes the spaces in the input an underline so I can use it in
        % struct
        checkCountry1U = (strrep(checkCountry1, ' ', '_'));
        % passes the value from edit field into checkCountry2
        checkCountry2 = app.CountryRegion2EditField.Value;
        % makes the spaces in the input an underline so I can use it in
        % struct
        checkCountry2U = (strrep(checkCountry2, ' ', '_'));
        % passes underlined text into data that can be used for struct
        checkCountryName1 = matlab.lang.makeValidName(checkCountry1U);
        % passes underlined text into data that can be used for struct
        checkCountryName2 = matlab.lang.makeValidName(checkCountry2U);
        % enumerate while loop variables
        found = 0;
        iterator = 1;

        % see if inputted country name is not in structure
        if ~ismember(checkCountryName1, countryCell)
            % displays error message
            app.ErrorMessageLabel.Visible = 'on';
            % stops program
            return;
        end

        % see if inputted country name is not in structure
        if ~ismember(checkCountryName2, countryCell)
            % displays error message
            app.ErrorMessageLabel.Visible = 'on';
            % stops program
            return;
        end

        % runs when the value in struct is not found
        while found == 0
            if strcmp("Mean Years of Schooling (years)", app.s.(checkCountryName1)(iterator,3))
                % gets iterated value and fills vector with data from that
                % point into the following variables
                years1 = app.s.(checkCountryName1)(iterator:iterator+11,4);
                app.country1 = cell2mat(app.s.(checkCountryName1)(iterator:iterator+11,5));
                % ends loop
                found = 1;
            end
            % updates iterator
            iterator = iterator + 1;
        end
        % enumerate while loop variables
        found = 0;
        iterator = 1;
        % runs when the value in struct is not found
        while found == 0
            if strcmp("Mean Years of Schooling (years)", app.s.(checkCountryName2)(iterator,3))
                % gets iterated value and fills vector with data from that
                % point into the following variables
                years2 = app.s.(checkCountryName2)(iterator:iterator+11,4);
                app.country2 = cell2mat(app.s.(checkCountryName2)(iterator:iterator+11,5));
                % ends loop
                found = 1;
            end
            % updates iterator
            iterator = iterator + 1;
        end
        % irrelevant vector
        years1 = str2double(years1);
        % irrelevant vector
        years2 = str2double(years2);

        % stops displaying error message
        app.ErrorMessageLabel.Visible = 'off';

        % Plot

        plot(app.UIAxesA, app.years, app.country1, '-o');
        % allows data to continue plotting
        hold(app.UIAxesA, 'on')
        xlabel(app.UIAxesA, 'Year');
        ylabel(app.UIAxesA, 'Value');
        title(app.UIAxesA, checkCountry1, 'Mean Years of Schooling vs Year');
        % hardcodes the x values on plot
        xticks(app.UIAxesA, [2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
        grid(app.UIAxesA, 'on');


        plot(app.UIAxes_2A, app.years, app.country2, '-o');
        % allows data to continue plotting
        hold(app.UIAxes_2A, 'on')
        xlabel(app.UIAxes_2A, 'Year');
        ylabel(app.UIAxes_2A, 'Value');
        title(app.UIAxes_2A, checkCountry2, 'Mean Years of Schooling vs Year');
        % hardcodes the x values on plot
        xticks(app.UIAxes_2A, [2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 2022])
        grid(app.UIAxes_2A, 'on');
        % checks value in drop down
        switch dropDown

            case '2002 Financial Crisis'
                idx2002 = 2;      % use years2 that matches country2
                
                    xDot = 2002;
                    yDot = app.country1(idx2002);           % y‑value for 2002
                    plot(app.UIAxesA, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                

                jdx2002 = 2;      % use years2 that matches country2
                
                    xDot = 2002;
                    yDot = app.country2(jdx2002);           % y‑value for 2002
                    plot(app.UIAxes_2A, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                

            case '2008 Recession'
                idx2008 = 5;      % use years2 that matches country2
                
                    xDot = 2008;
                    yDot = app.country1(idx2008);           % y‑value for 2008
                    plot(app.UIAxesA, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                

                jdx2008 = 5;      % use years2 that matches country2
                
                    xDot = 2008;
                    yDot = app.country2(jdx2008);           % y‑value for 2008
                    plot(app.UIAxes_2A, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                

            case '2020 Covid-19 Pandemic'
                idx2020 = 11;      % use years2 that matches country2
                
                    xDot = 2020;
                    yDot = app.country1(idx2020);           % y‑value for 2020
                    plot(app.UIAxesA, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                

                jdx2020 = 11;      % use years2 that matches country2
                
                    xDot = 2020;
                    yDot = app.country2(jdx2020);           % y‑value for 2020
                    plot(app.UIAxes_2A, xDot, yDot, 'ro', ...
                        'MarkerSize', 8, 'LineWidth', 1.5);
                
                % hold(app.UIAxes, 'off')
                % hold(app.UIAxes_2, 'off')
            

        end

end



