//+------------------------------------------------------------------+ 
//|                                   Copyright 2020, Trevor Schuil. |
//|                            https://www.mql5.com/en/users/trevone |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Trevor Schuil."
#property link      "https://www.mql5.com/en/users/trevone"
#property version   "3.02"
#property strict

#define _Total_Symbols_ 28
#define _Timer_Milliseconds_ 50
#define _Spread_Array_ 10 
#define _Min_ 60 
#include <mq4-http.mqh>

MqlNet INet;
 enum lotType {
   FIXED = 0,
   DYNAMIC = 1 
}; 
 extern int IvInvest=1;
 extern string WebHost="zimbo.link";
 extern int WebPort=443;
 string phrase = "";
 
 
 lotType LotType = DYNAMIC; // Lot Type
 string hostIp = "localhost"; // Socket [HOSTNAME/IP]  
 int hostPort = 8080; // Port [8080]
// OFFICIAL INPUTS
  string TradeComment = "MONKEYONE";
 int MagicNumber = 0;
 int Slippage = 10;
  double Lots = 0.01;
 double Divider = 150;   
 uint BasketTime = 540;
  uint ShortTime = 360;
 double BasketAmount = 0.007;
  int HistoryTrades = 17;
  double Multiplier = 5;
  double ProfitRatio = 1.65;
  double RSIDiff = 36;
string Symbols = "AUDCAD,AUDCHF,AUDJPY,CADCHF,CADJPY,CHFJPY,EURCAD,EURCHF,EURGBP,EURJPY,EURUSD,GBPCHF,GBPUSD,USDCAD,USDCHF,USDJPY"; // Reverse Pairs
//string Multipliers = "1.5,1.9,2.2,2.4,2.5,2.5,2.6,2.8,3.2,4"; 
  int MaxOpenSymbols = 7; // Open Pairs
  int MaxSignals = 5; // Max Signals
  int MaxTrades = 7; // Max Trades 
  bool USE_OPT = false; // USE BUILT IN SETTINGS
  bool USE_MAP = false; // USE MAPPING  
  double GapRatio = 0.35; // Gap Ratio  
  int MaxSpread = 13; // MaxSpread 
 int VelocitySamples = 26; // Tick Samples 
 int VelocitySignal = 11; // Entry Signal 
  int OrderDistance = 11; // Order Distance 
  int StopLoss = 175; // Stop Loss 
  int TrailingGap = 17; // Trailing Gap 
 int TrailingTarget = 43; // Trailing Target 
  int DeleteOrder = 25; // Delete Order 
  uint DeleteTime = 60; // Delete Time
 
  
  double largeLoss;
  int largeLossTicket;

int _SpreadMap0[_Total_Symbols_]; // 2
int _SpreadMap1[_Total_Symbols_]; // 2 

double _GapRatio[_Total_Symbols_]; // 3 
 
int _VelocitySamples0[_Total_Symbols_]; // 0
int _VelocitySamples1[_Total_Symbols_]; // 0 
double _VelocitySamplesCurve[_Total_Symbols_]; // 0 
double _VelocitySamplesType[_Total_Symbols_]; // 0 
 
int _VelocitySignal0[_Total_Symbols_]; // 6
int _VelocitySignal1[_Total_Symbols_]; // 6 
double _VelocitySignalCurve[_Total_Symbols_]; // 6
double _VelocitySignalType[_Total_Symbols_]; // 6
 
int _OrderDistance0[_Total_Symbols_]; // 8
int _OrderDistance1[_Total_Symbols_]; // 8 
double _OrderDistanceCurve[_Total_Symbols_]; // 8 
double _OrderDistanceType[_Total_Symbols_]; // 8
  
int _StopLoss0[_Total_Symbols_]; // 12
int _StopLoss1[_Total_Symbols_]; // 12 
double _StopLossCurve[_Total_Symbols_]; // 12 
double _StopLossType[_Total_Symbols_]; // 12 
 
int _TrailingGap0[_Total_Symbols_]; // 14
int _TrailingGap1[_Total_Symbols_]; // 14 
double _TrailingGapCurve[_Total_Symbols_]; // 14 
double _TrailingGapType[_Total_Symbols_]; // 14 
 
int _TrailingTarget0[_Total_Symbols_]; // 16
int _TrailingTarget1[_Total_Symbols_]; // 16 
double _TrailingTargetCurve[_Total_Symbols_]; // 16 
double _TrailingTargetType[_Total_Symbols_]; // 16 
  
int _DeleteOrder0[_Total_Symbols_]; // 18
int _DeleteOrder1[_Total_Symbols_]; // 18 
double _DeleteOrderCurve[_Total_Symbols_]; // 18 
double _DeleteOrderType[_Total_Symbols_]; // 18 
  
uint _DeleteTime0[_Total_Symbols_]; // 20
uint _DeleteTime1[_Total_Symbols_]; // 20 
double _DeleteTimeCurve[_Total_Symbols_]; // 20 
double _DeleteTimeType[_Total_Symbols_]; // 20 

string tradeJson = "";
  
 
string OPT_TRAIL[_Total_Symbols_] = {
   /*AUDCAD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*AUDCHF*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*AUDJPY*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*AUDNZD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*AUDUSD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*CADCHF*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*CADJPY*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*CHFJPY*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*EURAUD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*EURCAD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*EURCHF*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*EURGBP*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*EURJPY*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*EURNZD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*EURUSD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*GBPAUD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.26;TrailingGapType=-1.0;TrailingTargetCurve=0.30;TrailingTargetType=-1.0;DeleteOrderCurve=0.23;DeleteOrderType=-1.0;DeleteTimeCurve=0.24;DeleteTimeType=-1.0;",
   /*GBPCAD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*GBPCHF*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*GBPJPY*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*GBPNZD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*GBPUSD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=0.0;VelocitySignalCurve=-0.16;VelocitySignalType=0.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*NZDCAD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*NZDCHF*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*NZDJPY*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*NZDUSD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*USDCAD*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*USDCHF*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;",
   /*USDJPY*/ "GapRatio=0.10;VelocitySamplesCurve=0.26;VelocitySamplesType=-1.0;VelocitySignalCurve=0.26;VelocitySignalType=-1.0;OrderDistanceCurve=0.27;OrderDistanceType=0.0;StopLossCurve=0.33;StopLossType=-1.0;TrailingGapCurve=0.25;TrailingGapType=-1.0;TrailingTargetCurve=0.40;TrailingTargetType=0.0;DeleteOrderCurve=0.43;DeleteOrderType=0.0;DeleteTimeCurve=0.44;DeleteTimeType=0.0;"
};
 
  string OPT_MAP_0[_Total_Symbols_] = {
   /*AUDCAD*/ "SpreadMap=7;VelocitySamples=9;VelocitySignal=35;OrderDistance=5;StopLoss=35;TrailingGap=6;TrailingTarget=16;DeleteOrder=15;DeleteTime=35;",
   /*AUDCHF*/ "SpreadMap=5;VelocitySamples=10;VelocitySignal=29;OrderDistance=1;StopLoss=22;TrailingGap=3;TrailingTarget=7;DeleteOrder=10;DeleteTime=7;",
   /*AUDJPY*/ "SpreadMap=6;VelocitySamples=8;VelocitySignal=26;OrderDistance=2;StopLoss=26;TrailingGap=5;TrailingTarget=9;DeleteOrder=12;DeleteTime=8;",
   /*AUDNZD*/ "SpreadMap=11;VelocitySamples=10;VelocitySignal=29;OrderDistance=3;StopLoss=33;TrailingGap=7;TrailingTarget=23;DeleteOrder=17;DeleteTime=41;",
   /*AUDUSD*/ "SpreadMap=5;VelocitySamples=8;VelocitySignal=24;OrderDistance=2;StopLoss=27;TrailingGap=5;TrailingTarget=11;DeleteOrder=8;DeleteTime=5;",
   /*CADCHF*/ "SpreadMap=6;VelocitySamples=8;VelocitySignal=22;OrderDistance=2;StopLoss=26;TrailingGap=6;TrailingTarget=11;DeleteOrder=6;DeleteTime=10;",
   /*CADJPY*/ "SpreadMap=7;VelocitySamples=12;VelocitySignal=33;OrderDistance=4;StopLoss=34;TrailingGap=19;TrailingTarget=14;DeleteOrder=11;DeleteTime=49;",
   /*CHFJPY*/ "SpreadMap=7;VelocitySamples=8;VelocitySignal=39;OrderDistance=6;StopLoss=24;TrailingGap=6;TrailingTarget=9;DeleteOrder=9;DeleteTime=37;",
   /*EURAUD*/ "SpreadMap=8;VelocitySamples=14;VelocitySignal=50;OrderDistance=11;StopLoss=27;TrailingGap=4;TrailingTarget=15;DeleteOrder=2;DeleteTime=3;",
   /*EURCAD*/ "SpreadMap=7;VelocitySamples=8;VelocitySignal=35;OrderDistance=5;StopLoss=59;TrailingGap=11;TrailingTarget=13;DeleteOrder=9;DeleteTime=44;",
   /*EURCHF*/ "SpreadMap=6;VelocitySamples=9;VelocitySignal=27;OrderDistance=2;StopLoss=16;TrailingGap=6;TrailingTarget=8;DeleteOrder=10;DeleteTime=7;",
   /*EURGBP*/ "SpreadMap=5;VelocitySamples=8;VelocitySignal=35;OrderDistance=3;StopLoss=37;TrailingGap=4;TrailingTarget=13;DeleteOrder=8;DeleteTime=9;",
   /*EURJPY*/ "SpreadMap=3;VelocitySamples=8;VelocitySignal=23;OrderDistance=3;StopLoss=18;TrailingGap=5;TrailingTarget=9;DeleteOrder=9;DeleteTime=11;",
   /*EURNZD*/ "SpreadMap=16;VelocitySamples=9;VelocitySignal=59;OrderDistance=9;StopLoss=64;TrailingGap=20;TrailingTarget=28;DeleteOrder=28;DeleteTime=55;",
   /*EURUSD*/ "SpreadMap=3;VelocitySamples=10;VelocitySignal=29;OrderDistance=3;StopLoss=30;TrailingGap=5;TrailingTarget=9;DeleteOrder=6;DeleteTime=10;",
   /*GBPAUD*/ "SpreadMap=16;VelocitySamples=9;VelocitySignal=86;OrderDistance=11;StopLoss=76;TrailingGap=19;TrailingTarget=21;DeleteOrder=24;DeleteTime=50;",
   /*GBPCAD*/ "SpreadMap=16;VelocitySamples=14;VelocitySignal=86;OrderDistance=16;StopLoss=120;TrailingGap=20;TrailingTarget=60;DeleteOrder=34;DeleteTime=7;",
   /*GBPCHF*/ "SpreadMap=8;VelocitySamples=9;VelocitySignal=48;OrderDistance=8;StopLoss=73;TrailingGap=7;TrailingTarget=25;DeleteOrder=16;DeleteTime=7;",
   /*GBPJPY*/ "SpreadMap=7;VelocitySamples=9;VelocitySignal=63;OrderDistance=8;StopLoss=57;TrailingGap=8;TrailingTarget=30;DeleteOrder=15;DeleteTime=5;",
   /*GBPNZD*/ "SpreadMap=4;VelocitySamples=8;VelocitySignal=23;OrderDistance=1;StopLoss=26;TrailingGap=3;TrailingTarget=7;DeleteOrder=8;DeleteTime=9;",
   /*GBPUSD*/ "SpreadMap=5;VelocitySamples=14;VelocitySignal=50;OrderDistance=11;StopLoss=55;TrailingGap=6;TrailingTarget=15;DeleteOrder=11;DeleteTime=4;",
   /*NZDCAD*/ "SpreadMap=4;VelocitySamples=8;VelocitySignal=23;OrderDistance=1;StopLoss=26;TrailingGap=3;TrailingTarget=7;DeleteOrder=8;DeleteTime=9;",
   /*NZDCHF*/ "SpreadMap=4;VelocitySamples=8;VelocitySignal=23;OrderDistance=1;StopLoss=26;TrailingGap=3;TrailingTarget=7;DeleteOrder=8;DeleteTime=9;",
   /*NZDJPY*/ "SpreadMap=4;VelocitySamples=8;VelocitySignal=23;OrderDistance=1;StopLoss=26;TrailingGap=3;TrailingTarget=7;DeleteOrder=8;DeleteTime=9;",
   /*NZDUSD*/ "SpreadMap=7;VelocitySamples=8;VelocitySignal=29;OrderDistance=5;StopLoss=35;TrailingGap=6;TrailingTarget=14;DeleteOrder=18;DeleteTime=30;",
   /*USDCAD*/ "SpreadMap=5;VelocitySamples=8;VelocitySignal=29;OrderDistance=4;StopLoss=45;TrailingGap=4;TrailingTarget=18;DeleteOrder=11;DeleteTime=4;",
   /*USDCHF*/ "SpreadMap=4;VelocitySamples=8;VelocitySignal=25;OrderDistance=2;StopLoss=30;TrailingGap=3;TrailingTarget=7;DeleteOrder=9;DeleteTime=6;",
   /*USDJPY*/ "SpreadMap=4;VelocitySamples=8;VelocitySignal=23;OrderDistance=1;StopLoss=26;TrailingGap=3;TrailingTarget=7;DeleteOrder=8;DeleteTime=9;"
};

