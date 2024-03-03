//Declare the Variables
int divergenceMonitorTimeFrame; //60 minutes
int initialArray = 100;
int initialRsiPeaksArray = 1;
int startingRsiIndex = 0;
double lastHighestRsi = 50;  //this is the initial highest Rsi
double lastLowestRsi = 50;    //this is the initial lowest Rsi
double rsiArray[];
double bullishRsiArray[];
double bearishRsiArray[];
double newRsiPeak;
double newRsiLow; 
double bullRsiPeaks [];
double bearRsiPeaks [];
double thirdRsi;
double lastRsi;
double newRsi;
double indexValueRsi;
//Price vars
double indexValuePrice;
double priceArray [];
int initialPricePeaksArray = 1;
int startingPriceIndex = 0;
double lastHighestPrice = 0;
double lastLowestPrice = 9999999;
double bullishPriceArray[];
double bearishPriceArray[];
double newPricePeak;
double newPriceLow; 
double bullPricePeaks [];
double bearPricePeaks [];
double thirdPrice;
double lastPrice;
double newPrice;

bool isDivergence = false;
//This is the price and rsi scanner wrapped in a function
void runDivergenceMonitor(){
    for (int i=0; i<100;i++){
      //This is to push rsiArray
      indexValueRsi = iRSI(Symbol(),divergenceMonitorTimeFrame,14,PRICE_CLOSE,(i+1));
         ArrayResize(rsiArray,initialArray);
         ArrayFill(rsiArray,i,1,indexValueRsi);
      //This is to push priceArray
      indexValuePrice = iClose(Symbol(), divergenceMonitorTimeFrame, (i+1));
         ArrayResize(priceArray,initialArray);
         ArrayFill(priceArray,i,1,indexValuePrice);
               
   }

   for (int j=100; j>=0; j--){
      //for RSI
      thirdRsi = rsiArray[j+2];
      lastRsi = rsiArray[j+1];
      newRsi = rsiArray[j];
      //for PRICE
      thirdPrice = priceArray[j+2];
      lastPrice = priceArray[j+1];
      newPrice = priceArray[j];

      bool isBullish = false;
      bool isBearish = false;
      

      if(newRsi >= 50){               
         isBearish = false;
         isBullish = true;
         if(lastRsi < 50){
            isDivergence = false;
         }         
         //Impliment a function that deletes previous bearishArray's...
         resetBearishPriceArray();
         resetBearishRsiArray();                           
         //Impliment a function that pushes an bullishRsiArray...
         addBullishRsiArray();
         //function that pushes a bullishPriceArray...
         addBullishPriceArray();  
      }

      if (isBullish){
         //This the condition for newRsiPeaks...
         if(lastRsi > thirdRsi && newRsi < lastRsi && isDivergence == 0){
            newRsiPeak = lastRsi;
            newPricePeak = lastPrice;
         //Impliment a function that pushes bullRsiPeaks...            
            addBullRsiPeaks();
         //Impliment a function that pushes bullPricePeaks...
            addBullPricePeaks();
         //Impliment a function that checks if it's a new high...
            // IsNewRsiHigh();
            // IsNewPriceHigh();
             if (IsNewRsiHigh() != IsNewPriceHigh()){
                isDivergence = true;

             } 
            // if there is a divergence, the code need to wait for it to reset before it allows to place an order
            // one of the conditions to place an order is if(!divergence) 
         }
         
      }
      
      if (newRsi < 50) {
         isBullish =false;
         isBearish = true;
         if(lastRsi >= 50){
            isDivergence = false;
         }    
         //Impliment a function that deletes previous bullishArray's...
         resetBullishRsiArray();
         resetBullishPriceArray();
         //Impliment a function that pushes an bearishArray...
         addBearishRsiArray();
         //function that pushes a bearishPriceArray...
         addBearishPriceArray();
      }
      
      if (isBearish){
         ////This the condition for newRsiLows...
         if(lastRsi<thirdRsi && newRsi > lastRsi && isDivergence == 0){
            newRsiLow = lastRsi;
            newPriceLow = lastPrice;
         //Impliment a function that pushes bearRsiPeaks...
            addBearRsiPeaks();
         //Impliment a function that pushes bearPricePeaks...
            addBearPricePeaks();
         //Impliment a function that checks if it's a new low...
            // isNewRsiLow();
            // isNewPriceLow();
             if(isNewRsiLow() != isNewPriceLow()){
                isDivergence = true;
             }

         }
      }      
   }
}
//CUSTOM FUNCTIONS

bool IsNewPriceHigh(){
   if(bullPricePeaks[startingPriceIndex] > lastHighestPrice){
      lastHighestPrice = bullPricePeaks [startingPriceIndex];
      //Print("This is the last highest PRICE:", lastHighestPrice);
      return true;
   } else {
      //Print(bullPricePeaks[startingPriceIndex], "- is not a new PRICE high");
      return false;
   }
}

