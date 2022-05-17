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
[NUMERIC, TXT, RAW] = xlsread("ardd_fatalities_2011_2021.xlsx");
% RAW([1, 2, 3, 4, 5],:) = [];
% NUMERIC([1, 2, 3, 4, 5],:) = [];
dataset = cell2table(RAW);
% dataNumeric = cell2table(NUMERIC);
dataset.Properties.VariableNames = ["State", "Month", "Year", "Dayweek", "Time", "Crash Type", "Bus Involvement", "Heavy Rigid Truck Involvement", "Articulated Truck Involvement", "Speed Limit", "Road User", "Gender", "Age", "National Remoteness Areas", "SA4 Name 2016", "National LGA Name 2017", "National Road Type", "Christmas Period", "Easter Period", "Age Group", "Day of week", "Time of day"];
% dataArr = table2array(data);
% NUMERIC = NUMERIC(["State", "Month", "Year", "Dayweek", "Time", "Crash Type", "Bus Involvement", "Heavy Rigid Truck Involvement", "Articulated Truck Involvement", "Speed Limit", "Road User", "Gender", "Age", "National Remoteness Areas", "SA4 Name 2016", "National LGA Name 2017", "National Road Type", "Christmas Period", "Easter Period", "Age Group", "Day of week", "Time of day"]);
%% Data Pre-Processing
% Missing values:
% Interval/Numeric - replaced by median value
% data.("Speed Limit")(data.("Speed Limit") == -9) = nan;
% data.("Speed Limit")(data{:,"Speed Limit"} == -9)= nan;
% data.("Speed Limit")(isEqual(data.("Speed Limit"), -9)) = nan;
% medianSpeedLimit = median(data.("Speed Limit"), "omitnan");
% data.("Speed Limit")(isnan(data.("Speed Limit"))) = medianSpeedLimit;
for i=1:length(dataset.("Speed Limit"))
    a = dataset.("Speed Limit")(i);
    if a == -9
        dataset.("Speed Limit")(i) = nan;
    end
    if isa(a, "double") == false
        dataset.("Speed Limit")(i) = nan;
    end
end

%% Road User Average Speed Limit

cRoadUsers = categorical(dataset{:, 11});
roadUsers = categories(cRoadUsers);
numRoadUsers = countcats(cRoadUsers);

speedLimit = dataset{:, 10};
avgSpeedLimit = mean(speedLimit, "omitnan");


cyclistAvg = 0;
cyclistCount = 0;
driverAvg = 0;
driverCount = 0;
motorcyclePassAvg = 0;
motorcyclePassCount = 0;
motorcycleRiderAvg = 0;
motorcycleRiderCount = 0;
otherAvg = 0;
otherCount = 0;
passengerAvg = 0;
passengerCount = 0;
pedestrianAvg = 0;
pedestrianCount = 0;

for i=1:length(speedLimit)
    user = dataset{i, 11};
    if isnan(speedLimit(i)) == false
        if user == "Cyclist"
            cyclistAvg = cyclistAvg + speedLimit(i);
            cyclistCount = cyclistCount + 1;
        end
        if user == "Driver"
            driverAvg = driverAvg + speedLimit(i);
            driverCount = driverCount + 1;
        end
        if user == "Motorcycle pillion passenger" 
            motorcyclePassAvg = motorcyclePassAvg + speedLimit(i);
            motorcyclePassCount = motorcyclePassCount + 1;
        end
        if user == "Motorcycle rider"	
            motorcycleRiderAvg = motorcycleRiderAvg + speedLimit(i);
            motorcycleRiderCount = motorcycleRiderCount + 1;
        end
        if user == "Other/-9"	
            otherAvg = otherAvg + speedLimit(i);
            otherCount = otherCount + 1;
        end
        if user == "Passenger"
            passengerAvg = passengerAvg + speedLimit(i);
            passengerCount = passengerCount + 1;
        end
        if user == "Pedestrian"
            pedestrianAvg = pedestrianAvg + speedLimit(i);
            pedestrianCount = pedestrianCount + 1;
        end
    end
