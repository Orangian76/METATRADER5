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



input string pair_1="XAGUSD";
input string pair_3="XAUUSD";
input double Notif=-300;//notify when equity achieve negative

input double start_lot=0.1;//START LOT
input double start_lot2=0.1;//START LOT
input int MaxProfit=60;//Pip Profit
input int MinProfit=120;//Pip Loss
input int TotProfit=200;//ProfitForCloseAll in Dollar
input double PosMult=1;//Multiplier For Positive position
input double NegMult=1;//Multiplier For Negative position
double EqStart=0;
double EqMax=0;
double EqMin=0;
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
input int order_magic=5555;//Enter OrderMagic bigger than 1000
long MajA=0;
long MajB1=0;
long MajS1=0;
long MajB2=0;
long MajS2=0;
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
double AllClosed=0;
double PriceB=0;
double PriceS=0;
ulong TicketB=0;
ulong TicketS=0;
double  equity_max;
double  equity_min;
double spread;
string NotifStr;
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
double b1=1;
int b2=1;

int bt=0;
int b=0;
int x=0;
double s0=2;
double s1=2;
int s2=2;

int st=0;
int s=1;
int y=1;
int p1=1;
int p2=1;
int p3=1;
int n1=0;
int n2=0;
int n3=0;
int po1=1;
int po2=1;
int po3=1;
int ne1=0;
int ne2=0;
int ne3=0;
int btemp=1;
int stemp=1;
int PosB=0;
int PosS=0;
double corre1=0;
double Vol1=0;
double Vol2=0;
double Vol3=0;
double NotifNeg=Notif;
double NotifPos=Notif;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//---

   Print("Hedge INITIALIZING!.");

   equity_firstBuy=AccountInfoDouble(ACCOUNT_EQUITY);
   equity_max=AccountInfoDouble(ACCOUNT_EQUITY);
   equity_min=AccountInfoDouble(ACCOUNT_EQUITY);
   EqStart=AccountInfoDouble(ACCOUNT_EQUITY);
   EqMax=AccountInfoDouble(ACCOUNT_EQUITY);
   EqMin=AccountInfoDouble(ACCOUNT_EQUITY);

   PriceB=1;
   PriceS=1000000;
   MajB1=order_magic;
   MajS1=order_magic+100;
   MajB2=order_magic+700;
   MajS2=order_magic+800;

   CnT=PositionsTotal()-1;


   while(CnT>=0)

     {

      inf.SelectByIndex(CnT);



      if(inf.Magic()==MajB2||inf.Magic()==MajB1||inf.Magic()==MajS1 || inf.Magic()==MajS2)
        {

         b=1;
         x=1;



         Print("Recoonected");
        }

      CnT--;
     }


   Print("Hedge INITIALIZED!.");
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

      if(b0*start_lot>20)
         b0=20/start_lot;




      if(p1==1)
        {
         request1.action = TRADE_ACTION_DEAL;
         request1.type=ORDER_TYPE_BUY;
         request1.type_filling=ORDER_FILLING_FOK;
         request1.symbol=pair_1;
         request1.magic=MajB1;
         request1.volume=(MathRound(100*b0*start_lot))/100;
         request1.deviation=9999;
         request1.price=SymbolInfoDouble(pair_1,SYMBOL_ASK);
         request1.comment=pair_1+"1";
         OrderSend(request1,result1);
         p1=0;
        }




      if(p3==1)
        {
         request3.action = TRADE_ACTION_DEAL;
         request3.type=ORDER_TYPE_SELL;
         request3.type_filling=ORDER_FILLING_FOK;
         request3.symbol=pair_3;
         request3.magic=MajB1;
         request3.volume=(MathRound(100*b0*start_lot2))/100;
         request3.deviation=9999;
         request3.price=SymbolInfoDouble(pair_1,SYMBOL_BID);
         request3.comment=pair_3+"1";
         OrderSend(request3,result3);
         p3=0;
        }
      time=TimeCurrent()+1;
      b0=0;
     }





   if(time<=TimeCurrent() && T.hour>3 && T.hour<23 && T.day_of_year<350 && T.day_of_year>6)

     {
      Vol1=0;
      Vol3=0;
      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);

         if((inf.Magic())==MajB1 && inf.Profit() >=10*inf.Volume()*MaxProfit)
           {
            time=TimeCurrent()+2;
            if(inf.Symbol()==pair_1)
              {
               if(inf.Volume()== start_lot)
                 {
                  trade.PositionOpen(pair_1,ORDER_TYPE_BUY,start_lot,SymbolInfoDouble(pair_1,SYMBOL_ASK),SymbolInfoDouble(pair_1,SYMBOL_ASK)-(0.09*MaxProfit*start_lot),0,"Basic");
                  b0=double(inf.Volume()/start_lot)*PosMult;
                  equity_max=inf.Profit()+equity_max;
                  AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
                  trade.PositionClose(PositionGetTicket(CnT),50) ;
                  p1=1;
                  b=0;
                 }
               else
                  if(inf.Profit() >=30*inf.Volume()*MaxProfit)
                    {
                     trade.PositionOpen(pair_1,ORDER_TYPE_BUY,start_lot,SymbolInfoDouble(pair_1,SYMBOL_ASK),SymbolInfoDouble(pair_1,SYMBOL_ASK)-(0.09*MaxProfit*start_lot),0,"Basic");
                     b0=double(inf.Volume()/start_lot)*PosMult;
                     equity_max=inf.Profit()+equity_max;
                     AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
                     trade.PositionClose(PositionGetTicket(CnT),50) ;
                     p1=1;
                     PosB=1;
                     b=0;
                    }

              }
            if(inf.Symbol()==pair_3)
              {
               if(inf.Volume()== start_lot2)
                 {
                  trade.PositionOpen(pair_3,ORDER_TYPE_SELL,start_lot2,SymbolInfoDouble(pair_3,SYMBOL_BID),SymbolInfoDouble(pair_3,SYMBOL_ASK)+(3*MaxProfit*start_lot2),0,"Basic");
                  b0=double(inf.Volume()/start_lot2)*PosMult;
                  equity_max=inf.Profit()+equity_max;
                  AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
                  trade.PositionClose(PositionGetTicket(CnT),50) ;
                  p3=1;
                  b=0;
                 }
               else
                  if(inf.Profit() >=30*inf.Volume()*MaxProfit)
                    {
                     trade.PositionOpen(pair_3,ORDER_TYPE_SELL,start_lot2,SymbolInfoDouble(pair_3,SYMBOL_BID),SymbolInfoDouble(pair_3,SYMBOL_ASK)+(3*MaxProfit*start_lot2),0,"Basic");
                     b0=double(inf.Volume()/start_lot2)*PosMult;
                     equity_max=inf.Profit()+equity_max;
                     AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
                     trade.PositionClose(PositionGetTicket(CnT),50) ;
                     p3=1;
                     PosS=1;
                     b=0;
                    }

              }



           }

         if((inf.Magic())==MajB1 && inf.Profit()<=-10*inf.Volume()*MinProfit)
           {
            time=TimeCurrent()+2;
            if(inf.Symbol()==pair_1 && PosB==0)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p1=1;
               equity_max=inf.Profit()+equity_max;
               AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
               trade.PositionClose(PositionGetTicket(CnT),50) ;
               b=0;
              }
            else
               if(inf.Symbol()==pair_1 && PosB>=1 && inf.Profit()<=-30*inf.Volume()*MinProfit)
                 {
                  b0=double(inf.Volume()/start_lot)*NegMult;
                  p1=1;
                  equity_max=inf.Profit()+equity_max;
                  AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
                  trade.PositionClose(PositionGetTicket(CnT),50) ;
                  PosB=0;
                  b=0;
                 }





            if(inf.Symbol()==pair_3 && PosS==0)
              {
               b0=double(inf.Volume()/start_lot2)*NegMult;
               p3=1;
               equity_max=inf.Profit()+equity_max;
               AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
               trade.PositionClose(PositionGetTicket(CnT),50) ;
               b=0;
              }
            else
               if(inf.Symbol()==pair_3 && PosS>=1 && inf.Profit()<=-30*inf.Volume()*MinProfit)
                 {
                  b0=double(inf.Volume()/start_lot2)*NegMult;
                  p3=1;
                  equity_max=inf.Profit()+equity_max;
                  AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
                  trade.PositionClose(PositionGetTicket(CnT),50) ;
                  PosS=0;
                  b=0;

                 }



           }





         if(inf.Symbol()== pair_1 && inf.PositionType()==ORDER_TYPE_BUY)

           {
            Vol1=Vol1+MathRound(inf.Volume()*100)/100;
           }
         else
            if(inf.Symbol()== pair_1 && inf.PositionType()==ORDER_TYPE_SELL)
              {
               Vol1=Vol1-MathRound(inf.Volume()*100)/100;
              }
            else
               if(inf.Symbol()== pair_3 && inf.PositionType()==ORDER_TYPE_BUY)
                 {
                  Vol3=Vol3+MathRound(inf.Volume()*100)/100;
                 }
               else
                  if(inf.Symbol()== pair_3 && inf.PositionType()==ORDER_TYPE_SELL)
                    {
                     Vol3=Vol3-MathRound(inf.Volume()*100)/100;
                    }
         CnT--;
        }
      if(AccountInfoDouble(ACCOUNT_EQUITY)>=EqMax)
        {
         EqMax=AccountInfoDouble(ACCOUNT_EQUITY);
        }
      if(AccountInfoDouble(ACCOUNT_EQUITY)<=EqMin)
        {
         EqMin=AccountInfoDouble(ACCOUNT_EQUITY);
        }
      if(equity_min-AccountInfoDouble(ACCOUNT_EQUITY)<NotifNeg)
        {
         NotifStr="!!Negative!! "+NotifNeg+" Equity"+"\n"
                  "Vol1="+Vol1+"\n"
                  "Vol3="+Vol3;
         SendNotification(NotifStr);
         NotifNeg=NotifNeg+Notif;

        }
      if(AccountInfoDouble(ACCOUNT_EQUITY)-equity_min>MathAbs(NotifPos))
        {
         NotifStr="!!Positive!! "+NotifPos+" Equity"+"\n"
                  "Vol1="+Vol1+"\n"
                  "Vol3="+Vol3;
         SendNotification(NotifStr);
         NotifPos=NotifPos+Notif;

        }
      time=TimeCurrent()+1;


     }





   if((AccountInfoDouble(ACCOUNT_EQUITY)>=(equity_min+TotProfit)))

     {




      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);



         if(inf.Magic()==MajB2||inf.Magic()==MajB1||inf.Magic()==MajS1 || inf.Magic()==MajS2 || inf.Comment()=="Basic")
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
      x=0;
      Tk=0;
      s=1;
      y=1;
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
      Vol1=0;
      Vol2=0;
      Vol3=0;
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
      po1=1;
      po2=1;
      po3=1;
      ne1=0;
      ne2=0;
      ne3=0;
      AllClosed=0;
      NotifNeg=Notif;
      NotifPos=Notif;
      int handle=FileOpen("CodeReport.csv",FILE_READ|FILE_WRITE|FILE_CSV,"\t",CP_UTF8);

      // write header
      FileSeek(handle,0,SEEK_END);

      FileWrite(handle,T.mon +"/"+T.day,equity_min,EqMax,EqMin);
      FileClose(handle);
      Sleep(20000);
      equity_max=AccountInfoDouble(ACCOUNT_EQUITY);
      equity_min=AccountInfoDouble(ACCOUNT_EQUITY);
      EqMax=AccountInfoDouble(ACCOUNT_EQUITY);
      EqMin=AccountInfoDouble(ACCOUNT_EQUITY);
     }




   Comment(((b+s)%2),"\n",T.hour,"      ",TimeGMT(),"\n",(MathRound(100*profit1))/100,"\n",(MathRound(100*profit2))/100,"\n"
           "Total=",PositionsTotal(),"\n","MaxEquity_Last=",equity_max,"\n","FirstEquity=",equity_min,"\n","All_Closed=",AllClosed
           ,"\n",pair_1,"=",(MathRound(100*Vol1))/100,"\n",pair_3,"=",(MathRound(100*Vol3))/100,"\n","b=",b,"\n","s=",s,"\n","PosB=",PosB,"\n","POsS=",PosS,"\n"
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
