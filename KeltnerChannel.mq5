//+------------------------------------------------------------------+
//|                                              Keltner_Channel.mq5 |
//|                                                       Yuta Miura |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Yuta Miura"
#property link      ""
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots 3
#property indicator_label1  "Upper Band"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "Middle Band"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "Lower Band"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1


double upperBand[];
double middleBand[];
double lowerBand[];

input int length = 20;
input double mult = 2.0;
input bool useEMA = true;
input int atrLength = 10;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);


   IndicatorSetString(INDICATOR_SHORTNAME, "Keltner Channels");

   PlotIndexSetString(0, PLOT_LABEL, "Upper Band");
   PlotIndexSetString(1, PLOT_LABEL, "Middle Band");
   PlotIndexSetString(2, PLOT_LABEL, "Lower Band");

   PlotIndexSetInteger(0, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetInteger(1, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetInteger(2, PLOT_DRAW_TYPE, DRAW_LINE);

   SetIndexBuffer(0, upperBand, INDICATOR_DATA);
   SetIndexBuffer(1, middleBand, INDICATOR_DATA);
   SetIndexBuffer(2, lowerBand, INDICATOR_DATA);

   ArraySetAsSeries(upperBand, true);
   ArraySetAsSeries(middleBand, true);
   ArraySetAsSeries(lowerBand, true);

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[]) {

   int maHandle = iMA(NULL, 0, length, 0, useEMA ? MODE_EMA : MODE_SMA, PRICE_CLOSE);
   if (maHandle == INVALID_HANDLE) {
      Print("Error getting MA handle: ", GetLastError());
      return(0);  // Exit the function on error
   }
   CopyBuffer(maHandle, 0, 0, rates_total, middleBand);

   double rangeValues[];
   ArraySetAsSeries(rangeValues, true);
   ArrayResize(rangeValues, rates_total);


   int atrHandle = iATR(NULL, 0, atrLength);
   if(atrHandle == INVALID_HANDLE) {
      Print("Error getting ATR handle: ", GetLastError());
      return(0);
   }
   CopyBuffer(atrHandle, 0, 0, rates_total, rangeValues);



   for(int i = 0; i < rates_total; i++) {
      upperBand[i] = middleBand[i] + mult * rangeValues[i];
      lowerBand[i] = middleBand[i] - mult * rangeValues[i];
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(rates_total);
}

//+------------------------------------------------------------------+
