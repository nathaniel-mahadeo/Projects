% %%
% projData = readtable("Fully Sorted EG Project Data.xlsx","TextType","string");
% projData = table2cell(projData);
% 
% [nRows,~] = size(projData);
% 
% %
% % Sets empty vector for finding the countries
% countries = {};
% 
% for iV = 2:nRows
%     if str2double(projData{iV,4}) == 2000 && strcmp(projData{iV,3},...
%             "Life Expectancy at Birth (years)")
%        countries = [countries; projData(iV,2)];
%     end
% end
% 
% % Finds country length
% countryAmount = length(countries);
% 
% 
% years = 2000:2:2022;
% metrics = {
%     "Life Expectancy at Birth (years)", 'LEstats';
%     "Gross National Income Per Capita (2017 PPP$)", 'GNIstats';
%     "Mean Years of Schooling (years)", 'Schoolstats'
% };
% 
% % Initialize dynamic structures
% for y = years
%     for m = 1:size(metrics,1)
%         eval([metrics{m,2} num2str(y) ' = [];']);
%     end
% end
% 
% for iV = 1:nRows
%     year = str2double(projData{iV,4});
%     metric = projData{iV,3};
%     value = projData{iV,5};
% 
%     for m = 1:size(metrics,1)
%         if ismember(year, years) && strcmp(metric, metrics{m,1})
%             eval([metrics{m,2} num2str(year) ' = [' metrics{m,2} num2str(year) '; value];']);
%         end
%     end
% 
%     % Handle HDI rank
%     if strcmp(metric, "HDI Rank")
%         HDIrank = [HDIrank; value];
%     end
% end

x = [1,2,3,4,5,6];
y = [1,2,3,4,5,6];

z = "country";
v = "pope";

plot(x,y,'bo',MarkerFaceColor='b')
title(z+' '+ v)

