int engulferTimeFrame;
double bullishEngulfingBase;
double bearishEngulfingHead;

bool isLastandNewBull(){
   if(isLastCandleBull() && isNewCandleBull()){
      return true;
   } else {
      return false;
   }
}

bool isLastandNewBear(){
   if(isLastCandleBear() && isNewCandleBear()){
      return true;
   } else {
      return false;
   }
}
//bearish-engulfing-detector
bool isBearishEngulfing (){
   if (isLastCandleBull() && isNewCandleBear() && isNewCandleBearishEngulfer()){
      bearishEngulfingHead = iClose(Symbol(),engulferTimeFrame,2);
      return true;
   } else {
      return false;
   }
}

bool isNewCandleBearishEngulfer(){
   double lastOpeningCandle = iOpen(Symbol(), engulferTimeFrame,2);
   double newClosingCandle = iClose(Symbol(),engulferTimeFrame,1);

   if(newClosingCandle < lastOpeningCandle){
      return true;
   } else {
      return false;
   }
}



bool isLastCandleBull(){
   double lastOpeningCandle = iOpen(Symbol(), engulferTimeFrame,2);
   double lastClosingCandle = iClose(Symbol(),engulferTimeFrame,2);
   
   if (lastClosingCandle > lastOpeningCandle){
      return true;
   } else {
      return false;
   }
}

bool isNewCandleBear(){
   double newOpeningCandle = iOpen(Symbol(), engulferTimeFrame,1);
   double newClosingCandle = iClose(Symbol(),engulferTimeFrame,1);
   if(newClosingCandle < newOpeningCandle){
      return true;
   } else {
      return false;
   }
}

//bullish-engulfing-detector
bool isBullishEngulfing (){
   if (isLastCandleBear() && isNewCandleBull() && isNewCandleBullishEngulfer()){
      bullishEngulfingBase = iClose(Symbol(),engulferTimeFrame,2);
      return true;
   } else {
      return false;
   }
}

bool isNewCandleBullishEngulfer(){
   double lastOpeningCandle = iOpen(Symbol(), engulferTimeFrame,2);
   double newClosingCandle = iClose(Symbol(),engulferTimeFrame,1);

   if(newClosingCandle > lastOpeningCandle){
      return true;
   } else {
      return false;
   }
}

bool isLastCandleBear(){
   double lastOpeningCandle = iOpen(Symbol(), engulferTimeFrame,2);
   double lastClosingCandle = iClose(Symbol(),engulferTimeFrame,2);
   
   if (lastClosingCandle < lastOpeningCandle){
      return true;
   } else {
      return false;
   }
}

bool isNewCandleBull(){
   double newOpeningCandle = iOpen(Symbol(), engulferTimeFrame,1);
   double newClosingCandle = iClose(Symbol(),engulferTimeFrame,1);
   if(newClosingCandle > newOpeningCandle){
      return true;
   } else {
      return false;
   }
}