bool IsNewRsiHigh(){
   if(bullRsiPeaks[startingRsiIndex] > lastHighestRsi){
      lastHighestRsi = bullRsiPeaks[startingRsiIndex];
      //Print("This is the last highest RSI:", lastHighestRsi);
      return true;      
   } else {
      //Print(bullRsiPeaks[startingRsiIndex], "- is not a new RSI high...");
      return false;
   }
}

bool isNewPriceLow(){
   if(bearPricePeaks[startingPriceIndex] < lastLowestPrice){
      lastLowestPrice = bearPricePeaks[startingPriceIndex];
      //Print("This is the last lowest PRICE:", lastLowestPrice);
      return true;
   } else {
      //Print(bearPricePeaks[startingPriceIndex], "- is not a new PRICE Low");
      return false;
   }
}

bool isNewRsiLow(){
   if(bearRsiPeaks[startingRsiIndex] < lastLowestRsi){
      lastLowestRsi = bearRsiPeaks[startingRsiIndex];
      //Print("This is the last lowest RSI", lastLowestRsi);
      return true;
   } else {
      //Print(bearRsiPeaks[startingRsiIndex], "- is not a new RSI low");
      return false;
   }
}

void addBullPricePeaks(){
   ArrayResize(bullPricePeaks, initialPricePeaksArray);
   ArrayFill(bullPricePeaks, startingPriceIndex, 1, newPricePeak);
   initialPricePeaksArray = initialPricePeaksArray++;
   startingPriceIndex = startingPriceIndex++;
}

void addBullRsiPeaks(){

   ArrayResize(bullRsiPeaks,initialRsiPeaksArray);
   ArrayFill(bullRsiPeaks,startingRsiIndex,1,newRsiPeak);
   //Print("bullRsiPeaks are" , bullRsiPeaks[startingRsiIndex]); 
   initialRsiPeaksArray = initialRsiPeaksArray++;
   startingRsiIndex = startingRsiIndex++;
}

void addBearPricePeaks(){
   ArrayResize(bearPricePeaks, initialPricePeaksArray);
   ArrayFill(bearPricePeaks, startingPriceIndex, 1, newPriceLow);
   initialPricePeaksArray = initialPricePeaksArray++;
   startingPriceIndex = startingPriceIndex++;
}

void addBearRsiPeaks(){
   ArrayResize(bearRsiPeaks, initialArray);
   ArrayFill(bearRsiPeaks, startingRsiIndex, 1, newRsiLow);
   //Print("bearRsiPeaks are" , bearRsiPeaks[startingRsiIndex]);
   initialRsiPeaksArray = initialRsiPeaksArray++;
   startingRsiIndex = startingRsiIndex++;
}

void addBullishPriceArray(){
   for (int i=0; i<100 ; i++){
      indexValuePrice = newPrice;
      ArrayResize(bullishPriceArray, initialArray);
      ArrayFill(bullishPriceArray, i, 1,indexValuePrice);
   }
}

void addBullishRsiArray(){
   for (int i=0; i<100 ;i++){
      indexValueRsi = newRsi;
      ArrayResize(bullishRsiArray,initialArray);
      ArrayFill(bullishRsiArray,i,1,indexValueRsi);
   }
}

void addBearishPriceArray(){
   for (int i=0; i<100 ; i++){
      indexValuePrice = newPrice;
      ArrayResize(bearishPriceArray, initialArray);
      ArrayFill(bearishPriceArray, i, 1,indexValuePrice);
   }
}

void addBearishRsiArray(){
   for (int i=0; i<100 ;i++){
      indexValueRsi = newRsi;
      ArrayResize(bearishRsiArray, initialArray);
      ArrayFill(bearishRsiArray,i,1,indexValueRsi);
   }
}

void resetBullishPriceArray(){
   ArrayFree(bullishPriceArray);
   lastHighestPrice = 0;
   startingPriceIndex = 0;
   initialPricePeaksArray = 1;
}

void resetBullishRsiArray (){
   ArrayFree(bullishRsiArray);
   lastHighestRsi = 50;
   startingRsiIndex = 0;
   initialRsiPeaksArray = 1;
}
  
void resetBearishPriceArray(){
   ArrayFree(bearishPriceArray);
   lastLowestPrice = 9999999;
   startingPriceIndex = 0;
   initialPricePeaksArray = 1;
}

void resetBearishRsiArray () {
      ArrayFree(bearishRsiArray);
      lastLowestRsi = 50;
      startingRsiIndex = 0;
      initialRsiPeaksArray = 1;
   }