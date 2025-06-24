function presetFunc(app)
% This function is used in the startup to preset the year in
% order to get the map generated before the app is generated. Also helps
% because then the order in which the user enters the year and country does 
% not matter
app.EnterYearEditField.Value = 2000;

% Places the heat map legend in the image box
app.heatMapKey.ImageSource = 'heatMap_legend.png';