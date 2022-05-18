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