string OPT_MAP_1[_Total_Symbols_] = {
   /*AUDCAD*/ "SpreadMap=17;VelocitySamples=14;VelocitySignal=47;OrderDistance=11;StopLoss=56;TrailingGap=15;TrailingTarget=37;DeleteOrder=21;DeleteTime=50;",
   /*AUDCHF*/ "SpreadMap=13;VelocitySamples=15;VelocitySignal=48;OrderDistance=9;StopLoss=49;TrailingGap=16;TrailingTarget=26;DeleteOrder=23;DeleteTime=19;",
   /*AUDJPY*/ "SpreadMap=12;VelocitySamples=18;VelocitySignal=46;OrderDistance=9;StopLoss=54;TrailingGap=15;TrailingTarget=23;DeleteOrder=19;DeleteTime=26;",
   /*AUDNZD*/ "SpreadMap=23;VelocitySamples=19;VelocitySignal=44;OrderDistance=17;StopLoss=59;TrailingGap=19;TrailingTarget=48;DeleteOrder=32;DeleteTime=24;",
   /*AUDUSD*/ "SpreadMap=11;VelocitySamples=13;VelocitySignal=55;OrderDistance=7;StopLoss=55;TrailingGap=9;TrailingTarget=22;DeleteOrder=25;DeleteTime=24;",
   /*CADCHF*/ "SpreadMap=14;VelocitySamples=14;VelocitySignal=43;OrderDistance=5;StopLoss=51;TrailingGap=8;TrailingTarget=18;DeleteOrder=12;DeleteTime=22;",
   /*CADJPY*/ "SpreadMap=11;VelocitySamples=12;VelocitySignal=44;OrderDistance=8;StopLoss=54;TrailingGap=12;TrailingTarget=24;DeleteOrder=23;DeleteTime=11;",
   /*CHFJPY*/ "SpreadMap=16;VelocitySamples=11;VelocitySignal=65;OrderDistance=9;StopLoss=74;TrailingGap=12;TrailingTarget=39;DeleteOrder=27;DeleteTime=9;",
   /*EURAUD*/ "SpreadMap=13;VelocitySamples=16;VelocitySignal=63;OrderDistance=15;StopLoss=37;TrailingGap=11;TrailingTarget=29;DeleteOrder=5;DeleteTime=5;",
   /*EURCAD*/ "SpreadMap=15;VelocitySamples=14;VelocitySignal=57;OrderDistance=9;StopLoss=62;TrailingGap=14;TrailingTarget=23;DeleteOrder=19;DeleteTime=22;",
   /*EURCHF*/ "SpreadMap=12;VelocitySamples=12;VelocitySignal=47;OrderDistance=9;StopLoss=49;TrailingGap=8;TrailingTarget=18;DeleteOrder=17;DeleteTime=21;",
   /*EURGBP*/ "SpreadMap=9;VelocitySamples=14;VelocitySignal=47;OrderDistance=8;StopLoss=53;TrailingGap=8;TrailingTarget=26;DeleteOrder=18;DeleteTime=15;",
   /*EURJPY*/ "SpreadMap=13;VelocitySamples=16;VelocitySignal=45;OrderDistance=9;StopLoss=67;TrailingGap=29;TrailingTarget=31;DeleteOrder=21;DeleteTime=22;",
   /*EURNZD*/ "SpreadMap=31;VelocitySamples=19;VelocitySignal=110;OrderDistance=24;StopLoss=114;TrailingGap=54;TrailingTarget=68;DeleteOrder=48;DeleteTime=25;",
   /*EURUSD*/ "SpreadMap=8;VelocitySamples=14;VelocitySignal=44;OrderDistance=8;StopLoss=33;TrailingGap=6;TrailingTarget=26;DeleteOrder=15;DeleteTime=10;",
   /*GBPAUD*/ "SpreadMap=36;VelocitySamples=16;VelocitySignal=111;OrderDistance=24;StopLoss=85;TrailingGap=27;TrailingTarget=54;DeleteOrder=52;DeleteTime=35;",
   /*GBPCAD*/ "SpreadMap=32;VelocitySamples=19;VelocitySignal=114;OrderDistance=28;StopLoss=130;TrailingGap=24;TrailingTarget=58;DeleteOrder=43;DeleteTime=5;",
   /*GBPCHF*/ "SpreadMap=18;VelocitySamples=13;VelocitySignal=67;OrderDistance=14;StopLoss=93;TrailingGap=13;TrailingTarget=29;DeleteOrder=32;DeleteTime=9;",
   /*GBPJPY*/ "SpreadMap=19;VelocitySamples=15;VelocitySignal=65;OrderDistance=14;StopLoss=76;TrailingGap=18;TrailingTarget=38;DeleteOrder=46;DeleteTime=10;",
   /*GBPNZD*/ "SpreadMap=11;VelocitySamples=11;VelocitySignal=29;OrderDistance=4;StopLoss=47;TrailingGap=8;TrailingTarget=23;DeleteOrder=19;DeleteTime=17;",
   /*GBPUSD*/ "SpreadMap=13;VelocitySamples=19;VelocitySignal=74;OrderDistance=12;StopLoss=83;TrailingGap=12;TrailingTarget=42;DeleteOrder=21;DeleteTime=7;",
   /*NZDCAD*/ "SpreadMap=11;VelocitySamples=11;VelocitySignal=29;OrderDistance=4;StopLoss=47;TrailingGap=8;TrailingTarget=23;DeleteOrder=19;DeleteTime=17;",
   /*NZDCHF*/ "SpreadMap=11;VelocitySamples=11;VelocitySignal=29;OrderDistance=4;StopLoss=47;TrailingGap=8;TrailingTarget=23;DeleteOrder=19;DeleteTime=17;",
   /*NZDJPY*/ "SpreadMap=11;VelocitySamples=11;VelocitySignal=29;OrderDistance=4;StopLoss=47;TrailingGap=8;TrailingTarget=23;DeleteOrder=19;DeleteTime=17;",
   /*NZDUSD*/ "SpreadMap=12;VelocitySamples=8;VelocitySignal=24;OrderDistance=5;StopLoss=39;TrailingGap=6;TrailingTarget=16;DeleteOrder=18;DeleteTime=30;",
   /*USDCAD*/ "SpreadMap=11;VelocitySamples=11;VelocitySignal=45;OrderDistance=7;StopLoss=65;TrailingGap=10;TrailingTarget=32;DeleteOrder=23;DeleteTime=7;",
   /*USDCHF*/ "SpreadMap=11;VelocitySamples=14;VelocitySignal=39;OrderDistance=7;StopLoss=53;TrailingGap=16;TrailingTarget=29;DeleteOrder=17;DeleteTime=11;",
   /*USDJPY*/ "SpreadMap=11;VelocitySamples=11;VelocitySignal=29;OrderDistance=4;StopLoss=47;TrailingGap=8;TrailingTarget=23;DeleteOrder=19;DeleteTime=17;"
};

