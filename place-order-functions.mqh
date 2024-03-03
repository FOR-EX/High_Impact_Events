#include "us100-session-levels-marker.mqh"
#include "SMCMonitor.mqh"
#include "divergence-monitor.mqh"
#include "lower-divergence-monitor.mqh"

int ticket_buy = 0;
int ticket_sell = 0;
int lastDeletedOrder;

double riskedAmount;
int placeOrderTimeframe;
double takeProfitMultiplier;

//bullOrderVariables
double bullStopLoss;
double bullTakeProfit;
double bullLotSize;
double buyEntryPrice;
double bullTimesOne;

//bearOrderVariables
double bearStopLoss;
double bearTakeProfit;
double bearLotSize;
double sellEntryPrice;
double BearTimesOne;

//vars for fibo...
double Level100;
double Level0;
double Level50;
double Level61_8;
double Level161_8;
double NegativeLevel2; //x2 if the  sl is 161.8 from fibo
double NegativeLevel1_39; //x1.39 if the  sl is 161.8 from fibo

bool breakEvenSwitch;


void placeBullishOrder(){

    double currentNumberofOrder = OrdersTotal();
    double currentSpreadValue =  Ask-Bid;
    double stopLossinPips;
    double riskPerPips;
    double contractSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);

    if((contractSize == 100000) || (contractSize==1)){

        contractSize = 100;

    }

    if (!currentNumberofOrder){

        createBullishFibo();

        bullStopLoss = Level161_8 - currentSpreadValue;
        buyEntryPrice = Level100;
        stopLossinPips = (buyEntryPrice - bullStopLoss)*1;
        bullTakeProfit = stopLossinPips/1 * takeProfitMultiplier + buyEntryPrice;
        bullTimesOne = stopLossinPips/100 * 1 + buyEntryPrice;
        riskPerPips = riskedAmount/stopLossinPips;
        bullLotSize = (riskPerPips*buyEntryPrice)/contractSize; //1 if us100 2if usdjpy
        Print("riskPerPips:", riskPerPips);
        Print ("bullLotSize is:", bullLotSize);
        Print("bullTakeProfit:", bullTakeProfit);
        Print("bullStopLoss:",bullStopLoss);
        Print("stopLossinPips:",stopLossinPips);
        Print("currentSpreadValue:",currentSpreadValue);
        Print("Allowed stop level is:", MarketInfo(Symbol(),MODE_STOPLEVEL));
        Print("Minimum Lot Allowed:", MarketInfo(Symbol(),MODE_MINLOT));
        Print("startingCandle is:",startingCandle);
        Print("startTime is:",startTime);

        ticket_buy = OrderSend(Symbol(),OP_BUYLIMIT,bullLotSize,buyEntryPrice,3,bullStopLoss,bullTakeProfit,NULL,0,0,clrAquamarine);
        count = 0;
        updateLastHigh();
        isBullishSMC = false;
        isBullishSMCHere = false;
        startingCandle = 0;
        ObjectDelete(0,"FibonacciRetracement");

    }

}

void createBullishFibo(){

    double startPoint = startingCandle ; // You can modify this based on your preference
    double endPoint = lastCandleClose ; // You can modify this based on your preference

    ObjectCreate(0, "FibonacciRetracement", OBJ_FIBO, 0, Time[startTime], startPoint, Time[endTime], endPoint);

    //get the level values
    Level100 = ObjectGetDouble(0,"FibonacciRetracement", OBJPROP_PRICE, 0);
    Level0 = ObjectGetDouble(0,"FibonacciRetracement", OBJPROP_PRICE, 1);
    Level50=((Level0+Level100)/2);
    Level61_8 = Level0 + (0.618 * (Level100 - Level0));
    Level161_8 = Level0 + (1.618 * (Level100 - Level0));
    NegativeLevel2 = Level0 - (2.0 * (Level161_8 - Level0)); //x2 if the  sl is 161.8 from fibo
    NegativeLevel1_39 = Level0 - (1.39 * (Level161_8 - Level0)); //x1.39 if the  sl is 161.8 from fibo

    Print("Level 0:", Level0 + "\n",
    "Level 50:", Level50 + "\n",
    "Level 61.8:", Level61_8 + "\n",
    "Level 100:", Level100 + "\n",
    "Level 161.8:", Level161_8 + "\n",
    "NegativeLevel2:", NegativeLevel2 + "\n",
    "NegativeLevel1_39:",NegativeLevel1_39);

}

