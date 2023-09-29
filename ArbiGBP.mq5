//+------------------------------------------------------------------+
//|                                                   OrangHedge.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"


#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
CPositionInfo  inf;                   // trade position object
CTrade         trade;                      // trading object

double temp_targetBuy;
double temp_targetSell;
double temp_targetBuyR;
double temp_targetSellR;

input int Spre=4; //Don't get Position When Spread Bigger than this...

//input ENUM_ORDER_TYPE start_order_type=ORDER_TYPE_BUY;//START ORDER TYPE
input string pair_1="EURUSD";
input string pair_2="EURGBP";
input string pair_3="GBPUSD";
input string BigSpread="pair_1";//SET Biggest Spread between pair_1 or pair_2 or pair_3 or pair_4
input int FromHour=22;
input int ToHour=2;
double ED=1;
input double start_lot=0.1;//START LOT
input double lot_win=0.00152;//Save pip in opening Arbitrage's position
input int profit_win=22;//Profit pip in Close
input int brake=5;//number of step

int Pomax=1;//Max LOT Start
int Pomin=1;//Max LOT Start
int Potemp1=0;
int Potemp2=0;
int Potemp=0;
int Van1=0;
int To2=0;
int Tree3=0;
int For4=0;
datetime time=0;
input string my_comment1="MainBuy";//COMMENT1
input string my_comment2="MainSell";//COMMENT2
input string my_comment3="HelperB";//MAIN COMMENT
input string my_comment4="HelperS";//MAIN COMMENT
input string my_comment5="HelperB1";//MAIN COMMENT
input string my_comment6="HelperS1";//MAIN COMMENT
input int order_magic=5556;//Enter OrderMagic
int Maj=0;
int orders_counter=0;
int StepVisit=0;
int Stp=0;
int phase_Buy=0;
int phase_Sell=0;
double  equity_firstBuy;
double profit1=0;
double TempProfit1=0;
double equity_first1;
double profit2=0;
double TempProfit2=0;
double profit3=0;
double TempProfit3=0;
double profit4=0;
double TempProfit4=0;
double equity_first2;
double PriceB=0;
double PriceS=0;
double Price3=0;
double Price4=0;
double Price5=0;
double Price6=0;
double Price7=0;
double Price8=0;
double Price9=0;
double Price10=0;
double Price11=0;
double Price12=0;
double  equity_max;
double  equity_min;
string pair_swap;
int CnT;
int tim=0;
int ptim=0;
int pipB=0;
int pipS=0;
int pip3=0;
int RS=50;
int RS2=50;
int RS3=50;
int Dey=0;
double rsi[];
int b0=1;
int b1=1;
int b2=2;
int b3=1;
int b4=1;

int bt=0;
int b=0;
int s0=1;
int s1=1;
int s2=2;
int s3=1;
int s4=1;

int st=0;
int s=0;
int btemp=1;
int stemp=1;
double corre1=0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//---
  
Print("GBPUSD INITIALIZING!.");

  equity_firstBuy=AccountInfoDouble(ACCOUNT_EQUITY);
  equity_max=AccountInfoDouble(ACCOUNT_EQUITY);
  equity_min=AccountInfoDouble(ACCOUNT_EQUITY);

  PriceB=SymbolInfoDouble(pair_1,SYMBOL_BID);
  PriceS=SymbolInfoDouble(pair_1,SYMBOL_BID);
  Maj=order_magic;

  
     RS = iRSI(
              pair_1,            // symbol name
              PERIOD_H4,      // period
              3,                  // averaging period
              PRICE_CLOSE          // price type or handle
              );
      RS2 = iRSI(
              pair_2,            // symbol name
              PERIOD_M1,      // period
              10,                  // averaging period
              PRICE_CLOSE          // price type or handle
              ); 
      RS3 = iRSI(
              pair_3,            // symbol name
              PERIOD_M1,      // period
              10,                  // averaging period
              PRICE_CLOSE          // price type or handle
              ); 
   

   Print("GBPUSD INITIALIZED!.");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
   //--- make sure that the account is demo