end

cyclistAvg = cyclistAvg/cyclistCount;
driverAvg = driverAvg/driverCount;
motorcyclePassAvg = motorcyclePassAvg/motorcyclePassCount;
motorcycleRiderAvg = motorcycleRiderAvg/motorcycleRiderCount;
passengerAvg = passengerAvg/passengerCount;
pedestrianAvg = pedestrianAvg/pedestrianCount;

roadUserAvgSpeedLimit = {"Average Speed Limit (km/h)", cyclistAvg, driverAvg, motorcyclePassAvg, motorcycleRiderAvg, passengerAvg, pedestrianAvg, avgSpeedLimit};
roadUserAvgSpeedLimit = cell2table(roadUserAvgSpeedLimit);
roadUserAvgSpeedLimit.Properties.VariableNames = [" ", "Cyclist", "Driver", "Motorcycle Pillion Passenger", "Motorcycle Rider", "Passenger", "Pedestrian", "Combined"];

%% Road User Time of Day

roadUserTimeofDay = table('Size', [0 7], 'VariableTypes', ["string", "string", "string", "string", "string", "string", "string"]);
cyclistCount = 1;
driverCount = 1;
motorcyclePassCount = 1;
motorcycleRiderCount = 1;
otherCount = 1;
passengerCount = 1;
pedestrianCount = 1;

for i=1:length(dataset{:, 22})
    time = dataset{i, "Time of day"};
    user = char(dataset{i, "Road User"});
    switch user
        case char("Cyclist")
            roadUserTimeofDay{cyclistCount, 1} = time;
            cyclistCount = cyclistCount + 1;
        case char("Driver")
            roadUserTimeofDay{driverCount, 2} = time;
            driverCount = driverCount + 1;
        case char("Motorcycle pillion passenger")
            roadUserTimeofDay{motorcyclePassCount, 3} = time;
            motorcyclePassCount = motorcyclePassCount + 1;
        case char("Motorcycle rider")
            roadUserTimeofDay{motorcycleRiderCount, 4} = time;
            motorcycleRiderCount = motorcycleRiderCount + 1;
        case char("Passenger")
            roadUserTimeofDay{passengerCount, 5} = time;
            passengerCount = passengerCount + 1;
        case char("Pedestrian")
            roadUserTimeofDay{pedestrianCount, 6} = time;
            pedestrianCount = pedestrianCount + 1;
        otherwise 
            roadUserTimeofDay{otherCount, 7} = time;
            otherCount = otherCount + 1;
    end
end
for i=1:length(roadUserTimeofDay{:, 1})
    for j=1:7
        if isempty(roadUserTimeofDay{i, j})
            roadUserTimeofDay(i, j) = "ok";
        end
    end
end
roadUserTimeofDay.Properties.VariableNames = ["Cyclist", "Driver", "Motorcycle Pillion Passenger", "Motorcycle Rider", "Passenger", "Pedestrian", "Other"];

%%

roadUserDayNightData = table('Size', [0 9], 'VariableTypes', ["string", "double", "double", "double", "double", "double", "double", "double", "double"]);

roadUserDayNightData{1, 1} = "Daytime Incident Rate";
roadUserDayNightData{2, 1} = "Nighttime Incident Rate";

totalDays = 0;
totalNights = 0;

days = 0;
nights = 0;
for i=1:length(roadUserTimeofDay{:, "Cyclist"})
    time = roadUserTimeofDay{i, "Cyclist"};
    if time == missing
        break
    end
    switch time
        case char("Day")
            days = days + 1;
        case char("Night")
            nights = nights + 1;
    end
end
totalDays = totalDays + days;
totalNights = totalNights + nights;
roadUserDayNightData{1, 2} = days/(days + nights);
roadUserDayNightData{2, 2} = nights/(days + nights);

