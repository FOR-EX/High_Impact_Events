#include "divergence-monitor.mqh"
#include "us100-session-levels-marker.mqh"
#include "place-order-functions.mqh"
#include "lower-divergence-monitor.mqh"
#include "SMCMonitor.mqh"
#include "after-break-levels.mqh"
#include "bulk-setting.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
    {
    //---
   
    //---
    return(INIT_SUCCEEDED);
    }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+  
void OnDeinit(const int reason)
    {
    //---
   
    }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
    {
    //---
    // Day-light-saving-time-days means you will trade an hour earlier than days that are not in day light saving time.
   
    riskedAmount = 5; //risked money in USD
    takeProfitMultiplier = 3.1; //
    smcTimeFrame = 1; //Update the timeframe from engulferTimeFrame
    placeOrderTimeframe = smcTimeFrame;
    divergenceMonitorTimeFrame = 1; //Update the timeframe from divergenceMonitor
    lower_divergenceMonitorTimeFrame = smcTimeFrame;
    afterBreakLevelsTimeframe = smcTimeFrame;
    sessionLevelTimeFrame = 1; //Update the timeframe from sessionLevelMarker 
    tradingTimeRangeHour = 15;
    newsReleaseMinute = 15;


    breakEvenSwitch = false;

    double lastMinute = currentMinute;

    //manage existing pending order...
    managePendingOrder();

    // update the date&time vars on each tick...
    runningTime();

    //This is to make codes reiterate only once per minute - making the code efficient.
    if (currentMinute != lastMinute){
        
        // run or initialize the bulksetting
        if(runBulkSetting()){
            //run this to see if it is tradingtime....
            checkTradingTime();
        }
        
        Comment("currentMinute", currentMinute + "currentHour: ", currentHour);

        //establish the last highest peak and last lowest low...
        establishLastHighestPeak();
        establishLastLastLowestLow();
        //Condition to place a bullish order
        if(isTradingTime){

            runSMCMonitor();

            string commentText = "isBullishSMCHere: " + isBullishSMCHere + " | isBearishSMCHere: " + isBearishSMCHere;
            Comment(commentText);
            Print(commentText);
            Print("isExpectingBull is: ", isExpectingBull);
            if(isExpectingBull){
                //this is the condition for placing order during bullish conditions
                if (isBullishSMCHere){
                    placeBullishOrder();
                    Print("Bullish Order Placed");
                    } 
                // -------------------------------------------------------------------//
            }else{
                //this is the condition for placing order during bearish conditions
                if(isBearishSMCHere){
                    placeBearishOrder();
                    Print("Bearish Order Placed");
                }
            }
        }

        lastMinute = currentMinute;
        deleteFibo();
    }
    }
//+------------------------------------------------------------------+
