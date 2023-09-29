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



double Start=0;
double Up=0;
double Down=0;



//input ENUM_ORDER_TYPE start_order_type=ORDER_TYPE_BUY;//START ORDER TYPE
input string pair_1="BTCUSD";
input string BigSpread="pair_1";//SET Biggest Spread between pair_1 or pair_2 or pair_3 or pair_4
input int STOPPERCENT=70;//LOSS in EquityPercent To Close All SYSTEM
double ED=1;
input double start_lot=0.01;//START LOT
input double BITCOIN_STEP=50;
input int Trailer=400;
double lot_find=0;
double sp=0;
int Potemp1=0;
int Potemp2=0;
int Potemp=0;
int Van1=0;
int To2=0;
int Tree3=0;
int For4=0;
datetime time=0;
input int order_magic=5555;//Enter OrderMagic
int MajB=0;
int MajS=0;
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
ulong TicketB=0;
ulong TicketS=0;
double  equity_max;
double  equity_min;
double spread;
string pair_swap;
int CnT;
int tim=0;
int Tk=0;
int ptim=0;
int pipB=0;
int pipS=0;
int pip3=0;
int RS=50;
int RS2=50;
int RS3=50;
int Deyb=0;
int Deys=0;
double rsi[];
int b0=0;
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
int PosB=0;
int PosS=0;
double corre1=0;
double TPB=0;
double TPS=0;
double TrailBuy=0;
double TrailSell=0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//---

   Print("BTC INITIALIZING!.");

   equity_firstBuy=AccountInfoDouble(ACCOUNT_EQUITY);
   equity_max=AccountInfoDouble(ACCOUNT_EQUITY);
   equity_min=AccountInfoDouble(ACCOUNT_EQUITY);

   PriceB=1;
   PriceS=1000000;
   MajB=order_magic;
   MajS=order_magic+1000;




   Print("BTC INITIALIZED!.");
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
   MqlTradeRequest request1= {};
   MqlTradeResult  result1= {};
   MqlTradeRequest request2= {};
   MqlTradeResult  result2= {};

   datetime tm=TimeCurrent();
   MqlDateTime T;
   TimeToStruct(tm,T);



   double myRSIArray[];

   int myRSIDefinition = iRSI(pair_1,PERIOD_H8,9,PRICE_CLOSE);

   ArraySetAsSeries(myRSIArray,true);

   CopyBuffer(myRSIDefinition,0,0,3,myRSIArray);

   double myRSIValue=NormalizeDouble(myRSIArray[0],2);




   if(b==0 ||Down>=(SymbolInfoDouble(pair_1,SYMBOL_ASK))||Up<=(SymbolInfoDouble(pair_1,SYMBOL_BID)))
     {

      tim=2;
      ptim=T.hour+5;
      pipB=0;
      //      Sleep(60000);



      MqlTradeRequest request1= {};
      MqlTradeResult  result1= {};
      MqlTradeRequest request2= {};
      MqlTradeResult  result2= {};





      if(b==0)
        {

         b=1;
         Start=(SymbolInfoDouble(pair_1,SYMBOL_BID));
         request1.action = TRADE_ACTION_DEAL;
         request1.type=ORDER_TYPE_BUY;
         request1.type_filling=ORDER_FILLING_IOC;
         request1.symbol=pair_1;
         request1.magic=MajB;
         request1.volume=(MathRound(100*start_lot))/100;
         request1.deviation=9999;
         request1.price=SymbolInfoDouble(pair_1,SYMBOL_ASK);
         Up=SymbolInfoDouble(pair_1,SYMBOL_BID)+BITCOIN_STEP;
         request1.comment="BTCb";
         OrderSend(request1,result1);


         //Sell

         request2.action = TRADE_ACTION_DEAL;
         request2.type=ORDER_TYPE_SELL;
         request2.type_filling=ORDER_FILLING_IOC;
         request2.symbol=pair_1;
         request2.magic=MajS;
         request2.volume=(MathRound(100*start_lot))/100;
         request2.deviation=9999;
         request2.price=SymbolInfoDouble(pair_1,SYMBOL_BID);
         Down=SymbolInfoDouble(pair_1,SYMBOL_ASK)-BITCOIN_STEP;
         request2.comment="BTCs";
         OrderSend(request2,result2);
        }

      if(Up<=(SymbolInfoDouble(pair_1,SYMBOL_BID)))
        {
         Up=SymbolInfoDouble(pair_1,SYMBOL_BID)+BITCOIN_STEP;

         request1.action = TRADE_ACTION_DEAL;
         request1.type=ORDER_TYPE_BUY;
         request1.type_filling=ORDER_FILLING_IOC;
         request1.symbol=pair_1;
         request1.magic=MajB;
         request1.volume=(MathRound(100*start_lot))/100;
         request1.deviation=9999;
         request1.price=SymbolInfoDouble(pair_1,SYMBOL_ASK);
         request1.comment="BTCb";
         OrderSend(request1,result1);

         if(Up>Start+2.8*BITCOIN_STEP)
           {
            request2.action = TRADE_ACTION_PENDING;
            request2.type=ORDER_TYPE_SELL_STOP;
            request2.symbol=pair_1;
            request2.magic=MajS;
            request2.volume=(MathRound(100*start_lot))/100;
            request2.price=SymbolInfoDouble(pair_1,SYMBOL_ASK)-BITCOIN_STEP;
            request2.comment="BTCs";
            OrderSend(request2,result2);
           }



        }

      if(Down>=(SymbolInfoDouble(pair_1,SYMBOL_BID)))
        {
         Down=SymbolInfoDouble(pair_1,SYMBOL_BID)-BITCOIN_STEP;

         request2.action = TRADE_ACTION_DEAL;
         request2.type=ORDER_TYPE_SELL;
         request2.type_filling=ORDER_FILLING_IOC;
         request2.symbol=pair_1;
         request2.magic=MajS;
         request2.volume=(MathRound(100*start_lot))/100;
         request2.deviation=9999;
         request2.price=SymbolInfoDouble(pair_1,SYMBOL_BID);
         request2.comment="BTCb";
         OrderSend(request2,result2);

         if(Down<Start-2.8*BITCOIN_STEP)
           {
            request1.action = TRADE_ACTION_PENDING;
            request1.type=ORDER_TYPE_BUY_STOP;
            request1.symbol=pair_1;
            request1.magic=MajB;
            request1.volume=(MathRound(100*start_lot))/100;
            request1.price=SymbolInfoDouble(pair_1,SYMBOL_BID)+BITCOIN_STEP;
            request1.comment="BTCs";
            OrderSend(request1,result1);
           }



        }





      CnT=PositionsTotal()-1;
      TicketB=PositionGetTicket(CnT-1);
      TicketS=PositionGetTicket(CnT);

      time=TimeCurrent()+10;

     }

   if(time<=TimeCurrent())

     {
      profit1=0;
      TempProfit1=0;
      profit2=0;
      TempProfit2=0;
      PosB=0;
      PosS=0;

      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);



         if(string(inf.Magic())==MajB)
           {
            TempProfit1= inf.Profit()+inf.Swap()+inf.Commission();
            profit1=profit1+TempProfit1;
            PosB=PosB+1;
           }

         if(string(inf.Magic())==MajS)
           {
            TempProfit2= inf.Profit()+inf.Swap()+inf.Commission();
            profit2=profit2+TempProfit2;
            PosS=PosS+1;
           }


         CnT--;
        }

      time=TimeCurrent()+500;

     }


      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);



         if(string(inf.Magic())==MajB)
           {

            if(inf.Profit()>(2.5+b)*BITCOIN_STEP*start_lot && PosB>PosS)
              {
               b=b+1;
               trade.PositionClose(PositionGetTicket(CnT),50);
              }
           }

         if(string(inf.Magic())==MajS)
           {

            if(inf.Profit()>(3.5+s)*BITCOIN_STEP*start_lot && PosS>PosB)
              {
               s=s+1;
               trade.PositionClose(PositionGetTicket(CnT),50);
              }
           }


         CnT--;
        }





   if((AccountInfoDouble(ACCOUNT_EQUITY)>=(equity_max+(2500*start_lot))))

     {

      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);



         if((inf.Magic())==MajB||(inf.Magic())==MajS)
           {

            trade.OrderDelete(OrderGetTicket(CnT));
            trade.PositionClose(PositionGetTicket(CnT),50) ;



            Print("CloseProfitAll");
           }

         CnT--;
        }
      PosB=0;
      PosS=0;
      Start=0;
      Up=0;
      Down=0;
      phase_Sell=0;
      b=0;
      Tk=0;
      s=0;
      b0=0;
      s0=0;
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
      Deyb=0;
      Deys=0;
      equity_max=AccountInfoDouble(ACCOUNT_EQUITY);
      equity_min=AccountInfoDouble(ACCOUNT_EQUITY);
      TempProfit1=0;
      profit1=0;
      TempProfit2=0;
      profit2=0;
      TempProfit3=0;
      profit3=0;
      TempProfit4=0;
      profit4=0;
      PriceB=1;
      PriceS=1000000;
      pipB=0;
      pipS=0;
      Van1=0;
      To2=0;
      Tree3=0;
      For4=0;
      sp=0;
      TPB=0;
      TPS=0;
      TrailBuy=0;
      TrailSell=0;
      PriceB=0;
      PriceS=0;
      TicketB=0;
      TicketS=0;

     }




   if(AccountInfoDouble(ACCOUNT_EQUITY)<equity_max-(STOPPERCENT*equity_max/100))

     {

      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);



         if((inf.Magic())==MajB||(inf.Magic())==MajS)
           {
            trade.PositionClose(PositionGetTicket(CnT),50) ;
           }


         CnT--;
        }

      b=100;
     }








   Comment(((b+s)%2),"\n",T.hour,"      ",TimeGMT(),"\n",(MathRound(100*profit1))/100,"\n",(MathRound(100*profit2))/100,"\n",
           "Total=",PositionsTotal(),"\n","MaxEquity_Last=",equity_max,"\n","MinEquity_Last=",equity_min,"\n","Eqity=",AccountInfoDouble(ACCOUNT_EQUITY)
           ,"\n","       ",BITCOIN_STEP,"\n","Buys_Equity=",profit1,"\n","Sell_Equity=",profit2,"\n","RSI=",myRSIValue,"\n",
           "b=",b,"\n","s=",s,"\n","Start=",Start,"\n","UP=",Up,"\n","DOWN=",Down,"\n","PosB=",PosB,"\n","POsS=",PosS,"\n"
           "SPREAD=",sp,"\n","TicketB=",TicketB,"\n","TicketS=",TicketS);



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

//+------------------------------------------------------------------+