void set0(int ii, string sym){
   string s = OPT_MAP_0[ii];
  
   string ss[];
   int k = StringSplit( s, StringGetCharacter( ";" , 0 ), ss );
      
   if( k > -1){
   
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"SpreadMap=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _SpreadMap0[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"VelocitySamples=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _VelocitySamples0[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }   
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"VelocitySignal=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _VelocitySignal0[ii] = ( int ) StringToDouble( sss[1] ); 
               break;
            }
         }
      } 
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"OrderDistance=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _OrderDistance0[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      } 
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"StopLoss=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _StopLoss0[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      } 
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"TrailingGap=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _TrailingGap0[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"TrailingTarget=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _TrailingTarget0[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"DeleteOrder=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){ 
               _DeleteOrder0[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"DeleteTime=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){ 
               _DeleteTime0[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
   }
}

void set1(int ii, string sym){
   string s = OPT_MAP_1[ii];
 
   string ss[];
   int k = StringSplit( s, StringGetCharacter( ";" , 0 ), ss );
      
   if( k > -1){
   
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"SpreadMap=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _SpreadMap1[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"VelocitySamples=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){  
               _VelocitySamples1[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }   
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"VelocitySignal=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _VelocitySignal1[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      } 
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"OrderDistance=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _OrderDistance1[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      } 
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"StopLoss=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _StopLoss1[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      } 
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"TrailingGap=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){  
               _TrailingGap1[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"TrailingTarget=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){ 
               _TrailingTarget1[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"DeleteOrder=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _DeleteOrder1[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"DeleteTime=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _DeleteTime1[ii] = ( int ) StringToDouble( sss[1] );
               break;
            }
         }
      }
   }
}

 
void setTrail(int ii){
   string s = OPT_TRAIL[ii];
   string ss[];
   int k = StringSplit( s, StringGetCharacter( ";" , 0 ), ss );
      
   if( k > -1){
   
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"GapRatio=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _GapRatio[ii] =   StringToDouble( sss[1]);
               break;
            }
         }
      }  
      
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"VelocitySamplesCurve=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _VelocitySamplesCurve[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"VelocitySamplesType=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _VelocitySamplesType[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"VelocitySignalCurve=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _VelocitySignalCurve[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"VelocitySignalType=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _VelocitySignalType[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"OrderDistanceCurve=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _OrderDistanceCurve[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"OrderDistanceType=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _OrderDistanceType[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"StopLossCurve=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _StopLossCurve[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"StopLossType=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _StopLossType[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"TrailingGapCurve=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _TrailingGapCurve[ii] = StringToDouble( sss[1] ); 
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"TrailingGapType=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _TrailingGapType[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"TrailingTargetCurve=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _TrailingTargetCurve[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"TrailingTargetType=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _TrailingTargetType[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"DeleteOrderCurve=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _DeleteOrderCurve[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"DeleteOrderType=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _DeleteOrderType[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"DeleteTimeCurve=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _DeleteTimeCurve[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
      
      for( int i = 0; i < k; i++ ){
         if(StringFind(ss[i],"DeleteTimeType=") > -1 ){
            string sss[];
            int kk = StringSplit( ss[i], StringGetCharacter( "=" , 0 ), sss );
            if( kk > -1){
               _DeleteTimeType[ii] = StringToDouble( sss[1] );
               break;
            }
         }
      }
   }
}

void setInputs(){
   if( USE_OPT ){
      for( int ii = 0; ii < _Total_Symbols_; ii++ ) { 
         set0(ii, as_symbol[ii]);
         set1(ii, as_symbol[ii]); 
         setTrail(ii);
      }
   } else {   
      ArrayFill( _SpreadMap0, 0, _Total_Symbols_, MaxSpread );
      ArrayFill( _VelocitySamples0, 0, _Total_Symbols_, VelocitySamples );   
      ArrayFill( _VelocitySamples1, 0, _Total_Symbols_, VelocitySamples ); 
      ArrayFill( _VelocitySignal0, 0, _Total_Symbols_, VelocitySignal ); 
      ArrayFill( _OrderDistance0, 0, _Total_Symbols_, OrderDistance ); 
      ArrayFill( _StopLoss0, 0, _Total_Symbols_, StopLoss ); 
      ArrayFill( _TrailingGap0, 0, _Total_Symbols_, TrailingGap ); 
      ArrayFill( _TrailingTarget0, 0, _Total_Symbols_, TrailingTarget ); 
      ArrayFill( _DeleteOrder0, 0, _Total_Symbols_, DeleteOrder ); 
      ArrayFill( _DeleteTime0, 0, _Total_Symbols_, DeleteTime );
      ArrayFill( _GapRatio, 0, _Total_Symbols_, GapRatio );     
   } 
   
}

double spline(double x, double k){ 
   return ( x - x * k ) / ( k - MathAbs(x) * 2 * k + 1);
} 

double mapValue( double actualSource, double minSource, double maxSource, double minDestination, double maxDestination ){  
   if( ( maxSource - minSource ) == 0 ) return ( maxDestination ); 
   double map = minDestination + ( ( actualSource - minSource ) / ( maxSource - minSource ) * ( maxDestination - minDestination ) ); 
   double clamp = MathMin( MathMax( minDestination, map ), maxDestination );
   if( minDestination > maxDestination ) clamp = MathMax( MathMin( minDestination, map ), maxDestination ); 
   return ( clamp ); 
} 

struct SInfo {
   bool signal;
   double ask;
   double bid;
   double point;
   int digits;
   string symbol; 
   double ma; 
   double ma1; 
   double sar;
   double emahl;
   double emalu;
   double atr; 
   double delta;
   double vel;
   double basket;
   int trades;
   int orders;
   int unprotected;
   int stops;
   bool canBuy;
   bool canSell;
   double profit;
   uint lastTime;
   double marginRequirement;
   double minLot;
   double maxLot;
   double lotStep;
   double commissonPoints;
   double avgBuyPrice;
   double avgSellPrice;
   double avgBuyPriceNew;
   double avgSellPriceNew;
   double buyLots;
   double lastSpread;
   double sellLots;
   double velocity;
   double stdDev;
   double spread;
   double totalSpread;
   int totalPendingStop;
   double lowestBuyStoploss;
   double highestSellStoploss;
   double minMeasure;
   int velocitySamples;
   int velocitySignal;
   int orderDistance;
   int stopLoss;
   int trailingGap;
   int trailingTarget;
   int deleteOrder;
   uint deleteTime;
   double gapRatio;
   double trailingRatioStart;
   double trailingRatioEnd; 
   double highSpread;
   double lowSpread;
   uint lastSpreadTime;
   double lowBuy;
   double highSell;
   double largestLoss;
   int largestLossTicket;
   double rsi;
   double totalProfits;
   double totalLosses;
}; 
 

struct SAccount {
   int totalSymbols;
   uint basketTime;
   double basketProfit;
   double targetProfit;
   double dollarProfit;
   double lastBasketAccount;
   int lossTicket;
   int totalUnprotected;
   int totalTrades;
   int totalLoosers;
   double multiplier;
   int lastHistoryTotal;
   int totalOrders;
   string tradeJson;
   int largestTicketLoss;
   double largetsValueLoss;
};

struct SStatus { 
   double velocity;
};

struct SResult {
   int send;
   int manage;
};
enum symbols {
   AUDCAD = 0,
   AUDCHF = 1,
   AUDJPY = 2,
   AUDNZD = 3,
   AUDUSD = 4,
   CADCHF = 5,
   CADJPY = 6,
   CHFJPY = 7,
   EURAUD = 8,
   EURCAD = 9,
   EURCHF = 10,
   EURGBP = 11,
   EURJPY = 12,
   EURNZD = 13,
   EURUSD = 14,
   GBPAUD = 15,
   GBPCAD = 16,
   GBPCHF = 17,
   GBPJPY = 18,
   GBPNZD = 19,
   GBPUSD = 20,
   NZDCAD = 21,
   NZDCHF = 22,
   NZDJPY = 23,
   NZDUSD = 24,
   USDCAD = 25,
   USDCHF = 26,
   USDJPY = 27
}; 
// SYMBOL DEFINITIONS
string as_symbol[_Total_Symbols_] = {  
   "AUDCAD", // 0
   "AUDCHF", // 1
   "AUDJPY", // 2
   "AUDNZD", // 3
   "AUDUSD", // 4
   "CADCHF", // 5
   "CADJPY", // 6
   "CHFJPY", // 7
   "EURAUD", // 8
   "EURCAD", // 9
   "EURCHF", // 10
   "EURGBP", // 11
   "EURJPY", // 12
   "EURNZD", // 13
   "EURUSD", // 14
   "GBPAUD", // 15
   "GBPCAD", // 16
   "GBPCHF", // 17
   "GBPJPY", // 18
   "GBPNZD", // 19
   "GBPUSD", // 20
   "NZDCAD", // 21
   "NZDCHF", // 22
   "NZDJPY", // 23
   "NZDUSD", // 24
   "USDCAD", // 25
   "USDCHF", // 26
   "USDJPY" // 27 total = 28
}; 

int ai_digits[_Total_Symbols_] = {  
   5,
   5,
   3,
   5,
   5,
   5,
   3,
   3,
   5,
   5,
   5,
   5,
   3,
   5,
   5,
   5,
   5,
   5,
   3,
   5,
   5,
   5,
   5,
   3,
   5,
   5,
   5,
   3
};
double ad_point[_Total_Symbols_] = {  
   0.00001,
   0.00001,
   0.001,
   0.00001,
   0.00001,
   0.00001,
   0.001,
   0.001,
   0.00001,
   0.00001,
   0.00001,
   0.00001,
   0.001,
   0.00001,
   0.00001,
   0.00001,
   0.00001,
   0.00001,
   0.001,
   0.00001,
   0.00001,
   0.00001,
   0.00001,
   0.001,
   0.00001,
   0.00001,
   0.00001,
   0.001
};

interface IDisplay {  
   void comment();
   void append( string _s );
   void reset();
   
};

class CDisplay : public IDisplay {
   string display[];
   public:  
      CDisplay( 
 
      ) { 
          
      }
      ~CDisplay() { 
          
      }
   
    
   
   void reset(){
      ArrayResize(this.display,0);
   }
    
   void append( string _s ){
 
      int size = ArraySize(this.display);
      ArrayResize(this.display,size+1);
      this.display[size] = _s;
   }
   
   void comment(){ 
      string s = "\n\n";
      for( int i = 0; i < ArraySize( this.display ); i++ ){
         s = StringConcatenate( s, this.display[i] );
      }
      Comment(s);
   }
};

interface IBuffer {  
   void appendTo( double value );
   double getAvgBuffer();
   double getIndexValue( int i );
   double getMaxBuffer(int samples);
   double getMinBuffer(int samples);
   double getStdBuffer();
};

class CBuffer : public IBuffer {
   int i_size;
   double d_initValue, d_avgBuffer;
   string s_display;
   double ad_buffer[];
   public:
      CBuffer(  
         int size = 30,
         double initValue = 0.0
      ) {
         i_size = size;
         d_initValue = initValue;
         ArrayResize( ad_buffer, i_size );  
         ArrayFill( ad_buffer, 0, i_size, d_initValue );
      }
      
   void appendTo( double value ){
      double ad_buffer_temp[]; 
      ArrayResize( ad_buffer_temp, i_size - 1 );
      ArrayCopy( ad_buffer_temp, ad_buffer, 0, 1, i_size - 1 );
      ArrayResize( ad_buffer_temp, i_size );   
    
      ad_buffer_temp[i_size - 1] = value; 
      ArrayCopy( ad_buffer, ad_buffer_temp, 0, 0 );  
   }
   
   double getAvgBuffer(){
      return iMAOnArray( ad_buffer, i_size, i_size, 0, MODE_SMMA, 0 );
   }
   
   double getStdBuffer(){
      return iStdDevOnArray( ad_buffer,i_size, i_size, 0, MODE_SMMA, 0);
   }
   
   double getMaxBuffer(int samples){
      int maxValueIdx = ArrayMaximum( ad_buffer, samples, i_size - samples - 1 );
      return ad_buffer[maxValueIdx];
   }
   
   double getMinBuffer(int samples){
      int minValueIdx = ArrayMinimum( ad_buffer, samples, i_size - samples - 1 );
      return ad_buffer[minValueIdx];
   }
   
   double getIndexValue( int i ){
      return ( ad_buffer[i_size - 1 - i] );
   }
   
}; 
interface IVelocity {  
   void processOnTick( double price, int samples ); 
   double getVelocity();  
}; 

class CVelocity : public IVelocity {
   string s_display;
   
   uint u_tickCount, u_processCount;
   int i_digits, d_lastPrice, i_symbolIndex, i_period;
   double d_point, d_price, d_velocity;
   double lastPrice;
   int lastInt;
   double std;
 
   IBuffer *buffer; 
   
   public:
      CVelocity( 
         int symbolIndex = GBPUSD, // 1
         int period = 30, // 2  
         double initValue = 0.0 // 3
      ) { 
         i_symbolIndex = symbolIndex;
         d_point = ad_point[symbolIndex]; //and pass point from account
         i_period = period;   
         buffer = new CBuffer( 
                  i_period,
                  initValue
                ); 
      }
      ~CVelocity() { 
         delete buffer;
      }   
   double normalizePrice( double p, double point ){   
      return( MathRound( p / point ) * point );
   }
   void updateBuffer( int samples ){  
      double diff = MathAbs( d_price - lastPrice);
      int intVal = ( int ) ( d_price / d_point );
      if( intVal != lastInt ){
         buffer.appendTo( normalizePrice( d_price, d_point ) ); 
         lastPrice = d_price;
         lastInt = intVal;
      }
     //  double d_velocityTemp = buffer.getIndexValue( i_period - 1 ) - buffer.getIndexValue( 0 ) ; 
     // if( MathAbs( d_velocityTemp / d_point ) > 1500 ) d_velocity = 0.0;
     // else d_velocity = d_velocityTemp;  
     
      if( this.getMax( samples ) - buffer.getIndexValue( 0 ) > buffer.getIndexValue( 0 ) - getMin( samples ) ){
         d_velocity =(this.getMax( samples ) - buffer.getIndexValue( 0 ));
      } else {
         d_velocity =   -( buffer.getIndexValue( 0 ) - this.getMin(samples ) );
      } 
      double d_velocityTemp = d_velocity;
      if( MathAbs( d_velocityTemp / d_point ) > 1500 ) d_velocity = 0.0;
   
      std = buffer.getStdBuffer();
   } 
   
   double getVelocity(){ 
      return ( d_velocity );
   }  
   
   double getStd(){
      return std;
   }
   
   double getMax(int samples){
      return buffer.getMaxBuffer( samples );
   }
   
   double getMin(int samples){
      return buffer.getMinBuffer( samples );
   } 

   void processOnTick( double price, int samples  ){  //and pass point from account
      u_tickCount++;
      d_price = price; 
      u_processCount++;
      d_lastPrice = ( int ) ( price / d_point ); 
      updateBuffer( samples );  
   }  
}; 

interface ITrade { 
   SResult process( SAccount &_account, SInfo &_info );
   SInfo prepare();
};

class CTrade : public ITrade {

   SInfo info;
 
   SAccount account;
   IDisplay *display;
   
   string suffix, symbol; 
   
   int index, totalBuy, totalSell;
   
   uint buyTime, sellTime, timeCurrent, basketTimeInput;
  
   double buyPrice, sellPrice, profit, lastProfit, highestSellPrice, lowestBuyPrice, highestBuyPrice, 
   lowestSellPrice,   priceLotsBuy, priceLotsSell;
   
   bool closing, isTesting;
   
   public:  
      CTrade( 
         string _suffix,
         int _i
      ) { 
         this.isTesting = IsTesting();
         this.suffix = _suffix;
         this.symbol = as_symbol[_i] + _suffix;  
         this.index = _i;
      }
      ~CTrade() { 
      
      }
   
   
   SInfo prepare(){  
      int r, ot;  
      double ol, osl, otp, oop, op, oc, os;  
      this.info.trades = 0;
      this.info.orders = 0;
      this.info.unprotected = 0;
      this.info.stops = 0;
      this.info.totalPendingStop = 0;
      this.buyPrice = 0;
      this.info.largestLoss = 0;
      this.info.largestLossTicket = EMPTY_VALUE;
      this.sellPrice = EMPTY_VALUE;
      this.info.profit = 0;
      this.lastProfit = 0;
      this.timeCurrent = ( uint ) TimeCurrent();
      this.highestSellPrice = 0;
      this.lowestBuyPrice = EMPTY_VALUE;
      this.highestBuyPrice = 0;
      this.lowestSellPrice = EMPTY_VALUE;
      this.totalBuy = 0;
      this.totalSell = 0;
      this.info.buyLots = 0;
      this.info.sellLots = 0;
      this.priceLotsBuy = 0;
      this.priceLotsSell = 0;
      this.info.avgBuyPrice = 0;
      this.info.avgSellPrice = 0;
      this.info.lastTime = 0;
      this.info.lowestBuyStoploss = EMPTY_VALUE;
      this.info.highestSellStoploss = 0;
      this.info.totalProfits = 0;
      this.info.totalLosses = 0;
      
    // this.account.tradeJson = "";
      for( int pos = OrdersTotal() - 1; pos >= 0; pos-- ) { 
         r = OrderSelect( pos, SELECT_BY_POS, MODE_TRADES ); 
         if( OrderSymbol() != this.symbol || OrderMagicNumber() != MagicNumber ) continue;  
         osl = OrderStopLoss(); 
         oop = OrderOpenPrice();
         otp = OrderTakeProfit();
         ot = OrderTicket();
         ol = OrderLots();
         op = OrderProfit();
         oc = OrderCommission();
         os = OrderSwap();
         if( ( uint ) OrderOpenTime() > this.info.lastTime ){
            this.info.lastTime = ( uint ) OrderOpenTime();
         }
       
         tradeJson = StringConcatenate(tradeJson, "{\"symbol\":\"",OrderSymbol(),"\",\"type\":\"",OrderType(),"\",\"op\":\"",op,"\",\"ol\":\"",ol,"\"},");
	
         
         switch ( OrderType() ) { 
            case OP_BUYSTOP: 
               this.info.trades++;
               this.info.orders++;
               this.info.totalPendingStop++; 
               this.info.unprotected++; 
            break;
            
            case OP_SELLSTOP: 
               this.info.trades++;
               this.info.orders++;
               this.info.totalPendingStop++;
               this.info.unprotected++;
            break;
            case OP_BUY:    
               this.info.trades++;
               this.totalBuy++;
               this.info.buyLots += OrderLots();
               this.info.profit += op + oc + os;
               if( op + oc + os > 0 ){
                  this.info.totalProfits += op + oc + os;
               } else {
                  this.info.totalLosses += op + oc + os;
               }
               if( oop > this.buyPrice ){
                  this.buyPrice = oop;
                  this.buyTime = ( uint ) OrderOpenTime();
                  this.lastProfit = OrderProfit();
               }
               if( oop < this.lowestBuyPrice )
                  this.lowestBuyPrice = oop;
               if( oop > this.highestBuyPrice )
                  this.highestBuyPrice = oop;
               this.info.lowBuy = this.highestBuyPrice;
               if( osl > 0 && osl < this.info.lowestBuyStoploss )
                  this.info.lowestBuyStoploss = osl;
               
               if( osl > 0 )
                  this.info.stops++;
               this.priceLotsBuy += ol * oop;
               
               if( op < 0 && -MathAbs(oop - this.info.bid)/ad_point[this.index] < largeLoss ){
                //  this.info.largestLoss = this.info.bid - oop;
                 // this.info.largestLossTicket = ot;
                 // if( this.info.bid - oop < largeLoss ){
                     largeLoss=-MathAbs(oop - this.info.bid)/ad_point[this.index];
                     largeLossTicket=ot;
                 // }
               }
               if( osl == 0 || ( osl > 0 && osl < oop ) ) 
                  this.info.unprotected++;
            break;
            case OP_SELL:    
               this.info.trades++;
               this.totalSell++;
               this.info.sellLots += OrderLots();
               this.info.profit += op + oc + os;
               
               if( op + oc + os > 0 ){
                  this.info.totalProfits += op + oc + os;
               } else {
                  this.info.totalLosses += op + oc + os;
               }
               if( oop < this.sellPrice ){
                  this.sellPrice = oop;
                  this.sellTime = ( uint ) OrderOpenTime();
                  this.lastProfit = OrderProfit();
               }
               if( oop > this.highestSellPrice )
                  this.highestSellPrice = oop;
               if( oop < this.lowestSellPrice )
                  this.lowestSellPrice = oop;
               if( osl > 0 && osl > this.info.highestSellStoploss )
                  this.info.highestSellStoploss = osl;
               this.info.highSell = this.lowestSellPrice;   
               if( osl > 0 )
                  this.info.stops++;
               this.priceLotsSell += ol * oop;
               if( op < 0 && -MathAbs(oop - this.info.ask)/ad_point[this.index] < largeLoss ){
                 // this.info.largestLoss = oop - this.info.ask;
                  //this.info.largestLossTicket = ot;
                 // if( oop - this.info.ask < largeLoss ){
                     largeLoss=-MathAbs(oop - this.info.ask)/ad_point[this.index];
                     largeLossTicket=ot;
                //  }
               }
               if( osl == 0 || ( osl > 0 && osl > oop ) ) 
                  this.info.unprotected++;
            break;
         } 
      }
      
      
      double newPriceLotsBuy = 0;
      double newPriceLotsSell = 0;
      double newLotsBuy = 0;
      double newLotsSell = 0; 
      ol = MathMax( MathMax( AccountBalance() / Divider, 1 ) * Lots, 0.01 ); 
      if( this.info.buyLots > 0 ){
         this.info.avgBuyPrice = this.priceLotsBuy / this.info.buyLots;
         newPriceLotsBuy = this.priceLotsBuy + ( this.info.ask * ol );
         newLotsBuy = this.info.buyLots + ol;
         this.info.avgBuyPriceNew = newPriceLotsBuy / newLotsBuy;
      }
      if( this.info.sellLots > 0 ){
         this.info.avgSellPrice = this.priceLotsSell / this.info.sellLots;
         newPriceLotsSell = this.priceLotsSell + ( this.info.bid * ol );
         newLotsSell = this.info.sellLots + ol;
         this.info.avgSellPriceNew = newPriceLotsSell / newLotsSell;
      } 
      if( this.info.trades < 1 )
         this.closing = false; 
      return info;
   }
   
   int manage(){
      double openSpread = this.info.totalSpread;
      double actual = openSpread;
      int r, ot;  
      double osl, otp, oop, ol,op; 
      double trailing = this.info.trailingGap * this.info.point;
      double trailingGap = this.info.trailingGap * this.info.point;
      double mapTrailing = 1;
      double mapGap = 1;
    //  double absProfit;
      //this.info.unprotected=0; // this is wrong but anyway for sake of opt
       double price, stoploss;
     double buyDist, sellDist;
      for( int pos = OrdersTotal() - 1; pos >= 0; pos-- ) { 
         r = OrderSelect( pos, SELECT_BY_POS, MODE_TRADES ); 
         if( OrderSymbol() != this.symbol || OrderMagicNumber() != MagicNumber ) continue;   
         oop = OrderOpenPrice(); 
         ot = OrderTicket(); 
         osl = OrderStopLoss();
         otp = OrderTakeProfit();
         ol = OrderLots();
         op=OrderProfit() + OrderCommission()+OrderSwap();
         switch ( OrderType() ) { 
           case OP_BUYSTOP: 
               if(  this.info.ask < oop - ( this.info.deleteOrder * this.info.point ) ){
            
                  price =  this.info.ask +  ( this.info.orderDistance * this.info.point ); 
                  stoploss = this.info.bid - ( this.info.stopLoss * this.info.point );
                  r = OrderModify( ot, normalizePrice( price, this.info.point ), normalizePrice( stoploss, this.info.point ), otp, 0 ); 
               } else {
                  if( ( uint ) TimeCurrent() - ( uint ) OrderOpenTime() > this.info.deleteTime ){
                    // r = OrderDelete( ot );
                  }
               }
            break;
            case OP_SELLSTOP: 
               if(   this.info.bid > oop + (this.info.deleteOrder * this.info.point ) ){
                   price = this.info.bid - ( this.info.orderDistance * this.info.point ); 
                   stoploss = this.info.ask + ( this.info.stopLoss * this.info.point );
                   r = OrderModify( ot, normalizePrice( price, this.info.point ), normalizePrice( stoploss, this.info.point ), otp, 0 ); 
               } else {
                  if( ( uint ) TimeCurrent() - ( uint ) OrderOpenTime() > this.info.deleteTime ){
                 //    r = OrderDelete( ot );
                  }
               }
            break;
            case OP_BUY:
               if( ( uint ) TimeCurrent() - ( uint ) OrderOpenTime() > BasketTime ) 
               if( this.totalBuy > 1 &&  op + this.account.basketProfit > AccountBalance() * BasketAmount && ot == largeLossTicket ){
                   buyDist = MathAbs(this.info.lowestBuyStoploss - this.info.lowBuy)/ MaxTrades ;
                 //  if( this.info.bid < this.info.lowBuy - (buyDist*this.totalBuy)  ){
                    r = OrderClose( ot, ol, this.info.bid, Slippage );
                     this.account.basketTime = ( uint ) TimeCurrent();
                     this.totalBuy = 0;
                     return -1;
                 //  }
               } 
            
               oop = this.info.avgBuyPrice + this.info.commissonPoints ;
               if( this.totalBuy > 1 ){
                  if( this.info.totalProfits /  MathMax( MathAbs( this.info.totalLosses ), 0.001 ) > ProfitRatio ){
                     r = OrderClose( ot, ol, this.info.bid, Slippage );
                  }
               } else {
                  if(this.info.bid > oop + (this.info.trailingTarget * this.info.point) ){
                     r = OrderClose( ot, ol, this.info.bid, Slippage );
                  }
               }
               if(this.info.bid > oop + (this.info.trailingTarget * this.info.point/2) )
               if( this.totalBuy == 1 && ( uint ) TimeCurrent() - ( uint ) OrderOpenTime() > ShortTime && op > 0 ) 
                  r = OrderClose( ot, ol, this.info.bid, Slippage );
                  
                 
              /* if(this.info.bid > oop + (this.info.trailingTarget * this.info.point) ){
                  r = OrderClose( ot, ol, this.info.bid, Slippage );
               }
               */
               /*
               absProfit = MathMax( this.info.bid - oop, 0 );
               mapGap = mapValue( absProfit, 0, this.info.trailingTarget * this.info.point, 1, this.info.gapRatio ); 
               trailingGap = normalizePrice( this.info.trailingGap * this.info.point * mapGap, this.info.point );
               mapTrailing = mapValue( absProfit, 0, this.info.trailingTarget * this.info.point, this.info.point, trailingGap );
               trailing = normalizePrice( trailingGap - mapTrailing, this.info.point );
               if( this.info.bid - trailing > oop + this.info.commissonPoints )
                  if( osl == 0.0 || osl < oop || this.info.bid - osl > trailingGap )
                     if( osl == 0.0 || this.info.bid - osl > trailing )
                        if( this.info.bid - trailing != osl ) 
                           r = OrderModify( ot, oop, normalizePrice(this.info.bid - trailing, this.info.point), otp, 0 ); 
            
               */
            break;
            case OP_SELL:
              if( ( uint ) TimeCurrent() - ( uint ) OrderOpenTime() > BasketTime ) 
               if( this.totalSell > 1 && op + this.account.basketProfit > AccountBalance() * BasketAmount && ot == largeLossTicket ){
                   sellDist = MathAbs(this.info.highestSellStoploss - this.info.highSell)/ MaxTrades ;
                //   if( this.info.bid > this.info.highSell + (sellDist*this.totalSell) ){
                     r = OrderClose( ot, ol, this.info.ask, Slippage );
                     this.account.basketTime = ( uint ) TimeCurrent();
                     this.totalSell = 0;
                     return -1;
                 //  }
               } 
               oop = this.info.avgSellPrice - this.info.commissonPoints;
               if( this.totalSell > 1 ){
                  if( this.info.totalProfits / MathMax( MathAbs( this.info.totalLosses ), 0.001 ) > ProfitRatio ){
                     r = OrderClose( ot, ol, this.info.ask, Slippage );
                  }
               } else {
                  if(this.info.ask < oop - (this.info.trailingTarget * this.info.point) ){
                     r = OrderClose( ot, ol, this.info.ask, Slippage );
                  }
               }
                if(this.info.ask < oop - (this.info.trailingTarget * this.info.point/2) )
               if( this.totalSell == 1 && ( uint ) TimeCurrent() - ( uint ) OrderOpenTime() > ShortTime && op > 0 ) 
                  r = OrderClose( ot, ol, this.info.ask, Slippage );
               
               /*
               if(this.info.ask < oop - (this.info.trailingTarget * this.info.point) ){
                  r = OrderClose( ot, ol, this.info.ask, Slippage );
               }
               */
               /*
               oop = this.info.avgSellPrice - this.info.commissonPoints;
               absProfit = MathMax( oop - this.info.ask, 0 );
               mapGap = mapValue( absProfit, 0, this.info.trailingTarget * this.info.point, 1, this.info.gapRatio ); 
               trailingGap = normalizePrice( this.info.trailingGap * this.info.point * mapGap, this.info.point );
               mapTrailing = mapValue( absProfit, 0, this.info.trailingTarget * this.info.point, this.info.point, trailingGap );
               trailing = normalizePrice( trailingGap - mapTrailing, this.info.point );
               if( this.info.ask + trailing < oop - this.info.commissonPoints )
                  if( osl == 0.0 || osl > oop || osl - this.info.ask > trailingGap )
                     if( osl == 0.0 || osl - this.info.ask > trailing ) 
                        if( this.info.ask + trailing != osl )  
                           r = OrderModify( ot, oop, normalizePrice(this.info.ask + trailing, this.info.point), otp, 0 );       
               */
            break;
         }
      } 
 
      
      
      return -1;
   }
   
   double normalizePrice( double p, double point ){   
      return( MathRound( p / point ) * point );
   }
   double normalizeLots( double p ){
        
       return( MathRound( p / 0.01  ) * 0.01 );
   }
   double lotSize(){
      double lots = MathMin( MathMax( MathMax( AccountBalance() / Divider, 1 ) * Lots, this.info.minLot ), this.info.maxLot );        
      if( LotType == FIXED ) lots = Lots;
      return normalizePrice( lots, this.info.lotStep );
   }
   
   int send(){  
     // if( this.info.ask - this.info.bid + this.info.commissonPoints < ( _SpreadMap1[this.index] * this.info.point ) + ( this.info.point / 2 ) )
     if( this.account.totalSymbols < MaxOpenSymbols && this.account.totalOrders < 1 ){ 
            double lots = MathMin( MathMax( MathMax( AccountBalance() / Divider, 1 ) * Lots, this.info.minLot ), this.info.maxLot ); 
            if( ( this.info.unprotected < 1 || this.totalSell > 0 ) && ( this.info.signal || this.totalBuy > 0 || this.isTesting ) && this.info.rsi < RSIDiff && this.info.totalPendingStop < 1 ) {           
            //if( ( this.info.signal  ) && this.totalBuy < 1 && this.info.velocity > this.info.velocitySignal * this.info.point && this.info.totalPendingStop < 1 ) {      
               double price =  this.info.ask + ( this.info.totalPendingStop + 1.0 ) * ( this.info.orderDistance * this.info.point );
               double stoploss = this.info.bid - ( this.info.stopLoss * this.info.point ) ;
               int ticket = OrderSend( this.symbol, OP_BUYSTOP, lotSize(), normalizePrice( price, this.info.point ), Slippage, stoploss, 0, TradeComment, MagicNumber, 0 );         
               this.info.totalPendingStop++;
               return ( 0 );
            } 
            if( ( this.info.unprotected < 1 || this.totalBuy > 0 ) && ( this.info.signal || this.totalSell > 0 || this.isTesting ) && this.info.rsi > 100 - RSIDiff  && this.info.totalPendingStop < 1 ) {
            //if( ( this.info.signal   ) && this.totalSell< 1 && this.info.velocity < -this.info.velocitySignal * this.info.point && this.info.totalPendingStop < 1 ) {
               double price = this.info.bid - ( this.info.totalPendingStop + 1.0 ) * ( this.info.orderDistance * this.info.point ); 
               double stoploss = this.info.ask + ( this.info.stopLoss * this.info.point )  ;
               int ticket = OrderSend( this.symbol, OP_SELLSTOP, lotSize(), normalizePrice( price, this.info.point ), Slippage, stoploss, 0, TradeComment, MagicNumber, 0 );
               this.info.totalPendingStop++;
               return ( 0 );
            } 
      }
  /*
      double trailing = this.info.trailingGap * this.info.point;
      if( this.info.trades > 0 && this.info.trades < MaxTrades ){ 
         if( this.info.unprotected < 1 && account.totalUnprotected < 1 ){
            if( this.info.bid > this.info.avgBuyPrice &&   this.totalBuy > 0 && this.info.bid - trailing > this.info.avgBuyPriceNew ){  
               double l = MathMax( MathMax( AccountBalance() / Divider, 1 ) * Lots, 0.01 );
               int res = OrderSend( this.symbol, OP_BUY, l, info.ask, 0, this.info.lowestBuyStoploss, 0, TradeComment, MagicNumber );
               if( res > -1 ){ 
                  return OP_BUY;
               }  
            }
            if( this.info.ask < this.info.avgSellPrice  && this.totalSell > 0 && this.info.ask + trailing < this.info.avgSellPriceNew ){  
               double l = MathMax( MathMax( AccountBalance() / Divider, 1 ) * Lots, 0.01 );
               int res = OrderSend( this.symbol, OP_SELL, l, info.bid, 0, this.info.highestSellStoploss, 0, TradeComment, MagicNumber );
               if( res > -1 ){ 
                  return OP_SELL;
               } 
            }
         } 
      }*/
  
  
       if( this.info.trades > 0   ){ 
       double  buyDist = MathAbs(this.info.lowestBuyStoploss - this.info.lowBuy)/ MaxTrades ;
          double sellDist = MathAbs(this.info.highestSellStoploss - this.info.highSell)/ MaxTrades ;
         
         if(   this.info.bid < this.info.avgBuyPrice && this.totalBuy > 0 && this.info.ask < this.info.lowBuy - (buyDist*this.totalBuy) ){  
            double l = MathMax( MathMax( AccountBalance() / Divider, 1 ) * Lots, 0.01 );
            
          //  double m =  mapValue( spline( mapValue( ( double ) this.totalBuy / 10, ( double ) 1, ( double ) MaxTrades, 0, 1 ), 0.5 ), 0, 1, ( double ) 1, ( double ) 2 ); 
            double m =  spline( ( double ) this.totalBuy / MaxTrades , 0.38);
            
          //  Print(normalizeLots(l ), normalizeLots(l+(m*l)), " ",m);
          //  ExpertRemove();
            int res = OrderSend( this.symbol, OP_BUY, normalizeLots(l+(m*l*Multiplier)), info.ask, 0, this.info.lowestBuyStoploss, 0, TradeComment, MagicNumber );
            if( res > -1 ){ 
               return OP_BUY;
            }  
         } 
         if(   this.info.ask > this.info.avgSellPrice && this.totalSell > 0 && this.info.bid > this.info.highSell + (sellDist*this.totalSell) ){  
            double l = MathMax( MathMax( AccountBalance() / Divider, 1 ) * Lots, 0.01 );
            
           // double m =  mapValue( spline( mapValue( ( double ) this.totalBuy / 10, ( double ) 1, ( double ) MaxTrades, 0, 1 ), 0.5 ), 0, 1, ( double ) 1, ( double ) 2 ); 
         
            double m =  spline( ( double ) this.totalSell / MaxTrades , 0.38);
            int res = OrderSend( this.symbol, OP_SELL, normalizeLots(l+(m*l*Multiplier)), info.bid, 0, this.info.highestSellStoploss, 0, TradeComment, MagicNumber );
            if( res > -1 ){ 
               return OP_SELL;
            } 
         }
      } 
     
      return -1;
   }
   
   SResult process( SAccount &_account, SInfo &_info ){ 
      SResult res = {};
      this.account = _account;
      this.info = _info; 
      res.manage = manage(); 
      res.send = send(); 
     //  Print(largeLossTicket, " ",largeLoss);  
      return res;
   }
}; 

interface IData {  
   void process( IDisplay *_display );
};

class CData : public IData { 
    
   IDisplay *display;
   SAccount account;
   IBuffer *spread[_Total_Symbols_]; 
   ITrade *trade[_Total_Symbols_]; 
   SInfo info[_Total_Symbols_];  
   IVelocity *velocity[_Total_Symbols_]; 
   
   string suffix;
   int bars,totalUnprotected,totalTrades,totalSignals,chartIndex; 
   uint timeCurrent; 
   bool isTesting ;
   double store[1];
   long barTime;
   
   public:
      CData( 
         bool _isTesting,
         string _suffix 
      ) {  
         this.suffix = _suffix;
         this.isTesting = _isTesting; 
         this.chartIndex = this.symIndex( Symbol() ); 
         for( int i = 0; i < _Total_Symbols_; i++ ) {
            trade[i] = new CTrade( this.suffix, i );
            spread[i] = new CBuffer( _Spread_Array_, 50 );  
            velocity[i] = new CVelocity( 
               i,
              // VelocitySamples,
               MathMax( _VelocitySamples1[i], this.info[i].velocitySamples ),
               this.info[i].bid
            ); 
         }
      }
      ~CData() { 
         for( int i = 0; i < _Total_Symbols_; i++ ) { 
            delete trade[i];
            delete spread[i];  
            delete velocity[i];
         }
      }

   
   double commission( string sym, double pnt ){   
      for( int pos = OrdersHistoryTotal() - 1; pos >= 0; pos-- ) {
         if( OrderSelect( pos, SELECT_BY_POS, MODE_HISTORY ) ) {
            if( OrderProfit() != 0.0 ) {
               if( OrderClosePrice() != OrderOpenPrice() ) {
                  if( OrderSymbol() == sym ) { 
                     double rate = MathAbs( OrderProfit() / MathAbs( OrderClosePrice() - OrderOpenPrice() ) );
                     double commissionPoints = ( -OrderCommission() ) / rate;    
                     return MathMax( commissionPoints, pnt / 10 );
                  }
               }
            }
         }
      }
      return 0;
   }
   
   void prepare(){
      this.account.totalUnprotected = 0;
      this.account.totalTrades = 0;
      this.account.totalOrders = 0;
      this.account.totalSymbols = 0;
      this.timeCurrent = ( uint ) TimeCurrent();
      for( int i = 0; i < _Total_Symbols_; i++ ) {
         if( ( this.isTesting && this.chartIndex == i ) || !this.isTesting )
            info[i] = this.trade[i].prepare();
      }
      for( int i = 0; i < _Total_Symbols_; i++ ) {
         this.account.totalUnprotected += info[i].unprotected;
         this.account.totalTrades += info[i].trades;
         this.account.totalOrders += info[i].orders;
         this.account.totalSymbols += !!info[i].trades;
      }
    //   this.display.append( StringFormat( " totalSymbols: %d, totalTrades: %d, totalUnprotected: %d, totalLoosers: %d \n", 
     //   this.account.totalSymbols, this.account.totalTrades, this.account.totalUnprotected, this.account.totalLoosers ) ); 
      //  this.display.append( StringFormat( " basketProfit: %.2f\n",  this.account.basketProfit ) ) ;
     // this.display.append( StringFormat( " lastBasketAccount: %.2f\n",  this.account.lastBasketAccount ) ) ;
      if( this.isTesting ){
         for( int i = 0; i < _Total_Symbols_; i++ ) {
            if( i == this.chartIndex ){
               string symbol = as_symbol[i] + suffix;
               this.info[i].symbol = as_symbol[i];
               this.info[i].ask = MarketInfo( symbol, MODE_ASK );
               this.info[i].bid = MarketInfo( symbol, MODE_BID );
               this.info[i].point = MarketInfo( symbol, MODE_POINT );
               this.info[i].digits = ( int ) MarketInfo( symbol, MODE_DIGITS );
               this.info[i].marginRequirement = MarketInfo( symbol, MODE_MARGINREQUIRED );
               this.info[i].maxLot = ( double ) MarketInfo( symbol, MODE_MAXLOT );  
               this.info[i].minLot = ( double ) MarketInfo( symbol, MODE_MINLOT );   
               this.info[i].lotStep = MarketInfo( symbol, MODE_LOTSTEP );
               this.velocity[i].processOnTick( ( info[i].ask + info[i].bid ) / 2, this.info[i].velocitySamples );
               this.info[i].velocity =  this.velocity[i].getVelocity();
               //this.info[i].stdDev = this.velocity[i].getStd();
         //      SpreadMeasurements = mapValue( this.info[i].stdDev, 0, MapDeviation * this.info[i].point, _SpreadMeasurementsStart[i], _SpreadMeasurementsEnd[i]);
               double spreadMapStart = _SpreadMap0[i] * this.info[i].point; 
               this.info[i].spread =  MathMax(info[i].ask - info[i].bid,this.info[i].point);
               this.info[i].minMeasure = MathMax( this.info[i].spread, spreadMapStart );
               this.info[i].totalSpread = MathMin( MathMax( this.info[i].spread, this.info[i].minMeasure ), _SpreadMap1[i] * this.info[i].point );
               double spreadMap =  this.info[i].totalSpread / this.info[i].point ;
     
               if( USE_MAP ){ 
                 
                  this.info[i].velocitySamples = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _VelocitySamplesType[i], 1 ), _VelocitySamplesCurve[i] ), _VelocitySamplesType[i], 1, ( double ) _VelocitySamples0[i], ( double ) _VelocitySamples1[i] ); 
         
                  this.info[i].velocitySignal = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _VelocitySignalType[i], 1 ), _VelocitySignalCurve[i] ), _VelocitySignalType[i], 1, ( double ) _VelocitySignal0[i], ( double )_VelocitySignal1[i] ); 
           
                  this.info[i].orderDistance = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _OrderDistanceType[i], 1 ), _OrderDistanceCurve[i] ), _OrderDistanceType[i], 1, ( double ) _OrderDistance0[i], ( double ) _OrderDistance1[i] ); 
          
                  this.info[i].stopLoss = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _StopLossType[i], 1 ), _StopLossCurve[i] ), _StopLossType[i], 1, ( double ) _StopLoss0[i], ( double ) _StopLoss1[i] );  
          
                  this.info[i].trailingGap = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _TrailingGapType[i], 1 ), _TrailingGapCurve[i] ), _TrailingGapType[i], 1, ( double ) _TrailingGap0[i], ( double ) _TrailingGap1[i] ); 
      
                  this.info[i].trailingTarget = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _TrailingTargetType[i], 1 ), _TrailingTargetCurve[i] ), _TrailingTargetType[i], 1, ( double ) _TrailingTarget0[i], ( double ) _TrailingTarget1[i] ); 
               
                  this.info[i].deleteOrder = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _DeleteOrderType[i], 1 ), _DeleteOrderCurve[i] ), _DeleteOrderType[i], 1, ( double ) _DeleteOrder0[i], ( double ) _DeleteOrder1[i] ); 
             
                  this.info[i].deleteTime = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _DeleteTimeType[i], 1 ), _DeleteTimeCurve[i] ), _DeleteTimeType[i], 1, ( double ) _DeleteTime0[i], ( double ) _DeleteTime1[i] );    
                
               } else {
                  this.info[i].velocitySamples = ( int ) _VelocitySamples0[i];
                  this.info[i].velocitySignal = ( int ) _VelocitySignal0[i];
                  this.info[i].orderDistance = ( int ) _OrderDistance0[i];
                  this.info[i].stopLoss = ( int ) _StopLoss0[i]; 
                  this.info[i].trailingGap = ( int ) _TrailingGap0[i];
                  this.info[i].trailingTarget = ( int ) _TrailingTarget0[i];
                  this.info[i].deleteOrder = ( int ) _DeleteOrder0[i];
                  this.info[i].deleteTime = ( int ) _DeleteTime0[i];
               } 
               this.info[i].gapRatio = _GapRatio[i];  
               if( this.info[i].deleteOrder <= this.info[i].orderDistance )
                  this.info[i].deleteOrder = this.info[i].orderDistance + 1;
            } else {
               string symbol = as_symbol[i] + suffix;
            }
         } 
      } else {
         for( int i = 0; i < _Total_Symbols_; i++ ) {
            string symbol = as_symbol[i] + suffix;
            this.info[i].symbol = as_symbol[i];
            this.info[i].ask = MarketInfo( symbol, MODE_ASK );
            this.info[i].bid = MarketInfo( symbol, MODE_BID );
            //this.info[i].point = MarketInfo( symbol, MODE_POINT );
            this.info[i].point = ad_point[i];
            this.info[i].digits = ( int ) MarketInfo( symbol, MODE_DIGITS );
            this.info[i].marginRequirement = MarketInfo( symbol, MODE_MARGINREQUIRED );
            this.info[i].maxLot = ( double ) MarketInfo( symbol, MODE_MAXLOT );  
            this.info[i].minLot = ( double ) MarketInfo( symbol, MODE_MINLOT );   
            this.info[i].lotStep = MarketInfo( symbol, MODE_LOTSTEP );
            this.info[i].rsi = iRSI(symbol,0,14,PRICE_CLOSE,0);
            double thisSpread = info[i].ask - info[i].bid;
            if( MathAbs( this.info[i].lastSpread - thisSpread ) > this.info[i].point / 2 ){
               this.spread[i].appendTo( info[i].ask - info[i].bid ); 
               this.info[i].lastSpread = thisSpread;
            }
            this.velocity[i].processOnTick( ( info[i].ask + info[i].bid ) / 2, this.info[i].velocitySamples ); 
            this.info[i].velocity =  this.velocity[i].getVelocity();
            //this.info[i].stdDev = this.velocity[i].getStd();
           // SpreadMeasurements = mapValue( this.info[i].stdDev, 0, MapDeviation * this.info[i].totalSpread, _SpreadMeasurementsStart[i], _SpreadMeasurementsEnd[i]);
            double spreadMapStart = _SpreadMap0[i] * this.info[i].point; 
            if( this.info[i].commissonPoints < this.info[i].point )
               this.info[i].commissonPoints = this.commission( symbol, this.info[i].point );
            this.info[i].spread = this.spread[i].getMaxBuffer(_Spread_Array_); 
           // this.info[i].spread = this.spread[i].getAvgBuffer(); 
            this.info[i].minMeasure = MathMax( this.info[i].spread + this.info[i].commissonPoints, spreadMapStart );
            this.info[i].totalSpread = MathMin( MathMax( this.info[i].spread + this.info[i].commissonPoints, this.info[i].minMeasure ), _SpreadMap1[i] * this.info[i].point );
            double spreadMap = this.info[i].totalSpread / this.info[i].point;
            double k =  0.24;
            if( USE_MAP ){
               this.info[i].velocitySamples = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _VelocitySamplesType[i], 1 ), _VelocitySamplesCurve[i] ), _VelocitySamplesType[i], 1, ( double ) _VelocitySamples0[i], ( double ) _VelocitySamples1[i] ); 
         
               this.info[i].velocitySignal = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _VelocitySignalType[i], 1 ), _VelocitySignalCurve[i] ), _VelocitySignalType[i], 1, ( double ) _VelocitySignal0[i], ( double )_VelocitySignal1[i] ); 
        
               this.info[i].orderDistance = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _OrderDistanceType[i], 1 ), _OrderDistanceCurve[i] ), _OrderDistanceType[i], 1, ( double ) _OrderDistance0[i], ( double ) _OrderDistance1[i] ); 
       
               this.info[i].stopLoss = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _StopLossType[i], 1 ), _StopLossCurve[i] ), _StopLossType[i], 1, ( double ) _StopLoss0[i], ( double ) _StopLoss1[i] );  
       
               this.info[i].trailingGap = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _TrailingGapType[i], 1 ), _TrailingGapCurve[i] ), _TrailingGapType[i], 1, ( double ) _TrailingGap0[i], ( double ) _TrailingGap1[i] ); 
   
               this.info[i].trailingTarget = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _TrailingTargetType[i], 1 ), _TrailingTargetCurve[i] ), _TrailingTargetType[i], 1, ( double ) _TrailingTarget0[i], ( double ) _TrailingTarget1[i] ); 
            
               this.info[i].deleteOrder = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _DeleteOrderType[i], 1 ), _DeleteOrderCurve[i] ), _DeleteOrderType[i], 1, ( double ) _DeleteOrder0[i], ( double ) _DeleteOrder1[i] ); 
          
               this.info[i].deleteTime = ( int ) mapValue( spline( mapValue( spreadMap, ( double ) _SpreadMap0[i], ( double ) _SpreadMap1[i], _DeleteTimeType[i], 1 ), _DeleteTimeCurve[i] ), _DeleteTimeType[i], 1, ( double ) _DeleteTime0[i], ( double ) _DeleteTime1[i] );    
             
            } else {
               this.info[i].velocitySamples = ( int ) _VelocitySamples0[i];
               this.info[i].velocitySignal = ( int ) _VelocitySignal0[i];
               this.info[i].orderDistance = ( int ) _OrderDistance0[i];
               this.info[i].stopLoss = ( int ) _StopLoss0[i]; 
               this.info[i].trailingGap = ( int ) _TrailingGap0[i];
               this.info[i].trailingTarget = ( int ) _TrailingTarget0[i];
               this.info[i].deleteOrder = ( int ) _DeleteOrder0[i];
               this.info[i].deleteTime = ( int ) _DeleteTime0[i];
            } 
            this.info[i].gapRatio = _GapRatio[i];    
            if( this.info[i].deleteOrder <= this.info[i].orderDistance )
               this.info[i].deleteOrder = this.info[i].orderDistance + 1; 
         } 
      } 
   }
    
   void signal(){  
      this.totalSignals = 0;
      double ad_sort[_Total_Symbols_][2]; 
      if( IsTesting() ) return;
      for( int i = 0; i < _Total_Symbols_; i++ ){   
         double _maxS = spread[i].getMaxBuffer(_Spread_Array_);
         double _mspd = 0;
         int spdi = _SpreadMap1[i];
         if( !USE_OPT ){
            spdi = MaxSpread;
         } 
         if( _maxS <= ( spdi * this.info[i].point ) + ( this.info[i].point / 2 ) )
            _mspd = 1;
          double _sym = 0;
          if( StringFind( Symbols, this.info[i].symbol ) > -1 )
            _sym = 1;  
         double _trds = 1;
         if( info[i].trades > 0 )
            _trds = 0;
            
         double _rsi = MathAbs(50-this.info[i].rsi);
       
            
         double _vs = MathAbs(velocity[i].getVelocity()) / this.info[i].point;
         ad_sort[i][0] =   _trds * _mspd * _sym * _rsi / MathMax( _maxS, this.info[i].point );
         ad_sort[i][1] = i; 
      }  
      
      ArraySort( ad_sort, WHOLE_ARRAY, 0, MODE_DESCEND );
       
      if( this.isTesting ){  
         for( int i = 0; i < _Total_Symbols_; i++ )  {
            int _i = ( int ) ad_sort[i][1];
            this.info[_i].signal = i < MaxSignals && ad_sort[i][0] > 0;
            this.totalSignals += !!ad_sort[i][0];     
         } 
      } else {  
         for( int i = 0; i < _Total_Symbols_; i++ )  {
            int _i = ( int ) ad_sort[i][1];
            this.info[_i].signal = i < MaxSignals && ad_sort[i][0] > 0;
            this.totalSignals += !!ad_sort[i][0];  
             if( this.info[_i].signal > 0)
              this.display.append( StringFormat( " %s V:%.d S:%d\n", 
                as_symbol[_i], ( int ) ( velocity[_i].getVelocity() / this.info[_i].point  ),( int ) ( spread[_i].getMaxBuffer(this.info[_i].velocitySamples) / this.info[_i].point  ) ) ); 
         }  
      } 
   }
   
   int symIndex( string sym ){
      for( int i = 0; i < _Total_Symbols_; i++ )  {
         if( StringSubstr( sym, 0, 6 ) == as_symbol[i] ){
            return i;
         }
      }
      return -1;
   }
   
   void action(){   
    
  
      for( int i = 0; i < _Total_Symbols_; i++ ) { 
         if( ( this.isTesting && this.chartIndex == i ) || !this.isTesting ){
            SResult res = this.trade[i].process( account, info[i] ); // manage needs it own action  
            if( res.send > -1 ){ 
               return;
            }
         }
      }  
   } 
   
   void history(){ 
      int count = 0;
      if( OrdersHistoryTotal() > this.account.lastHistoryTotal ){
         this.account.basketProfit = 0.0; 
         this.account.lastHistoryTotal = OrdersHistoryTotal();
         for( int pos = OrdersHistoryTotal() - 1; pos >= 0; pos-- ){
            if( OrderSelect( pos, SELECT_BY_POS, MODE_HISTORY ) ) {  
               //if( OrderType() != OP_BUY || OrderType() != OP_SELL ) continue;
               double orderProfit = OrderProfit() + OrderSwap() + OrderCommission();   
               if( orderProfit != 0.0 ){ 
                if( count > HistoryTrades ) break;
              // if( ( uint ) OrderCloseTime() > this.account.basketTime + 1 )
                  //if( OrderType() == OP_BUY || OrderType() == OP_SELL )
               this.account.basketProfit += orderProfit; 
              // if( ( uint ) OrderCloseTime() <= this.account.basketTime + 1 ) break;
                
                  count++;
              // if( orderProfit != 0.0 )
           /*   if(OrderTicket()>lastHistId){
                 sendHistory(OrderTicket(),AccountNumber(),OrderSymbol(),OrderLots(),OrderType(),orderProfit,TimeToStr(OrderCloseTime(),TIME_DATE|TIME_SECONDS));
               lastHistId=OrderTicket();
            }*/
               }
            }
         } 
      }
      //  this.display.append( StringFormat( " targetProfit: %.2f \n", this.account.targetProfit ) );   
       this.display.append( StringFormat( " basketProfit: %.2f \n", this.account.basketProfit ) ); 
       this.display.append( StringFormat( " largeLossTicket: %d \n", largeLossTicket ) ); 
       
   
   }
   
   void process( IDisplay *_display ){ 
     this.display = _display;
     tradeJson="";
     this.display.reset(); 
       largeLoss=0;
      largeLossTicket=0;
      this.prepare();  
      this.signal(); 
      this.action();
       this.history();
     tradeJson = StringSubstr( tradeJson, 0, StringLen(tradeJson)-1);
      
        make_request( AccountBalance(), AccountEquity(), AccountProfit(),tradeJson );
        display.comment();
   } 
   
}; 
int lastHistId=0;
interface IProcess {  
   void ticker();
   void timer();
   void ini();
};