//if(AccountInfoInteger(ACCOUNT_TRADE_MODE)==ACCOUNT_TRADE_MODE_REAL)
//{
//Alert("Script operation is not allowed on a live account!");
//return;
//} 
   MqlTradeRequest request1={};
   MqlTradeResult  result1={0};
   MqlTradeRequest request2={};
   MqlTradeResult  result2={0};
   MqlTradeRequest request3={};
   MqlTradeResult  result3={0};
   MqlTradeRequest request4={};
   MqlTradeResult  result4={0};
   MqlTradeRequest request5={};
   MqlTradeResult  result5={0};
   MqlTradeRequest request6={};
   MqlTradeResult  result6={0};   
   MqlTradeRequest request7={};
   MqlTradeResult  result7={0};
   MqlTradeRequest request8={};
   MqlTradeResult  result8={0};  
   datetime tm=TimeCurrent();
   MqlDateTime T;
   TimeToStruct(tm,T);
   ArraySetAsSeries(rsi, true);   

  if (CopyBuffer(RS,0,0,20,rsi) < 0){Print("CopyBufferRSI error =",GetLastError());}

if(T.hour==FromHour&&T.min<2)
  {
   Dey=0;
   ptim=0;
   }
 
if(T.hour>=ToHour&&T.hour<=FromHour&&(SymbolInfoDouble(pair_1,SYMBOL_ASK))<=(SymbolInfoDouble(pair_2,SYMBOL_BID)*(SymbolInfoDouble(pair_3,SYMBOL_BID))-lot_win)&&b==0&&b0<=brake)
   {
   tim=2; 
   ptim=T.hour; 
   pipB=0;
   b=1;

      //EURUSD 
       request1.action = TRADE_ACTION_DEAL;
       request1.type=ORDER_TYPE_BUY;
       request1.symbol=pair_1;
       request1.magic=Maj;
       request1.volume=(MathRound(100*Pomax*start_lot))/100;
       request1.deviation=50;
       request1.price=SymbolInfoDouble(pair_1,SYMBOL_ASK);
       request1.comment=my_comment1;
//     request1.sl=request1.price-(0.0001*(step_eurusd));
  
      OrderSend(request1,result1);   


      //EURUSD 
       request2.action = TRADE_ACTION_DEAL;
       request2.type=ORDER_TYPE_SELL;
       request2.symbol=pair_2;
       request2.magic=Maj;
       request2.volume=(MathRound(100*Pomax*start_lot))/100;
       request2.deviation=50;
       request2.price=SymbolInfoDouble(pair_2,SYMBOL_BID);
       request2.comment=my_comment1;
//     request2.sl=request1.price-(0.0001*(step_eurusd));
  
      OrderSend(request2,result2);
   
      //USDJPY 
       request3.action = TRADE_ACTION_DEAL;
       request3.type=ORDER_TYPE_SELL;       
       request3.symbol=pair_3;
       request3.magic=Maj;
       request3.volume=(MathRound(100*SymbolInfoDouble(pair_2,SYMBOL_BID)*Pomax*start_lot))/100;
       request3.deviation=50;
       request3.price=SymbolInfoDouble(pair_3,SYMBOL_BID);
       request3.comment=my_comment1;
    // request1.sl=request1.price-(0.0001*(step_eurusd));
  
      OrderSend(request3,result3);   


      time=TimeCurrent()+1000;         
      PriceB=SymbolInfoDouble(pair_1,SYMBOL_BID); 
      b0=b0+1;  
   }
 



 if(time<=TimeCurrent()+1000)
      
      { 
          profit1=0;
          TempProfit1=0;
          profit2=0;
          TempProfit2=0;
          profit3=0;
          TempProfit3=0;
          profit4=0;
          TempProfit4=0;
          
      
       CnT=PositionsTotal()-1;


        while(CnT>=0)
         
          {

          inf.SelectByIndex(CnT);
           
               

           if(string(inf.Comment())==my_comment1) 
            {
             TempProfit1= inf.Profit()+inf.Swap()+inf.Commission();
             profit1=profit1+TempProfit1;
            }
            
           if(string(inf.Comment())==my_comment2) 
            {
             TempProfit2= inf.Profit()+inf.Swap()+inf.Commission();
             profit2=profit2+TempProfit2;
            }
           
           
           CnT--;
          } 
        b=0;
        s=0;  
        time=TimeCurrent()+1000;
                  
       }





