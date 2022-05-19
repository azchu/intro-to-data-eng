%% Exporting the dataset
[NUMERIC, TXT, RAW] = xlsread("ardd_fatalities_2011_2021.xlsx", 1);
data = cell2table(RAW);

%% Setting variable names
data.Properties.VariableNames = ["State", "Month", "Year", "Dayweek", "Time", "Crash Type", "Bus Involvement", "Heavy Rigid Truck Involvement", "Articulated Truck Involvement", "Speed Limit", "Road User", "Gender", "Age", "National Remoteness Areas", "SA4 Name 2016", "National LGA Name 2017", "National Road Type", "Christmas Period", "Easter Period", "Age Group", "Day of week", "Time of day"];

%% Data Pre-Processing
% Missing values:
% Interval/Numeric - replaced by median value
medianSpeedLimit = median(data.("Speed Limit"), "omitnan");
data.("Speed Limit")(isnan(data.("Speed Limit"))) = medianSpeedLimit;
medianAge = median(data.Age, "omitnan");
data.Age(isnan(data.Age)) = medianAge;

%% Correlation Matrix for Numeric attributes
% Getting numeric attributes
numericData = data(:, {'Age', 'Month', 'Year', 'Speed Limit'});

% Creating correlation matrix
corrNumeric = corr(numericData{:, :});

%% Correlation Matrix for Suitable Categorical attributes
% gender, day week, easter, christmas

% Convert attributes to unique numbers (based on value)
catGender = double(categorical(data.Gender));
catDayWeek = double(categorical(data.Dayweek));
catChristmas = double(categorical(data.("Christmas Period")));
catEaster = double(categorical(data.("Easter Period")));

% Add attributes to the same matrix
categoricalData = [catGender, catDayWeek, catChristmas, catEaster];
% Remove rows where gender is equal to "Unknown" (3)
categoricalData(categoricalData(catGender) == 3, :) = [];

% Creating correlation matrix
corrCategorical = corr(categoricalData);

%% Death vs state barplot
[SC,SR] = groupcounts(data.State); 
bar(groupcounts(data.State));
title("Deaths per state");
ylabel("Death Count");
xlabel("State");
set(gca, 'XTickLabel',{"ACT",'NSW','NT','Qld','SA','TAS','VIC','WA'})

%% Deaths vs year barplot
[YC,YR] = groupcounts(data.Year);
c  = polyfit(YR, YC, 1);
xfit = polyval(c, YR);
plot(YR,YC,'r--o', YR, xfit,'b','MarkerFaceColor', 'r');
title("Deaths per year");
ylabel("Death Count (per person)");
xlabel("Year");

%% Pie chart for male vs female deaths
pieGender = groupcounts(data.Gender);
pieGender(3) = [];
pie(pieGender, {'Female','Male'});

%% regression Age and Year
% Fit the data with a regression to a quadratic polynomial.
t1 = polyfit(data.Year,data.Age,1);
    
% Compute the fitted model values.
xfit  = polyval(t1,data.Year);


plot(data.Year,data.Age,'r', data.Year,xfit,'b');
xlabel('Year');
ylabel('Age');
grid;

%% Age and Year histogram

%c = (find(a==1))

data_age_year = data(:, {'Age','Year'});

%    for i=1:length(data.("Age"))
%        a = data.("Age"){i};
%        if a == -9
%            data.("Age"){i} = nan;
%        end
%    end

data_age_year.("Age")(data_age_year.("Age") == -9) = nan;



data2011 = data_age_year.("Age")(data_age_year.Year == 2011);
data2021 = data_age_year.("Age")(data_age_year.Year == 2021);

data2011 = sort(data2011);
data2021 = sort(data2021);

histogram(data2011);
hold on 
histogram(data2021);

title("Deaths per Age 2011(blue) and 2021(orange)");
ylabel("Death Count(per person)");
xlabel("Ages");

% data11 = findgroups(data2011);
% num11 = splitapply(@sum, data2011,data11);


%% regression Speed Limit and Age

% Fit the data with a regression to a quadratic polynomial.
t1 = polyfit(data.("Speed Limit"),data.Age,1);
    
% Compute the fitted model values.
xfit  = polyval(t1,data.("Speed Limit"));

plot(data.("Speed Limit"),data.Age,'r.', data.("Speed Limit"),xfit,'b');

xlabel('Speed Limit');
ylabel('Age');
grid;
%% regression month and Speed Limit 

% Fit the data with a regression to a quadratic polynomial.
t1 = polyfit(data.Month,data.("Speed Limit"),1);
    
% Compute the fitted model values.
xfit  = polyval(t1,data.Month);

plot(data.Month,data.("Speed Limit"),'r.', data.Month,xfit,'b');

xlabel('Month');
ylabel('Speed Limit');
grid;

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

roadUserAvgSpeedLimit = {cyclistAvg, driverAvg, passengerAvg, motorcycleRiderAvg, motorcyclePassAvg, pedestrianAvg, avgSpeedLimit};
%% Creating Bar Chart
bar(cell2mat(roadUserAvgSpeedLimit));
labels = ["Cyclist", "Driver", "Passenger", "Motorcycle Rider", "Motorcycle Pillion Passenger", "Pedestrian", "All User Average"];
set(gca, "XTickLabel", labels);
title("Average Speed Limit for Road User Incidents");
ylabel("Speed Limit (km/h)");
xlabel("Road Users");


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


%% Tallying Day-Night Data

roadUserDayNightData = table('Size', [0 8], 'VariableTypes', ["double", "double", "double", "double", "double", "double", "double", "double"]);


totalDays = 0;
totalNights = 0;

% Cyclist
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
roadUserDayNightData{1, 1} = days/(days + nights);
roadUserDayNightData{2, 1} = nights/(days + nights);

% Driver
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
roadUserDayNightData{1, 2} = days/(days + nights);
roadUserDayNightData{2, 2} = nights/(days + nights);

% Passenger
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
roadUserDayNightData{1, 3} = days/(days + nights);
roadUserDayNightData{2, 3} = nights/(days + nights);

% Motorcycle rider
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
roadUserDayNightData{1, 4} = days/(days + nights);
roadUserDayNightData{2, 4} = nights/(days + nights);

% Motorcycle Passenger
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
roadUserDayNightData{1, 5} = days/(days + nights);
roadUserDayNightData{2, 5} = nights/(days + nights);

% Pedestrian
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
roadUserDayNightData{1, 6} = days/(days + nights);
roadUserDayNightData{2, 6} = nights/(days + nights);

% Other Users
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
roadUserDayNightData{1, 7} = days/(days + nights);
roadUserDayNightData{2, 7} = nights/(days + nights);

% Total
roadUserDayNightData{1, 8} = totalDays/(totalDays + totalNights);
roadUserDayNightData{2, 8} = totalNights/(totalDays + totalNights);

%% Creating Stacked Bar Chart
labels = ["Cyclist", "Driver", "Passenger", "Motorcycle Rider", "Motorcycle Pillion Passenger", "Pedestrian", "Unknown Users", "Total"];
ba = bar(table2array(roadUserDayNightData).', "stacked", "FaceColor","flat");
ba(1).CData = [1 1 0.3];
ba(2).CData = [0.1 0.1 0.1];
set(gca, "XTickLabel", labels);
title("Day/Night Incident Rates on Australian Roads");
ylabel("Day/Night ratio");
xlabel("Road Users");
legend("Day", "Night");
