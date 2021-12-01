function pr = PlotPriceData(AllData, ShowRisk, ShowMARatios, ShowMA, ShowPriceDiv, ShowLogOver20Week, useLog, ShowBollingerBand, PlotSettings)
% data, how many data points and if to use log (1 is yes, 0 is no)
    n = round(AllData{3});
    closeData = AllData{2};
    data = AllData{1};
    symbol1 = AllData{4};
    symbol2 = AllData{5};
    interval = AllData{6};
    is60m = 0;
    if(contains(interval, "m") && ~contains(interval, "mo"))
        is60m = 1;
    end
    
    is1wk = 0;
    if (contains(interval, '1wk'))
        is1wk = 1;
    end
    
    closeData = closeData(~(closeData == 0));
    data.Date = data.Date(~(closeData == 0));
    
    [pr, r50O20W, r50d50w, pO50W, pO200W, pO20W, lnp20w, risk, movingAverage] = RiskCalc(closeData, is60m, is1wk);
    dates = data.Date;
    
    inData = closeData;
    if(useLog == 1)
        inData = log10(closeData);
        inData(inData == log10(0)) = 0;
        movingAverage.ma20WeeksInDays = log10(movingAverage.ma20WeeksInDays);
        movingAverage.ma50Day = log10(movingAverage.ma50Day);
        movingAverage.ma350Day = log10(movingAverage.ma350Day);
        movingAverage.ma1400Day = log10(movingAverage.ma1400Day);
    end

    if ShowMA.MA50day == 0
        movingAverage.ma50Day = -1;
    end
    if ShowMA.MA20Week == 0
        movingAverage.ma20WeeksInDays = -1;
    end
    
    if ShowMA.MA50week == 0
        movingAverage.ma350Day = -1;
    end
    if ShowMA.MA200Week == 0
        movingAverage.ma1400Day = -1;
    end
    
    if (ShowRisk.MainPlot == 1)
        if(pr ~= -1)
            plotData(n, useLog, pr, dates, inData, symbol1, symbol2, 'Combinations', ShowBollingerBand, movingAverage, PlotSettings, ShowRisk.RiskPlot);
        end
    end
    
    if(ShowMARatios == 1)
        if(r50O20W ~= -1)
            plotData(n, useLog, r50O20W, dates, inData, symbol1, symbol2, '50 days / 20 weeks', ShowBollingerBand, movingAverage, PlotSettings, ShowRisk.RiskPlot);
        end
        
        if(r50d50w ~= -1)
            plotData(n, useLog, r50d50w, dates, inData, symbol1, symbol2, '50 day / 50 week average', ShowBollingerBand, movingAverage, PlotSettings, ShowRisk.RiskPlot);
        end
        
        if(risk ~= -1)
            plotData(n, useLog, risk, dates, inData, symbol1, symbol2, '20 week MA / 50 week MA (350 days)', ShowBollingerBand, movingAverage, PlotSettings, ShowRisk.RiskPlot);
        end
    end
    
    if(ShowPriceDiv == 1)
        %figure
        if (pO200W ~= -1)
            plotData(n, useLog, pO200W, dates, inData, symbol1, symbol2, 'price / 200 weeks', ShowBollingerBand, movingAverage, PlotSettings, ShowRisk.RiskPlot);
        end
        
        if(pO50W ~= -1)
            plotData(n, useLog, pO50W, dates, inData, symbol1, symbol2, 'price / 50 weeks', ShowBollingerBand, movingAverage, PlotSettings, ShowRisk.RiskPlot);
        end
        
        if (pO20W ~= -1)
            plotData(n, useLog, pO20W, dates, inData, symbol1, symbol2, 'price / 20 weeks', ShowBollingerBand, movingAverage, PlotSettings, ShowRisk.RiskPlot);
        end
    end
    
    if (ShowLogOver20Week == 1)
        if (lnp20w ~= -1)
            %figure
            lnp20w(lnp20w > 0) = 1;
            lnp20w(lnp20w < 0) = 0;
            plotData(n, useLog, lnp20w, dates, inData, symbol1, symbol2, 'log10(price / 20 weeks)', ShowBollingerBand, movingAverage, PlotSettings, ShowRisk.RiskPlot);
        end
    end
end

function plotData(n, useLog, data1, data2, data3, symbol1, symbol2, PlotTitle, ShowBollingerBand, movingAverage, PlotSettings, RiskPlot)
    if (n > size(data1, 1))
        n = size(data1, 1);
    end
    %f = figure;
    %f.WindowState = 'maximized';
    nexttile
    data1 = data1(end-n+1:end);
    data2 = data2(end-n+1:end);
    data3 = data3(end-n+1:end);
    if(useLog == 1)
        minValue = min(data3);
        ylim([0 abs(minValue)*1.25])
    else
        maxValue = max(data3);
        ylim([0 maxValue*1.25])
    end
    if ShowBollingerBand == 1
        [middle,upper,lower] = bollinger(data3,'WindowSize',20);
        AllBollinger = [middle,upper,lower];
    else 
        AllBollinger = -1;
    end
    Plots(useLog, AllBollinger, movingAverage, PlotSettings, RiskPlot, symbol1, symbol2, data2, data3, data1);
    hold on;
    title(PlotTitle, 'Color', 'w')
end