void placeBearishOrder(){
    
    int currentNumberofOrder = OrdersTotal();
    
    double currentSpreadValue =  Ask-Bid;
    double stopLossinPips;
    double riskPerPips;
    double contractSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);

    if((contractSize == 100000) || (contractSize==1)){
        contractSize = 100;
    }

    if (!currentNumberofOrder){
        
        createBearishFibo();

        bearStopLoss = Level161_8 + currentSpreadValue;
        sellEntryPrice = Level100;
        stopLossinPips = (bearStopLoss - sellEntryPrice)*1;
        bearTakeProfit = (sellEntryPrice - ((stopLossinPips/1) * takeProfitMultiplier));
        BearTimesOne = (sellEntryPrice - ((stopLossinPips/100) * 1));
        riskPerPips = riskedAmount/stopLossinPips;
        bearLotSize =  (riskPerPips*sellEntryPrice)/contractSize;//1 if us100 2if usdjpy
        Print("riskPerPips:", riskPerPips);
        Print ("bearLotSize is:", bearLotSize);
        Print("bearTakeProfit:", bearTakeProfit);
        Print("bearStopLoss:",bearStopLoss);
        Print("stopLossinPips:",stopLossinPips);
        Print("sellEntryPrice:", sellEntryPrice);
        Print("currentSpreadValue:",currentSpreadValue);
        Print("Allowed stop level is:", MarketInfo(Symbol(),MODE_STOPLEVEL));
        Print("Minimum Lot Allowed:", MarketInfo(Symbol(),MODE_MINLOT));
        Print("About lot size:", MarketInfo(Symbol(),MODE_LOTSIZE));
        Print("bearLotSize", bearLotSize);
        ticket_sell = OrderSend(Symbol(),OP_SELLLIMIT,bearLotSize,sellEntryPrice,3,bearStopLoss,bearTakeProfit,NULL,0,0,clrAquamarine);
        count = 0;
        // updateLastLow();
        isBearishSMC = false;
        isBearishSMCHere = false;
        startingCandle = 0;
        ObjectDelete(0,"FibonacciRetracement");
    }
    
}

//manage existing pending order...
void managePendingOrder(){

    double currentNumberofOrder = OrdersTotal();

    //
    // if (currentNumberofOrder && (Bid > sessionResistance)){
    //     if(newCandle >= bullTimesOne || isDivergence || isLowerDivergence || newCandle > lastHighestPeakValue){
    //         //delete the pending order...
    //         lastDeletedOrder = OrderDelete(ticket_buy, clrCornsilk);
    //         count = 0;
    //     }
    // }

    // //
    // if (currentNumberofOrder && (Bid < sessionSupport)){
    //     if(newCandle <= BearTimesOne || isDivergence || isLowerDivergence || newCandle < lastLowestLowValue){
    //         //delete the pending order...
    //         lastDeletedOrder = OrderDelete(ticket_sell, clrCornsilk);
    //         count = 0;
    //     }
    // }
    
    if(breakEvenSwitch){
        //function to set BE for Buy orders
        if (currentNumberofOrder && (Bid > sessionResistance)){
            if(newCandle >= bullTimesOne){
                int bull_order_type;
                if(OrderSelect(ticket_buy, SELECT_BY_POS)==true){
                    bull_order_type=OrderType();
                }
                if (bull_order_type == 0){
                    OrderModify(ticket_buy,buyEntryPrice, buyEntryPrice, bullTakeProfit, 0, clrAquamarine);
                }
            }
        }
    }

    if(breakEvenSwitch){
        //function to set BE for Sell orders
        if (currentNumberofOrder && (Bid < sessionSupport)){
            if(newCandle <= BearTimesOne){
                int bear_order_type;
                if(OrderSelect(ticket_sell, SELECT_BY_POS)==true){
                    bear_order_type = OrderType();
                }
                if (bear_order_type == 1){
                    OrderModify(ticket_sell,sellEntryPrice, sellEntryPrice, bearTakeProfit, 0, clrAquamarine);
                }
            }
        }
    }

}


void createBearishFibo(){

    double startPoint = startingCandle; // You can modify this based on your preference
    double endPoint = lastCandleClose; // You can modify this based on your preference

    ObjectCreate(0, "FibonacciRetracement", OBJ_FIBO, 0, Time[startTime], startPoint, Time[endTime], endPoint);

    //get the level values
    Level100 = ObjectGetDouble(0,"FibonacciRetracement", OBJPROP_PRICE, 0);
    Level0 = ObjectGetDouble(0,"FibonacciRetracement", OBJPROP_PRICE, 1);
    Level50=((Level0+Level100)/2);
    Level61_8 = Level0 + (0.618 * (Level100 - Level0));
    Level161_8 = Level0 + (1.618 * (Level100 - Level0));
    NegativeLevel2 = Level0 - (2.0 * (Level161_8 - Level0)); //x2 if the  sl is 161.8 from fibo
    NegativeLevel1_39 = Level0 - (1.39 * (Level161_8 - Level0)); //x1.39 if the  sl is 161.8 from fibo

    Print("Level 0:", Level0 + "\n",
    "Level 50:", Level50 + "\n",
    "Level 61.8:", Level61_8 + "\n",
    "Level 100:", Level100 + "\n",
    "Level61_8", Level61_8 + "\n",
    "Level 161.8:", Level161_8 + "\n",
    "NegativeLevel2:", NegativeLevel2 + "\n",
    "NegativeLevel1_39:",NegativeLevel1_39);

}

void deleteFibo(){

    double currentNumberofOrder = OrdersTotal();

    if(!currentNumberofOrder){
        ObjectDelete(0,"FibonacciRetracement");
    }

}

//This is a lotsize calculator
   // double stOpinPips = span*100;
   // double riskPerpips = (riskInUsd/stOpinPips);
   // double lOtz = riskInUsd/stOpinPips*Ask/normalLot;