if(T.hour>=ToHour&&T.hour<=FromHour&&(SymbolInfoDouble(pair_1,SYMBOL_BID))>=(SymbolInfoDouble(pair_2,SYMBOL_BID)*(SymbolInfoDouble(pair_3,SYMBOL_BID))+lot_win)&&s==0&&s0<=brake)
   {
   tim=2;  
   ptim=T.hour;
   pipS=0;
   s=1;

      //EURSEK 
       request4.action = TRADE_ACTION_DEAL;
       request4.type=ORDER_TYPE_SELL;
       request4.symbol=pair_1;
       request4.magic=Maj;
       request4.volume=(MathRound(100*Pomax*start_lot))/100;
       request4.deviation=50;
       request4.price=SymbolInfoDouble(pair_1,SYMBOL_BID);
       request4.comment=my_comment2;
//     request1.sl=request1.price-(0.0001*(step_eurusd));
  
      OrderSend(request4,result4);   


      //EURNOK 
       request5.action = TRADE_ACTION_DEAL;
       request5.type=ORDER_TYPE_BUY;
       request5.symbol=pair_2;
       request5.magic=Maj;
       request5.volume=(MathRound(100*Pomax*start_lot))/100;
       request5.deviation=50;
       request5.price=SymbolInfoDouble(pair_2,SYMBOL_ASK);
       request5.comment=my_comment2;
//     request1.sl=request1.price-(0.0001*(step_eurusd));
  
      OrderSend(request5,result5);
   
      //NOKSEK 
       request6.action = TRADE_ACTION_DEAL;
       request6.type=ORDER_TYPE_BUY;       
       request6.symbol=pair_3;
       request6.magic=Maj;
       request6.volume=(MathRound(100*SymbolInfoDouble(pair_2,SYMBOL_BID)*Pomax*start_lot))/100;
       request6.deviation=50;
       request6.price=SymbolInfoDouble(pair_3,SYMBOL_ASK);
       request6.comment=my_comment2;
    // request1.sl=request1.price-(0.0001*(step_eurusd));
  
      OrderSend(request6,result6);   
      
      

      time=TimeCurrent()+1000;
      PriceS=SymbolInfoDouble(pair_1,SYMBOL_BID); 
      s0=s0+1;     
   
   }
 
   
   pipB=(SymbolInfoDouble(pair_1,SYMBOL_BID)-PriceB)  ;   
   pipS=(SymbolInfoDouble(pair_1,SYMBOL_BID)-PriceS)  ; 








if((profit1)>=(profit_win*start_lot))
   
   {

    CnT=PositionsTotal()-1;


        while(CnT>=0)
         
          {

          inf.SelectByIndex(CnT);
           
               

           if(string(inf.Comment())==my_comment1) 
            {
             trade.PositionClose(PositionGetTicket(CnT),50) ;
             Print("CloseProfitAll");
            }
           
           CnT--;
          }  
       phase_Buy=0;
       phase_Sell=0;
       b=0;
       s=0;
       b0=1;  
       b1=1;
       s1=1;
       b2=2;
       s2=2;
       b3=1;
       s3=1;
       b4=1;
       s4=1;
       bt=0;
       st=0;
       tim=0;
       ptim=0;
       btemp=1;
       stemp=1;
       Dey=0;
       equity_max=AccountInfoDouble(ACCOUNT_EQUITY);
       TempProfit1=0;
       profit1=0;
       TempProfit2=0;
       profit2=0;
       TempProfit3=0;
       profit3=0;
       TempProfit4=0;
       profit4=0;       
       PriceB=0;
       PriceS=0;
       pipB=0;
       pipS=0;
       Van1=0;
       To2=0;
       Tree3=0;
       For4=0;
   } 



