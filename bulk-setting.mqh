#include "us100-session-levels-marker.mqh"

bool isExpectingBull;

bool runBulkSetting(){
    // Get the current server time
    datetime currentTime = TimeCurrent();

    // Extract current day, hour, and minute
    int currentDay = TimeDay(currentTime);
    int currentHour = TimeHour(currentTime);
    int currentMinute = TimeMinute(currentTime);

    if(currentDay == 1 && currentHour <= 17){
        Print("Today is: ", currentDay);
        // Trading time range hour is the actual release hour of an event.
        tradingTimeRangeHour = 17;
        newsReleaseMinute = 0;
        isExpectingBull = false;
        return true;
    } 

    if(currentDay == 5 && currentHour <= 17){
        Print("Today is: ", currentDay);
        // Trading time range hour is the actual release hour of an event.
        tradingTimeRangeHour = 17;
        newsReleaseMinute = 0;
        isExpectingBull = true;
        return true;
    }

    if(currentDay == 6 && currentHour <= 15){
        Print("Today is: ", currentDay);
        // Trading time range hour is the actual release hour of an event.
        tradingTimeRangeHour = 15;
        newsReleaseMinute = 15;
        isExpectingBull = false;
        return true;
    }

    // For multiple event on a day, do this...
    if(currentDay == 6 && currentHour > 15 && currentHour <= 17){
        Print("Today is: ", currentDay);
        // Trading time range hour is the actual release hour of an event.
        tradingTimeRangeHour = 17;
        newsReleaseMinute = 0;
        isExpectingBull = true;
        return true;
    }

    if(currentDay == 7 && currentHour <= 15){
        Print("Today is: ", currentDay);
        // Trading time range hour is the actual release hour of an event.
        tradingTimeRangeHour = 15;
        newsReleaseMinute = 30;
        isExpectingBull = true;
        return true;
    }
    
    if(currentDay == 8 && currentHour <= 15){
        Print("Today is: ", currentDay);
        // Trading time range hour is the actual release hour of an event.
        tradingTimeRangeHour = 15;
        newsReleaseMinute = 30;
        isExpectingBull = true;
        return true;
    }

    return false;
    
}