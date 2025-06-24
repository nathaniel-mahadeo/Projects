function sortData(app)
% The following function sorts the data used for the app. It does so in a
% more brute force way using simpler code rather than complex functions
% that we did not learn.

% Loads the Data
% Uses a sorted version of the data that cuts out countries where not all
% the information is present ("Fully Sorted EG Project Data")
projData = readtable("Fully Sorted EG Project Data.xlsx","TextType","string");
projData = table2cell(projData);

[nRows,~] = size(projData);

%%
% Sets empty vector for finding the countries
app.countries = {};

for iV = 2:nRows
    if str2double(projData{iV,4}) == 2000 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
       app.countries = [app.countries; projData(iV,2)];
    end
end

% Finds country length
countryAmount = length(app.countries);


%%
% Sets an empty vector for finding the life expectancy
LEstats2000 = [];
GNIstats2000 = [];
Schoolstats2000 = [];

LEstats2002 = [];
GNIstats2002 = [];
Schoolstats2002 = [];

LEstats2004 = [];
GNIstats2004 = [];
Schoolstats2004 = [];

LEstats2006 = [];
GNIstats2006 = [];
Schoolstats2006 = [];

LEstats2008 = [];
GNIstats2008 = [];
Schoolstats2008 = [];

LEstats2010 = [];
GNIstats2010 = [];
Schoolstats2010 = [];

LEstats2012 = [];
GNIstats2012 = [];
Schoolstats2012 = [];

LEstats2014 = [];
GNIstats2014 = [];
Schoolstats2014 = [];

LEstats2016 = [];
GNIstats2016 = [];
Schoolstats2016 = [];

LEstats2018 = [];
GNIstats2018 = [];
Schoolstats2018 = [];

LEstats2020 = [];
GNIstats2020 = [];
Schoolstats2020 = [];

LEstats2022 = [];
GNIstats2022 = [];
Schoolstats2022 = [];

HDIrank = [];



% Take all the information from the file and sorts it into a year and a
% stat


for iV = 1:nRows
    if str2double(projData{iV,4}) == 2000 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2000 = [LEstats2000;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2000 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2000 = [GNIstats2000;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2000 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2000 = [Schoolstats2000;projData(iV,5)];

    elseif str2double(projData{iV,4}) == 2002 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2002 = [LEstats2002;projData(iV,5)];

    elseif str2double(projData{iV,4}) == 2002 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2002 = [GNIstats2002;projData(iV,5)];    

    elseif str2double(projData{iV,4}) == 2002 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2002 = [Schoolstats2002;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2004 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2004 = [LEstats2004;projData(iV,5)];
   
    elseif str2double(projData{iV,4}) == 2004 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2004 = [GNIstats2004;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2004 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2004 = [Schoolstats2004;projData(iV,5)];   

    elseif str2double(projData{iV,4}) == 2006 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2006 = [LEstats2006;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2006 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2006 = [GNIstats2006;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2006 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2006 = [Schoolstats2006;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2008 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2008 = [LEstats2008;projData(iV,5)];    

    elseif str2double(projData{iV,4}) == 2008 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2008 = [GNIstats2008;projData(iV,5)];
   
    elseif str2double(projData{iV,4}) == 2008 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2008 = [Schoolstats2008;projData(iV,5)];
   
    elseif str2double(projData{iV,4}) == 2010 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2010 = [LEstats2010;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2010 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2010 = [GNIstats2010;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2010 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2010 = [Schoolstats2010;projData(iV,5)];
   
    elseif str2double(projData{iV,4}) == 2012 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2012 = [LEstats2012;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2012 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2012 = [GNIstats2012;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2012 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2012 = [Schoolstats2012;projData(iV,5)];    

    elseif str2double(projData{iV,4}) == 2014 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2014 = [LEstats2014;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2014 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2014 = [GNIstats2014;projData(iV,5)];
   
    elseif str2double(projData{iV,4}) == 2014 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2014 = [Schoolstats2014;projData(iV,5)];
   
    elseif str2double(projData{iV,4}) == 2016 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2016 = [LEstats2016;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2016 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2016 = [GNIstats2016;projData(iV,5)];
   
    elseif str2double(projData{iV,4}) == 2016 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2016 = [Schoolstats2016;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2018 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2018 = [LEstats2018;projData(iV,5)];    

    elseif str2double(projData{iV,4}) == 2018 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2018 = [GNIstats2018;projData(iV,5)];   

    elseif str2double(projData{iV,4}) == 2018 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2018 = [Schoolstats2018;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2020 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2020 = [LEstats2020;projData(iV,5)];
    
    elseif str2double(projData{iV,4}) == 2020 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2020 = [GNIstats2020;projData(iV,5)];    

    elseif str2double(projData{iV,4}) == 2020 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2020 = [Schoolstats2020;projData(iV,5)];   

    elseif str2double(projData{iV,4}) == 2022 && strcmp(projData{iV,3},...
            "Life Expectancy at Birth (years)")
        LEstats2022 = [LEstats2022;projData(iV,5)];

    elseif str2double(projData{iV,4}) == 2022 && strcmp(projData{iV,3},...
            "Gross National Income Per Capita (2017 PPP$)")
        GNIstats2022 = [GNIstats2022;projData(iV,5)];   

    elseif str2double(projData{iV,4}) == 2022 && strcmp(projData{iV,3},...
            "Mean Years of Schooling (years)")
        Schoolstats2022 = [Schoolstats2022;projData(iV,5)];
    elseif strcmp(projData{iV,3},"HDI Rank")
        app.HDIrank = [app.HDIrank;projData(iV,5)];
    end
end
  

% Combines the stats into nested cell arrays
app.totalLEstats = {LEstats2000;LEstats2002;LEstats2004;LEstats2006;...
    LEstats2008;LEstats2010;LEstats2012;LEstats2014;LEstats2016;...
    LEstats2018;LEstats2020;LEstats2022};

app.totalGNIstats = {GNIstats2000;GNIstats2002;GNIstats2004;GNIstats2006;...
    GNIstats2008;GNIstats2010;GNIstats2012;GNIstats2014;GNIstats2016;...
    GNIstats2018;GNIstats2020;GNIstats2022};

app.totalSchoolStats = {Schoolstats2000;Schoolstats2002;Schoolstats2004;...
    Schoolstats2006;Schoolstats2008;Schoolstats2010;Schoolstats2012;...
    Schoolstats2014;Schoolstats2016;Schoolstats2018;Schoolstats2020;...
    Schoolstats2022};









































