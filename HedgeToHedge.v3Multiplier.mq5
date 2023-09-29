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



input string pair_1="EURUSD";
input string pair_2="USDJPY";
input string pair_3="EURJPY";

double ED=1;
input double start_lot=0.01;//START LOT
input int MaxProfit=80;//Pip Profit
input int MinProfit=70;//Pip Loss
input int TotProfit=200;//ProfitForCloseAll in Dollar
input double PosMult=1;//Multiplier For Positive position
input double NegMult=1;//Multiplier For Negative position

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
long MajA=0;
long MajB=0;
long MajS=0;
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

double b0=1;
int b1=1;
int b2=1;

int bt=0;
int b=0;
double s0=2;
int s1=2;
int s2=2;

int st=0;
int s=1;
int p1=1;
int p2=1;
int p3=1;
int n1=0;
int n2=0;
int n3=0;
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
   MqlTradeResult  result1= {0};
   MqlTradeRequest request2= {};
   MqlTradeResult  result2= {0};
   MqlTradeRequest request3= {};
   MqlTradeResult  result3= {0};
   MqlTradeRequest request4= {};
   MqlTradeResult  result4= {0};
   MqlTradeRequest request5= {};
   MqlTradeResult  result5= {0};
   MqlTradeRequest request6= {};
   MqlTradeResult  result6= {0};

   datetime tm=TimeCurrent();
   MqlDateTime T;
   TimeToStruct(tm,T);




   if(b==0 && T.hour>3 && T.hour<23 && T.day_of_year<350 && T.day_of_year>6)
     {
      b=1;






      if(p1==1)
        {
         request1.action = TRADE_ACTION_DEAL;
         request1.type=ORDER_TYPE_BUY;
         request1.type_filling=ORDER_FILLING_FOK;
         request1.symbol=pair_1;
         request1.magic=MajB;
         request1.volume=(MathRound(100*b0*start_lot))/100;
         request1.deviation=9999;
         request1.price=SymbolInfoDouble(pair_1,SYMBOL_ASK);
         request1.comment="EURUSD1";
         OrderSend(request1,result1);
         p1=0;
        }


      if(p2==1)
        {
         request2.action = TRADE_ACTION_DEAL;
         request2.type=ORDER_TYPE_BUY;
         request2.type_filling=ORDER_FILLING_FOK;
         request2.symbol=pair_2;
         request2.magic=MajB;
         request2.volume=(MathRound(100*b0*SymbolInfoDouble(pair_1,SYMBOL_BID)*start_lot))/100;
         request2.deviation=9999;
         request2.price=SymbolInfoDouble(pair_2,SYMBOL_ASK);
         request2.comment="USDJPY1";
         OrderSend(request2,result2);
         p2=0;
        }



      if(p3==1)
        {
         request3.action = TRADE_ACTION_DEAL;
         request3.type=ORDER_TYPE_SELL;
         request3.type_filling=ORDER_FILLING_FOK;
         request3.symbol=pair_3;
         request3.magic=MajB;
         request3.volume=(MathRound(100*b0*start_lot))/100;
         request3.deviation=9999;
         request3.price=SymbolInfoDouble(pair_1,SYMBOL_BID);
         request3.comment="EURJPY1";
         OrderSend(request3,result3);
         p3=0;
        }
      time=TimeCurrent()+10;
      b0=0;
     }





   if(s==0 && T.hour>3 && T.hour<23 && T.day_of_year<350 && T.day_of_year>6)
     {
      s=1;





      if(n1==1)
        {
         request4.action = TRADE_ACTION_DEAL;
         request4.type=ORDER_TYPE_SELL;
         request4.type_filling=ORDER_FILLING_FOK;
         request4.symbol=pair_1;
         request4.magic=MajS;
         request4.volume=(MathRound(100*s0*start_lot))/100;
         request4.deviation=9999;
         request4.price=SymbolInfoDouble(pair_1,SYMBOL_BID);
         request4.comment="EURUSD2";
         OrderSend(request4,result4);
         n1=0;
        }


      if(n2==1)
        {
         request5.action = TRADE_ACTION_DEAL;
         request5.type=ORDER_TYPE_SELL;
         request5.type_filling=ORDER_FILLING_FOK;
         request5.symbol=pair_2;
         request5.magic=MajS;
         request5.volume=(MathRound(100*s0*SymbolInfoDouble(pair_1,SYMBOL_BID)*start_lot))/100;
         request5.deviation=9999;
         request5.price=SymbolInfoDouble(pair_2,SYMBOL_BID);
         request5.comment="USDJPY2";
         OrderSend(request5,result5);
         n2=0;
        }



      if(n3==1)
        {
         request6.action = TRADE_ACTION_DEAL;
         request6.type=ORDER_TYPE_BUY;
         request6.type_filling=ORDER_FILLING_FOK;
         request6.symbol=pair_3;
         request6.magic=MajS;
         request6.volume=(MathRound(100*s0*start_lot))/100;
         request6.deviation=9999;
         request6.price=SymbolInfoDouble(pair_1,SYMBOL_ASK);
         request6.comment="EURJPY2";
         OrderSend(request6,result6);
         n3=0;
        }
      time=TimeCurrent()+10;
      s0=0;
     }




   if(time<=TimeCurrent() && T.hour>3 && T.hour<23 && T.day_of_year<350 && T.day_of_year>6)

     {


      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);

         if((inf.Magic())==MajB && inf.Profit() >=10*inf.Volume()*MaxProfit)
           {
            if(inf.Symbol()==pair_1)
              {
               trade.PositionOpen(pair_1,ORDER_TYPE_BUY,start_lot,SymbolInfoDouble(pair_1,SYMBOL_ASK),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p1=1;
              }
            if(inf.Symbol()==pair_2)
              {
               trade.PositionOpen(pair_2,ORDER_TYPE_BUY,SymbolInfoDouble(pair_1,SYMBOL_BID)*start_lot,SymbolInfoDouble(pair_2,SYMBOL_ASK),0,0,"Basic");
               b0=double((MathRound(inf.Volume()/start_lot*100)*PosMult)/100);
               p2=1;
              }
            if(inf.Symbol()==pair_3)
              {
               trade.PositionOpen(pair_3,ORDER_TYPE_SELL,start_lot,SymbolInfoDouble(pair_3,SYMBOL_BID),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p3=1;
              }
            equity_max=inf.Profit()+equity_max;

            trade.PositionClose(PositionGetTicket(CnT),50) ;

            b=0;
           }

         if((inf.Magic())==MajB && inf.Profit()<=-10*inf.Volume()*MinProfit)
           {
            if(inf.Symbol()==pair_1)
              {
               s0=double(inf.Volume()/start_lot)*NegMult;
               n2=1;
               n3=1;
              }
            if(inf.Symbol()==pair_2)
              {
               s0=double((MathRound(inf.Volume()/start_lot*100)*NegMult)/100);
               n1=1;
               n3=1;
              }
            if(inf.Symbol()==pair_3)
              {
               s0=double(inf.Volume()/start_lot)*NegMult;
               n1=1;
               n2=1;
              }
            equity_max=inf.Profit()+equity_max;
            trade.PositionClose(PositionGetTicket(CnT),50) ;

            s=0;
           }





         if((inf.Magic())==MajS && inf.Profit() >=10*inf.Volume()*MaxProfit)
           {
            if(inf.Symbol()==pair_1)
              {
               trade.PositionOpen(pair_1,ORDER_TYPE_SELL,start_lot,SymbolInfoDouble(pair_1,SYMBOL_BID),0,0,"Basic");
               s0=double(inf.Volume()/start_lot)*PosMult;
               n1=1;
              }
            if(inf.Symbol()==pair_2)
              {
               trade.PositionOpen(pair_2,ORDER_TYPE_SELL,SymbolInfoDouble(pair_1,SYMBOL_BID)*start_lot,SymbolInfoDouble(pair_2,SYMBOL_BID),0,0,"Basic");
               s0=double((MathRound(inf.Volume()/start_lot*100)*PosMult)/100);
               n2=1;
              }
            if(inf.Symbol()==pair_3)
              {
              trade.PositionOpen(pair_3,ORDER_TYPE_BUY,start_lot,SymbolInfoDouble(pair_3,SYMBOL_ASK),0,0,"Basic");
              s0=double(inf.Volume()/start_lot)*PosMult;
               n3=1;
              }
            equity_max=inf.Profit()+equity_max;
            trade.PositionClose(PositionGetTicket(CnT),50) ;

            s=0;
           }

         if((inf.Magic())==MajS && inf.Profit()<=-10*inf.Volume()*MinProfit)
           {
            if(inf.Symbol()==pair_1)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p2=1;
               p3=1;
              }
            if(inf.Symbol()==pair_2)
              {
               b0=double((MathRound(inf.Volume()/start_lot*100)*NegMult)/100);
               p1=1;
               p3=1;
              }
            if(inf.Symbol()==pair_3)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p1=1;
               p2=1;
              }
            equity_max=inf.Profit()+equity_max;
            trade.PositionClose(PositionGetTicket(CnT),50) ;

            b=0;
           }

         CnT--;
        }
      time=TimeCurrent()+100;


     }







   if((AccountInfoDouble(ACCOUNT_EQUITY)>=(equity_min+TotProfit)))

     {

      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);



         if(inf.Comment()=="Basic"||inf.Magic()==MajB||(inf.Magic())==MajS)
           {

            trade.PositionClose(PositionGetTicket(CnT),50) ;



            Print("CloseProfitAll");
           }

         CnT--;
        }
      PosB=0;
      PosS=0;
      phase_Sell=0;
      b=0;
      Tk=0;
      s=1;
      b0=1;
      s0=2;
      b1=1;
      s1=2;
      b2=1;
      s2=2;
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
      p1=1;
      p2=1;
      p3=1;
      n1=0;
      n2=0;
      n3=0;
     }




   Comment(((b+s)%2),"\n",T.hour,"      ",TimeGMT(),"\n",(MathRound(100*profit1))/100,"\n",(MathRound(100*profit2))/100,"\n"
           "Total=",PositionsTotal(),"\n","MaxEquity_Last=",equity_max,"\n","MinEquity_Last=",equity_min,"\n","Eqity=",AccountInfoDouble(ACCOUNT_EQUITY)
           ,"\n","Profit1=",profit1,"\n","Profit2=",profit2,"\n","\n","b=",b,"\n","s=",s,"\n","PosB=",PosB,"\n","POsS=",PosS,"\n"
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

//+------------------------------------------------------------------+
