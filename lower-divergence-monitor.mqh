//Declare the Variables
int lower_divergenceMonitorTimeFrame; //60 minutes
int lower_initialArray = 100;
int lower_initialRsiPeaksArray = 1;
int lower_startingRsiIndex = 0;
double lower_lastHighestRsi = 50;  //this is the initial highest Rsi
double lower_lastLowestRsi = 50;    //this is the initial lowest Rsi
double lower_rsiArray[];
double lower_bullishRsiArray[];
double lower_bearishRsiArray[];
double lower_newRsiPeak;
double lower_newRsiLow; 
double lower_bullRsiPeaks [];
double lower_bearRsiPeaks [];
double lower_thirdRsi;
double lower_lastRsi;
double lower_newRsi;
double lower_indexValueRsi;
//Price vars
double lower_indexValuePrice;
double lower_priceArray [];
int lower_initialPricePeaksArray = 1;
int lower_startingPriceIndex = 0;
double lower_lastHighestPrice = 0;
double lower_lastLowestPrice = 9999999;
double lower_bullishPriceArray[];
double lower_bearishPriceArray[];
double lower_newPricePeak;
double lower_newPriceLow; 
double lower_bullPricePeaks [];
double lower_bearPricePeaks [];
double lower_thirdPrice;
double lower_lastPrice;
double lower_newPrice;

bool isLowerDivergence = false;
//This is the price and rsi scanner wrapped in a function
void runLowerDivergenceMonitor(){
    for (int i=0; i<100;i++){
      //This is to push lower_rsiArray
      lower_indexValueRsi = iRSI(Symbol(),lower_divergenceMonitorTimeFrame,14,PRICE_CLOSE,(i+1));
         ArrayResize(lower_rsiArray,lower_initialArray);
         ArrayFill(lower_rsiArray,i,1,lower_indexValueRsi);
      //This is to push priceArray
      lower_indexValuePrice = iClose(Symbol(), lower_divergenceMonitorTimeFrame, (i+1));
         ArrayResize(lower_priceArray,lower_initialArray);
         ArrayFill(lower_priceArray,i,1,lower_indexValuePrice);
               
   }

   for (int j=100; j>=0; j--){
      //for RSI
      lower_thirdRsi = lower_rsiArray[j+2];
      lower_lastRsi = lower_rsiArray[j+1];
      lower_newRsi = lower_rsiArray[j];
      //for PRICE
      lower_thirdPrice = lower_priceArray[j+2];
      lower_lastPrice = lower_priceArray[j+1];
      lower_newPrice = lower_priceArray[j];

      bool isLowerBullish = false;
      bool isLowerBearish = false;
      

      if(lower_newRsi >= 50){               
         isLowerBearish = false;
         isLowerBullish = true;
         if(lower_lastRsi < 50){
            isLowerDivergence = false;
         }         
         //Impliment a function that deletes previous bearishArray's...
         resetlower_BearishPriceArray();
         resetlower_BearishRsiArray();                           
         //Impliment a function that pushes an lower_bullishRsiArray...
         addlower_BullishRsiArray();
         //function that pushes a lower_bullishPriceArray...
         addlower_BullishPriceArray();  
      }

      if (isLowerBullish){
         //This the condition for lower_newRsiPeaks...
         if(lower_lastRsi > lower_thirdRsi && lower_newRsi < lower_lastRsi && isLowerDivergence == 0){
            lower_newRsiPeak = lower_lastRsi;
            lower_newPricePeak = lower_lastPrice;
         //Impliment a function that pushes lower_bullRsiPeaks...            
            addlower_BullRsiPeaks();
         //Impliment a function that pushes lower_bullPricePeaks...
            addlower_BullPricePeaks();
         //Impliment a function that checks if it's a new high...
            // IsLowerNewRsiHigh();
            // IsLowerNewPriceHigh();
             if (IsLowerNewRsiHigh() != IsLowerNewPriceHigh()){
                isLowerDivergence = true;

             } 
            // if there is a divergence, the code need to wait for it to reset before it allows to place an order
            // one of the conditions to place an order is if(!divergence) 
         }
         
      }
      
      if (lower_newRsi < 50) {
         isLowerBullish =false;
         isLowerBearish = true;
         if(lower_lastRsi >= 50){
            isLowerDivergence = false;
         }    
         //Impliment a function that deletes previous bullishArray's...
         resetlower_BullishRsiArray();
         resetlower_BullishPriceArray();
         //Impliment a function that pushes an bearishArray...
         addlower_BearishRsiArray();
         //function that pushes a lower_bearishPriceArray...
         addlower_BearishPriceArray();
      }
      
      if (isLowerBearish){
         ////This the condition for lower_newRsiLows...
         if(lower_lastRsi<lower_thirdRsi && lower_newRsi > lower_lastRsi && isLowerDivergence == 0){
            lower_newRsiLow = lower_lastRsi;
            lower_newPriceLow = lower_lastPrice;
         //Impliment a function that pushes lower_bearRsiPeaks...
            addlower_BearRsiPeaks();
         //Impliment a function that pushes lower_bearPricePeaks...
            addlower_BearPricePeaks();
         //Impliment a function that checks if it's a new low...
            // islower_NewRsiLow();
            // islower_NewPriceLow();
             if(islower_NewRsiLow() != islower_NewPriceLow()){
                isLowerDivergence = true;
             }

         }
      }      
   }
}
//CUSTOM FUNCTIONS

bool IsLowerNewPriceHigh(){
   if(lower_bullPricePeaks[lower_startingPriceIndex] > lower_lastHighestPrice){
      lower_lastHighestPrice = lower_bullPricePeaks [lower_startingPriceIndex];
      //Print("This is the last highest PRICE:", lower_lastHighestPrice);
      return true;
   } else {
      //Print(lower_bullPricePeaks[lower_startingPriceIndex], "- is not a new PRICE high");
      return false;
   }
}

