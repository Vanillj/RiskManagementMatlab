clc
clear

% Changable values, minimum days i 350
% Input data
symbol1 = 'INTC'; %'ETH-USD'
symbol2 = 'BTC-USD'; %'BTC-USD'

% Get stock from csv file (such as from https://www.nasdaq.com/market-activity/stocks/screener)
stocks = readtable('screener.csv').Symbol;

% Or from a given list (CTRL + R to comment, CTRL + T to uncomment)
stocks = {'WISH'
'PINS'
'F'
'AAPL'
'FCEL'
'T'
'VALE'
'TLRY'
'BBD'
'BAC'
'AMD'
'ITUB'
'AAL'
'PYPL'
'AMC'
'VZ'
'NVAX'
'PBR'
'CCL'
'SOFI'
'NIO'
'PLTR'
'BKR'};

% Properties
interval = '1d';
useLog = 0;
ShowRisk = 1;
ShowMA = 0;
ShowPriceDiv = 0;
ShowLogOver50Week = 0;

% Supported intervals are '60m', '1d', '5d', '1wk', '1mo', '3mo'
% Max value of days for 60m is 74 

%%
% Gather data
data = main(interval, symbol1);
% Plot data
PlotPriceData(data, ShowRisk, ShowMA, ShowPriceDiv, ShowLogOver50Week, useLog);

%% Find the stock with lowest risk in a given list
data = cell(length(stocks), 6);
maxCount = 20;
min = 2.*ones(maxCount,1);
ind = -1.*ones(maxCount,1);

for i = 1:length(stocks)
    s = stocks{i};
    d = main(interval, s);
    data{i, 1} = d{1, 1};
    data{i, 2} = d{1, 2};
    data{i, 3} = d{1, 3};
    data{i, 4} = d{1, 4};
    data{i, 5} = d{1, 5};
    data{i, 6} = d{1, 6};
    temp = PlotPriceData(d, 0, 0, 0, 0, 0);
    val = temp(end,1);
    indval = i;
    for j = 1:maxCount
        if val > 0 && min(j) > val
            for k = j:maxCount
                tempval = min(k);
                min(k) = val;
                val = tempval;
                
                tempind = ind(k);
                ind(k) = indval;
                indval = tempind;
            end
        end
    end
end

data(ind,4)
min
if ind > 0
    PlotPriceData(data(ind(1),:), ShowRisk, ShowMA, ShowPriceDiv, ShowLogOver50Week, useLog);
end