days = 0;
nights = 0;
for i=1:length(roadUserTimeofDay{:, "Driver"})
    time = roadUserTimeofDay{i, "Driver"};
    if time == missing
        break
    end
    switch time
        case char("Day")
            days = days + 1;
        case char("Night")
            nights = nights + 1;
    end
end
totalDays = totalDays + days;
totalNights = totalNights + nights;
roadUserDayNightData{1, 3} = days/(days + nights);
roadUserDayNightData{2, 3} = nights/(days + nights);

days = 0;
nights = 0;
for i=1:length(roadUserTimeofDay{:, "Motorcycle Pillion Passenger"})
    time = roadUserTimeofDay{i, "Motorcycle Pillion Passenger"};
    if time == missing
        break
    end
    switch time
        case char("Day")
            days = days + 1;
        case char("Night")
            nights = nights + 1;
    end
end
totalDays = totalDays + days;
totalNights = totalNights + nights;
roadUserDayNightData{1, 4} = days/(days + nights);
roadUserDayNightData{2, 4} = nights/(days + nights);

days = 0;
nights = 0;
for i=1:length(roadUserTimeofDay{:, "Motorcycle Rider"})
    time = roadUserTimeofDay{i, "Motorcycle Rider"};
    if time == missing
        break
    end
    switch time
        case char("Day")
            days = days + 1;
        case char("Night")
            nights = nights + 1;
    end
end
totalDays = totalDays + days;
totalNights = totalNights + nights;
roadUserDayNightData{1, 5} = days/(days + nights);
roadUserDayNightData{2, 5} = nights/(days + nights);

days = 0;
nights = 0;
for i=1:length(roadUserTimeofDay{:, "Passenger"})
    time = roadUserTimeofDay{i, "Passenger"};
    if time == missing
        break
    end
    switch time
        case char("Day")
            days = days + 1;
        case char("Night")
            nights = nights + 1;
    end
end
totalDays = totalDays + days;
totalNights = totalNights + nights;
roadUserDayNightData{1, 6} = days/(days + nights);
roadUserDayNightData{2, 6} = nights/(days + nights);

days = 0;
nights = 0;
for i=1:length(roadUserTimeofDay{:, "Pedestrian"})
    time = roadUserTimeofDay{i, "Pedestrian"};
    if time == missing
        break
    end
    switch time
        case char("Day")
            days = days + 1;
        case char("Night")
            nights = nights + 1;
    end
end
totalDays = totalDays + days;
totalNights = totalNights + nights;
roadUserDayNightData{1, 7} = days/(days + nights);
roadUserDayNightData{2, 7} = nights/(days + nights);

days = 0;
nights = 0;
for i=1:length(roadUserTimeofDay{:, "Other"})
    time = roadUserTimeofDay{i, "Other"};
    if time == missing
        break
    end
    switch time
        case char("Day")
            days = days + 1;
        case char("Night")
            nights = nights + 1;
    end
end
totalDays = totalDays + days;
totalNights = totalNights + nights;
roadUserDayNightData{1, 8} = days/(days + nights);
roadUserDayNightData{2, 8} = nights/(days + nights);

roadUserDayNightData{1, 9} = totalDays/(totalDays + totalNights);
roadUserDayNightData{2, 9} = totalNights/(totalDays + totalNights);

roadUserDayNightData.Properties.VariableNames = ["Time of Day", "Cyclist", "Driver", "Motorcycle Pillion Passenger", "Motorcycle Rider", "Passenger", "Pedestrian", "Unknown Users", "Total"];


%% Correlation Matrix
%  function to convert to a numerical array
% filteredData = data(:, {'Age', 'Gender', 'Time of day','Dayweek', 'Month', 'Year', 'State', 'Speed Limit', 'Christmas Period', 'Easter Period', 'Road User'});
 filteredData = dataset(:, {'Age', 'Month', 'Year', 'Speed Limit'});

cm = corr(filteredData{:, :});