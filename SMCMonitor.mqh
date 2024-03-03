#include "us100-session-levels-marker.mqh"
#include "after-break-levels.mqh"

bool isBullishSMCHere = false;
bool isBearishSMCHere = false;
int smcTimeFrame;
double startingCandle; //this will be used as the startpoint of fiboObj
double lastCandleClose;//this will be used as the endpoint of fiboObj
int startTime = 4;
int endTime = 1;
double newCandle;
double secondCandle;
double thirdCandle;
double fourthCandle;
double fifthCandle;

bool isBullishSMC = false;
bool isBearishSMC = false;

void runSMCMonitor(){
    

    newCandle = iClose(Symbol(),smcTimeFrame,1);
    secondCandle = iClose(Symbol(),smcTimeFrame,2);
    thirdCandle = iClose(Symbol(),smcTimeFrame,3);
    fourthCandle = iClose(Symbol(),smcTimeFrame,4);
    fifthCandle = iClose(Symbol(),smcTimeFrame,5);

    runBullishSMC();
    runBearishSMC();
    
    if(isBullishSMC){
        if(lastCandleClose > lastHighestPeakValue){
            isBullishSMCHere = true;
        } else {
            isBullishSMCHere = false;
        }
    }

    if(isBearishSMC){
        if(lastCandleClose < lastLowestLowValue){
            isBearishSMCHere = true;
        } else {
            isBearishSMCHere = false;
        }
    }
}

int count = 0;
void runBullishSMC(){
    //get the  lastCandleClose & startingCandle
    if (newCandle > secondCandle && secondCandle > thirdCandle && thirdCandle > fourthCandle){
        lastCandleClose = newCandle;
        startingCandle = iOpen(Symbol(),smcTimeFrame,(3 + count));
        startTime = 3 + count;
        count++;
        isBullishSMC = false;
    }

    // reset count condition
    if (newCandle < secondCandle && secondCandle > thirdCandle && thirdCandle > fourthCandle && fourthCandle > fifthCandle && OrdersTotal()==0){
        isBullishSMC = true;
        count = 0;
        if(newCandle > lastHighestPeakValue){
        }
    }
}


void runBearishSMC(){
    //get the  lastCandleClose & startingCandle
    if (newCandle < secondCandle && secondCandle < thirdCandle && thirdCandle < fourthCandle){
        lastCandleClose = newCandle;
        startingCandle = iOpen(Symbol(),smcTimeFrame,(3 + count));
        startTime = 3 + count;
        count++;
        isBearishSMC = false;
    }

    // reset count condition
    if (newCandle > secondCandle && secondCandle < thirdCandle && thirdCandle < fourthCandle && fourthCandle < fifthCandle && OrdersTotal()==0){
        isBearishSMC = true;
        count = 0;
        if(newCandle < lastLowestLowValue){
        }
    }
}