bool IsLowerNewRsiHigh(){
   if(lower_bullRsiPeaks[lower_startingRsiIndex] > lower_lastHighestRsi){
      lower_lastHighestRsi = lower_bullRsiPeaks[lower_startingRsiIndex];
      //Print("This is the last highest RSI:", lower_lastHighestRsi);
      return true;      
   } else {
      //Print(lower_bullRsiPeaks[lower_startingRsiIndex], "- is not a new RSI high...");
      return false;
   }
}

bool islower_NewPriceLow(){
   if(lower_bearPricePeaks[lower_startingPriceIndex] < lower_lastLowestPrice){
      lower_lastLowestPrice = lower_bearPricePeaks[lower_startingPriceIndex];
      //Print("This is the last lowest PRICE:", lower_lastLowestPrice);
      return true;
   } else {
      //Print(lower_bearPricePeaks[lower_startingPriceIndex], "- is not a new PRICE Low");
      return false;
   }
}

bool islower_NewRsiLow(){
   if(lower_bearRsiPeaks[lower_startingRsiIndex] < lower_lastLowestRsi){
      lower_lastLowestRsi = lower_bearRsiPeaks[lower_startingRsiIndex];
      //Print("This is the last lowest RSI", lower_lastLowestRsi);
      return true;
   } else {
      //Print(lower_bearRsiPeaks[lower_startingRsiIndex], "- is not a new RSI low");
      return false;
   }
}

void addlower_BullPricePeaks(){
   ArrayResize(lower_bullPricePeaks, lower_initialPricePeaksArray);
   ArrayFill(lower_bullPricePeaks, lower_startingPriceIndex, 1, lower_newPricePeak);
   lower_initialPricePeaksArray = lower_initialPricePeaksArray++;
   lower_startingPriceIndex = lower_startingPriceIndex++;
}

void addlower_BullRsiPeaks(){

   ArrayResize(lower_bullRsiPeaks,lower_initialRsiPeaksArray);
   ArrayFill(lower_bullRsiPeaks,lower_startingRsiIndex,1,lower_newRsiPeak);
   //Print("lower_bullRsiPeaks are" , lower_bullRsiPeaks[lower_startingRsiIndex]); 
   lower_initialRsiPeaksArray = lower_initialRsiPeaksArray++;
   lower_startingRsiIndex = lower_startingRsiIndex++;
}

void addlower_BearPricePeaks(){
   ArrayResize(lower_bearPricePeaks, lower_initialPricePeaksArray);
   ArrayFill(lower_bearPricePeaks, lower_startingPriceIndex, 1, lower_newPriceLow);
   lower_initialPricePeaksArray = lower_initialPricePeaksArray++;
   lower_startingPriceIndex = lower_startingPriceIndex++;
}

void addlower_BearRsiPeaks(){
   ArrayResize(lower_bearRsiPeaks, lower_initialArray);
   ArrayFill(lower_bearRsiPeaks, lower_startingRsiIndex, 1, lower_newRsiLow);
   //Print("lower_bearRsiPeaks are" , lower_bearRsiPeaks[lower_startingRsiIndex]);
   lower_initialRsiPeaksArray = lower_initialRsiPeaksArray++;
   lower_startingRsiIndex = lower_startingRsiIndex++;
}

void addlower_BullishPriceArray(){
   for (int i=0; i<100 ; i++){
      lower_indexValuePrice = lower_newPrice;
      ArrayResize(lower_bullishPriceArray, lower_initialArray);
      ArrayFill(lower_bullishPriceArray, i, 1,lower_indexValuePrice);
   }
}

void addlower_BullishRsiArray(){
   for (int i=0; i<100 ;i++){
      lower_indexValueRsi = lower_newRsi;
      ArrayResize(lower_bullishRsiArray,lower_initialArray);
      ArrayFill(lower_bullishRsiArray,i,1,lower_indexValueRsi);
   }
}

void addlower_BearishPriceArray(){
   for (int i=0; i<100 ; i++){
      lower_indexValuePrice = lower_newPrice;
      ArrayResize(lower_bearishPriceArray, lower_initialArray);
      ArrayFill(lower_bearishPriceArray, i, 1,lower_indexValuePrice);
   }
}

void addlower_BearishRsiArray(){
   for (int i=0; i<100 ;i++){
      lower_indexValueRsi = lower_newRsi;
      ArrayResize(lower_bearishRsiArray, lower_initialArray);
      ArrayFill(lower_bearishRsiArray,i,1,lower_indexValueRsi);
   }
}

void resetlower_BullishPriceArray(){
   ArrayFree(lower_bullishPriceArray);
   lower_lastHighestPrice = 0;
   lower_startingPriceIndex = 0;
   lower_initialPricePeaksArray = 1;
}

void resetlower_BullishRsiArray (){
   ArrayFree(lower_bullishRsiArray);
   lower_lastHighestRsi = 50;
   lower_startingRsiIndex = 0;
   lower_initialRsiPeaksArray = 1;
}
  
void resetlower_BearishPriceArray(){
   ArrayFree(lower_bearishPriceArray);
   lower_lastLowestPrice = 9999999;
   lower_startingPriceIndex = 0;
   lower_initialPricePeaksArray = 1;
}

void resetlower_BearishRsiArray () {
      ArrayFree(lower_bearishRsiArray);
      lower_lastLowestRsi = 50;
      lower_startingRsiIndex = 0;
      lower_initialRsiPeaksArray = 1;
   }