int smmaTimeFrame;
int smmaShift = 4;
double oneSmma = iMA(Symbol(), smmaTimeFrame,21, 0, MODE_SMMA, PRICE_CLOSE, smmaShift);
double twoSmma = iMA(Symbol(), smmaTimeFrame,50, 0, MODE_SMMA, PRICE_CLOSE, smmaShift); 
double threeSmma = iMA(Symbol(), smmaTimeFrame,200, 0, MODE_SMMA, PRICE_CLOSE, smmaShift);
bool isSmmaBear;
bool isSmmaBull;

void checkBullSmma(){
    if (oneSmma > twoSmma && twoSmma > threeSmma){
        isSmmaBull = true;
    } else {
        isSmmaBull = false;
    }
}

void checkBearSmma(){
    if (oneSmma < twoSmma && twoSmma < threeSmma){
        isSmmaBear = true;
    } else {
        isSmmaBear = false;
    }
}

void runSmmaMonitor(){
    checkBullSmma();
    checkBearSmma();
}