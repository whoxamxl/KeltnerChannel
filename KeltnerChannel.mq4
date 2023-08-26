//+------------------------------------------------------------------+
//|                                              Keltner_Channel.mq4 |
//|                                                       Yuta Miura |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Yuta Miura"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Blue
#property indicator_color2 Blue
#property indicator_color3 Blue

double upperBand[];
double middleBand[];
double lowerBand[];

input int length = 20;
input double mult = 2.0;
input bool useEMA = true;
input int atrLength = 10;

int OnInit() {
    IndicatorBuffers(3);
    IndicatorShortName("Keltner Channels");
    SetIndexLabel(0, "Upper Band");
    SetIndexLabel(1, "Middle Band");
    SetIndexLabel(2, "Lower Band");
    
    SetIndexStyle(0, DRAW_LINE);
    SetIndexStyle(1, DRAW_LINE);
    SetIndexStyle(2, DRAW_LINE);
    
    SetIndexBuffer(0, upperBand);
    SetIndexBuffer(1, middleBand);
    SetIndexBuffer(2, lowerBand);
    return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[]) {
    for(int i = 0; i < rates_total; i++) {
        if(useEMA)
            middleBand[i] = iMA(NULL, 0, length, 0, MODE_EMA, PRICE_CLOSE, i);
        else
            middleBand[i] = iMA(NULL, 0, length, 0, MODE_SMA, PRICE_CLOSE, i);
        
        double atr = iATR(NULL, 0, atrLength, i);
        upperBand[i] = middleBand[i] + mult * atr;
        lowerBand[i] = middleBand[i] - mult * atr;
    }
    
    return(rates_total);
}