class CProcess : public IProcess { 
   IDisplay *display;
   IData *data;
   bool isTesting;
   string symbol, suffix;
   
   public: 
      CProcess( 
         
      ) { 
         this.display = new CDisplay();
      }
      ~CProcess() { 
         EventKillTimer();
         delete data;
         delete display;
      }  
   
   void ini(){
   
      isTesting = IsTesting();
      symbol = Symbol();
      suffix = symbol;
      StringReplace( suffix, StringSubstr( symbol, 0, 6 ), "" );
     
      if( !isTesting )
         EventSetMillisecondTimer( _Timer_Milliseconds_ );
         
      data = new CData( isTesting, suffix );
   }
   
   void ticker(){ 
      if( this.isTesting )
         data.process( this.display );
   }
   
   void timer(){
      if( !this.isTesting )
         data.process( this.display );
         
      
   }
};

IProcess *process;


 
int OnInit(){
   setInputs();
   process = new CProcess();
   process.ini();
  // initTime = (uint) TimeCurrent();
  initMT4();
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){ 
   delete process;
}

void OnTick(){ 
   process.ticker();
}

void OnTimer(){
   process.timer();
   
}
/*
void OnChartEvent( 
      const int id,
      const long &lparam,
      const double &dparam,
      const string &sparam
   ){ 
   if( id == CHARTEVENT_OBJECT_CLICK ) {
      if( sparam == "ResetBasket" ) process.resetBasket();
   }
} 
*/
/*
double OnTester(){ 
   if( ( double ) TesterStatistics( STAT_PROFIT ) > 100 && TesterStatistics( STAT_TRADES ) > 50 ){  
      char post[],char_result[];
      string cookie = NULL, headers; 
      int res; 
    
      string params1 = StringConcatenate(   
         
         "GapRatio=", DoubleToStr( GapRatio, 2 ), ";"
         
      );
      string params2 = StringConcatenate(   
         params1,  
         "SpreadMap=", ( int ) DoubleToStr( ( Ask - Bid ) / Point, 0 ), ";", 
         "VelocitySamples=", ( int ) DoubleToStr( VelocitySamples, 1 ), ";", 
         "VelocitySignal=", ( int ) DoubleToStr( VelocitySignal, 1 ), ";", 
         "OrderDistance=", ( int ) DoubleToStr( OrderDistance, 1 ), ";", 
         "StopLoss=", ( int ) DoubleToStr( StopLoss, 1 ), ";",  
         "TrailingGap=",( int ) DoubleToStr( TrailingGap, 1 ), ";", 
         "TrailingTarget=", ( int ) DoubleToStr( TrailingTarget, 1 ), ";", 
         "DeleteOrder=", ( int ) DoubleToStr( DeleteOrder, 1 ), ";", 
         "DeleteTime=", ( int ) DoubleToStr( DeleteTime, 1 ), ";"
      ); 
   
      string url = StringConcatenate( "http://localhost/sohigh/index.php?symbol=", 
         Symbol(),  
         "&spread=", DoubleToStr( ( Ask - Bid ) / Point, 0 ),  
         "&profit=", TesterStatistics( STAT_PROFIT ), 
         "&trades=", TesterStatistics( STAT_TRADES ), 
         "&pf=", TesterStatistics( STAT_PROFIT_FACTOR ), 
         "&ep=", TesterStatistics( STAT_EXPECTED_PAYOFF ),  
         "&drawdown=", TesterStatistics( STAT_EQUITY_DDREL_PERCENT ),  
         "&inputs=", params2 );  
      ResetLastError(); 
      int timeout = 5000; 
      res = WebRequest( "GET", url, cookie, NULL, timeout, post, 0, char_result, headers ); 
      return 1;
   }
   return ( 0); 
}
*/