if((profit2)>=(profit_win*start_lot))
   
   {

    CnT=PositionsTotal()-1;


        while(CnT>=0)
         
          {

          inf.SelectByIndex(CnT);
           
               

           if(string(inf.Comment())==my_comment2) 
            {
             trade.PositionClose(PositionGetTicket(CnT),50) ;
             Print("CloseProfitAll");
            }
           
           CnT--;
          }  
       phase_Buy=0;
       phase_Sell=0;
       b=0;
       s=0;
       s0=1;       
       b1=1;
       s1=1;
       b2=2;
       s2=2;
       b3=1;
       s3=1;
       b4=1;
       s4=1;
       bt=0;
       st=0;
       tim=0;
       ptim=0;
       btemp=1;
       stemp=1;
       Dey=0;
       equity_max=AccountInfoDouble(ACCOUNT_EQUITY);
       TempProfit1=0;
       profit1=0;
       TempProfit2=0;
       profit2=0;
       TempProfit3=0;
       profit3=0;
       TempProfit4=0;
       profit4=0;       
       PriceB=0;
       PriceS=0;
       pipB=0;
       pipS=0;
       Van1=0;
       To2=0;
       Tree3=0;
       For4=0;
   }        
             
       


    
if((AccountInfoDouble(ACCOUNT_EQUITY)>=(profit_win*start_lot)+equity_max+8))
   
   {

    CnT=PositionsTotal()-1;


        while(CnT>=0)
         
          {

          inf.SelectByIndex(CnT);
           
               

           if(string(inf.Comment())==my_comment1||string(inf.Comment())==my_comment2) 
            {
             trade.PositionClose(PositionGetTicket(CnT),50) ;
             Print("CloseProfitAll");
            }
           
           CnT--;
          }  
       phase_Buy=0;
       phase_Sell=0;
       b=0;
       s=0;
       b0=1;
       s0=1;       
       b1=1;
       s1=1;
       b2=2;
       s2=2;
       b3=1;
       s3=1;
       b4=1;
       s4=1;
       bt=0;
       st=0;
       tim=0;
       ptim=0;
       btemp=1;
       stemp=1;
       Dey=0;
       equity_max=AccountInfoDouble(ACCOUNT_EQUITY);
       TempProfit1=0;
       profit1=0;
       TempProfit2=0;
       profit2=0;
       TempProfit3=0;
       profit3=0;
       TempProfit4=0;
       profit4=0;       
       PriceB=0;
       PriceS=0;
       pipB=0;
       pipS=0;
       Van1=0;
       To2=0;
       Tree3=0;
       For4=0;
   } 

   

   
   

   Comment(T.hour  ,"      ",TimeGMT(),"\n",(MathRound(100*profit1))/100,"\n",(MathRound(100*profit2))/100,"\n",
  "Total=",PositionsTotal(),"\n","MaxEquity_Last=",equity_max,"\n","MinEquity_Last=",equity_min,"\n","Eqity=",AccountInfoDouble(ACCOUNT_EQUITY)
  ,"\n",1000*(SymbolInfoDouble(pair_1,SYMBOL_ASK)-SymbolInfoDouble(pair_1,SYMBOL_BID)),"       ",Spre,"\n",
  "pipB=",pipB,"\n","pipS=",pipS,"\n","S1=",s1,"\n","B1=",b1,"\n","PriceB=",PriceB,"\n","PriceS=",PriceS,"\n",
  "STEPVisit=",orders_counter,"\n","Dey=",Dey,"\n","PoTime=",ptim);


  
 }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
