% data = readcell("ardd_fatalities_month.xlsx", "UseExcel", true, "Sheet", "ARDD");
% [NUMERIC, TXT, RAW] = xlsread("ardd_fatalities_mar2022.xlsx", 2);
%% Declaring each variable
% state = data(:, 2);
% month = data(:, 3);
% year = data(:, 4);
% dayweek = data(:, 5);
% time = data(:, 6);
% crashtype = data(:, 7);
% bus = data(:, 8);
% heavyTruck = data(:, 9);
% artTruck = data(:, 10);
% speed = data(:, 11);
% user = data(:, 12);
% gender = data(:, 13);
% age = data(:, 14);
% christmas = data(:, 19);
% easter = data(:, 20);
% timeOfDay = data(:, 23);
[NUMERIC, TXT, RAW] = xlsread("ardd_fatalities_2011_2021.xlsx", 1);
% RAW([1, 2, 3, 4],:) = [];
% NUMERIC([1, 2, 3, 4],:) = [];
data = cell2table(RAW);
% dataNumeric = cell2table(NUMERIC);
data.Properties.VariableNames = ["State", "Month", "Year", "Dayweek", "Time", "Crash Type", "Bus Involvement", "Heavy Rigid Truck Involvement", "Articulated Truck Involvement", "Speed Limit", "Road User", "Gender", "Age", "National Remoteness Areas", "SA4 Name 2016", "National LGA Name 2017", "National Road Type", "Christmas Period", "Easter Period", "Age Group", "Day of week", "Time of day"];
% NUMERIC = NUMERIC(["State", "Month", "Year", "Dayweek", "Time", "Crash Type", "Bus Involvement", "Heavy Rigid Truck Involvement", "Articulated Truck Involvement", "Speed Limit", "Road User", "Gender", "Age", "National Remoteness Areas", "SA4 Name 2016", "National LGA Name 2017", "National Road Type", "Christmas Period", "Easter Period", "Age Group", "Day of week", "Time of day"]);
%% Data Pre-Processing
% Missing values:
% Interval/Numeric - replaced by median value
% data.("Speed Limit")(data.("Speed Limit") == -9) = nan;
data{:, "Speed Limit"}(data{:, "Speed Limit"} == -9)= nan;
% data.("Speed Limit")(isEqual(data.("Speed Limit"), -9)) = nan;
medianSpeedLimit = median(data.("Speed Limit"), "omitnan");
data.("Speed Limit")(isnan(data.("Speed Limit"))) = medianSpeedLimit;

%  function to convert to a numerical array
% filteredData = data(:, {'Age', 'Gender', 'Time of day','Dayweek', 'Month', 'Year', 'State', 'Speed Limit', 'Christmas Period', 'Easter Period', 'Road User'});
 filteredData = data(:, {'Age', 'Month', 'Year', 'Speed Limit'});
%% Correlation Matrix
cm = corr(filteredData{:, :});