void sendHistory(int ticket, int account, string symbol, double size, int type, double profit, string closed){
 
   char post[],char_result[];
      string cookie = NULL, headers; 
      int res; 
   string url = StringConcatenate( "http://localhost/history.php?symbol=", 
         symbol,  
         
         "&ticket=", ticket,  
         "&account=", account, 
         "&size=", size, 
         "&type=", type, 
         "&profit=", profit,  
         "&closed=", closed );  
      ResetLastError(); 
      int timeout = 5000; 
      res = WebRequest( "GET", url, cookie, NULL, timeout, post, 0, char_result, headers ); 
       
}

double initMT4(){
   string reqest = StringConcatenate("{\"type\":\"",4,"\",\"account\":\"",AccountNumber(),"\",\"ivinvest_id\":\"",IvInvest,"\"}");
   string response = "";
   //Make the connection
   
   
   
	if(!INet.Open(WebHost,WebPort)) return(0);
	if(!INet.Request("POST","/confirmations",response,false, true, reqest, false))
	{
		return(0);
	}
	Print(WebHost,"-:",response);
	return 1;
}


  string lastReq = "";
  string lastRes = "";
  uint lastSend ;
  int lastTime;
 double make_request( double balance, double equity, double profit, string trades )
{
   return 1;
	//Create the client request. This is in JSON format but you can send any string
	string reqest = StringConcatenate("{\"balance\":\"",balance,"\",\"equity\":\"",equity,"\",\"profit\":\"",profit,"\",\"trades\":[",trades,"]}");
	 
	if( lastReq != reqest || (uint)TimeCurrent() - lastSend > 1 ){
	lastSend = (uint)TimeCurrent();
	lastReq=reqest; 
	//Create the response string
	string response = "";
	
	//Make the connection
	if(!INet.Open(hostIp,hostPort)) return(0);
	if(!INet.Request("POST","/",response,false, true, reqest, false))
	{
		//printDebug("-Err download ");
		return(0);
	}
	
	double calculated_value = 0; //To store the calculated value from the server
	
	//The response string should now contain the response that the Node.js server gave with the data that we need
	if (response != "") // If the respone isn't empty
	{ 
	   if( response != lastRes && ( int ) TimeCurrent() - lastTime > 0 ){
	      lastRes = response;
	      lastTime=(int)TimeCurrent();
	    
	   }
	   
		//JSONParser *parser = new JSONParser(); //Since the response is a JSON object, let's parse it
		//JSONValue *jv = parser.parse(response); 
		//If the object looks good
		//if (jv == NULL) {
			//printDebug("error:"+(string)parser.getErrorCode()+parser.getErrorMessage());
		//} else { 
			//JSONObject *jo = jv; 
			//calculated_value = jo.getDouble("value");

		//}
		
		//delete parser;
	
	}
	
	return (calculated_value); // Return the value
	
	} else return 0;

}