    int sessionLevelTimeFrame;
//  On Start
    int currentHour = TimeHour(TimeCurrent());
    int currentMinute = TimeMinute(TimeCurrent());
    int currentDay = TimeDay(TimeCurrent());
    int resistanceLevelCreationTime = currentDay;
    int supportLevelCreationTime = currentDay;

    bool isTradingTime = false;

    int tradingTimeRangeHour;
    int newsReleaseMinute;
// custom functions variables
    double sessionResistanceArray [];
    double sessionSupportArray [];
    double sessionResistance = 0;
    double sessionSupport = 999999;

    int namE;
    int SessionSupportlabelCreated = 0;
    int SessionRessistancelabelCreated = 0;
    

// Custom functions

void runningTime(){
    currentHour = TimeHour(TimeCurrent());
    currentMinute = TimeMinute(TimeCurrent());
    currentDay = TimeDay(TimeCurrent());
}

void findSessionResistance(){

   //This is the level reset condition
   if (resistanceLevelCreationTime != currentDay){
      ArrayFree(sessionResistanceArray);
      resistanceLevelCreationTime = currentDay;
      sessionResistance = 0;
   }

   if (currentHour == 14 && currentMinute == 0){
      int index;
      for (int i = 1 ; i <= 300; i++){
         double indexValue = iHigh(Symbol(),sessionLevelTimeFrame,i);
         //Print("indexValue is", indexValue);
         if(indexValue > sessionResistance){
            sessionResistance = indexValue;
            //Print("sessionResistance is", sessionResistance);
            index = i;
         }
         ArrayResize(sessionResistanceArray,1);
         ArrayFill(sessionResistanceArray,0,1,sessionResistance);
         //Print("sessionResistanceArray is:",sessionResistanceArray[0]);
         resistanceLevelCreationTime = currentDay;
         namE = NormalizeDouble((sessionResistance*Bid),1);
         //Print(namE);
         string SessionRessistancelabelCreated = IntegerToString(namE,0);
      }
      ObjectCreate(0,SessionRessistancelabelCreated, OBJ_ARROW_RIGHT_PRICE, 0, Time[index], sessionResistance); 
   }
} 

void findSessionSupport(){

   //This is the level reset condition
   if (supportLevelCreationTime != currentDay){
      ArrayFree(sessionSupportArray);
      supportLevelCreationTime = currentDay;
      sessionSupport = 999999;
      
   }

   if (currentHour == 14 && currentMinute == 0){
      int index;
      for (int i = 1 ; i <= 300; i++){
         double indexValue = iLow(Symbol(),sessionLevelTimeFrame,i);
         //Print("indexValue is", indexValue);
         if(indexValue < sessionSupport){
            sessionSupport = indexValue;
            //Print("sessionSupport is", sessionSupport);
            index = i;
         }
         ArrayResize(sessionSupportArray,1);
         ArrayFill(sessionSupportArray,0,1,sessionSupport);
         //Print("sessionSupportArray is:",sessionSupportArray[0]);
         supportLevelCreationTime = currentDay;
         namE = NormalizeDouble((sessionSupport*Bid),1);
         //Print(namE);
         string SessionSupportlabelCreated = IntegerToString(namE,0);
       
      }
      ObjectCreate(0,SessionSupportlabelCreated, OBJ_ARROW_RIGHT_PRICE, 0, Time[index], sessionSupport);    
   }
} 

bool checkTradingTime(){
   int tradingMinute = newsReleaseMinute - 10;

   if(newsReleaseMinute == 0){

      tradingMinute = tradingMinute + 10;

      if(currentHour == (tradingTimeRangeHour-1) && currentMinute > 50){
         return isTradingTime = true;
      }
      if(currentHour == tradingTimeRangeHour && currentMinute == newsReleaseMinute){
         return isTradingTime = true;
      }
   }

   if (currentHour == tradingTimeRangeHour && newsReleaseMinute != 0){
      if (currentMinute < tradingMinute || (currentMinute > (newsReleaseMinute+1)) && newsReleaseMinute != 0){
         return isTradingTime = false;
      }

      return isTradingTime = true;
   } else {
      return isTradingTime = false;
   }
}