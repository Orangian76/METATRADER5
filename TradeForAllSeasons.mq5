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
input string pair_2="GBPUSD";
input string pair_3="EURJPY";
input string pair_4="GBPJPY";
input string pair_5="USDJPY";
input string pair_6="USDCAD";
input string pair_7="AUDUSD";
input string pair_8="USDCHF";
input string pair_9="CHFJPY";
double ED=1;
input double start_lot=0.1;//START LOT
input int MaxProfit=25;//Pip Profit
input int MinProfit=15;//Pip Loss
input int TotProfit=2000;//ProfitForCloseAll in Dollar
input double PosMult=1;//Multiplier For Positive position
input double NegMult=1.3;//Multiplier For Negative position

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
double b1=1;
int b2=1;

int bt=0;
int b=0;
double s0=1;
double s1=2;
int s2=2;


int s=0;
int p1=1;
int p2=1;
int p3=1;
int p4=1;
int p5=1;
int p6=1;
int p7=1;
int p8=1;
int p9=1;

int btemp=1;
int stemp=1;
int PosB=0;
int PosS=0;
double corre1=0;
double Vol1=0;
double Vol2=0;
double Vol3=0;
double Vol4=0;
double Vol5=0;
double Vol6=0;
double Vol7=0;
double Vol8=0;
double Vol9=0;
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

   PriceB=1;
   PriceS=1000000;
   MajB1=order_magic;
   MajS1=order_magic+200;

   CnT=PositionsTotal()-1;


   while(CnT>=0)

     {

      inf.SelectByIndex(CnT);



      if(inf.Magic()==MajB1||inf.Magic()==MajS1)
        {

         b=1;
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
   MqlTradeRequest request7= {};
   MqlTradeResult  result7= {0};
   MqlTradeRequest request8= {};
   MqlTradeResult  result8= {0};
   MqlTradeRequest request9= {};
   MqlTradeResult  result9= {0};

   datetime tm=TimeCurrent();
   MqlDateTime T;
   TimeToStruct(tm,T);




   if(b==0 && T.hour>3 && T.hour<23 && T.day_of_year<350 && T.day_of_year>6)
     {
      b=1;

      if(b0*start_lot>8)
         b0=8/start_lot;




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


      if(p2==1)
        {
         request2.action = TRADE_ACTION_DEAL;
         request2.type=ORDER_TYPE_SELL;
         request2.type_filling=ORDER_FILLING_FOK;
         request2.symbol=pair_2;
         request2.magic=MajB1;
         request2.volume=(MathRound(100*b0*start_lot))/100;
         request2.deviation=9999;
         request2.price=SymbolInfoDouble(pair_2,SYMBOL_BID);
         request2.comment=pair_2+"1";
         OrderSend(request2,result2);
         p2=0;
        }



      if(p3==1)
        {
         request3.action = TRADE_ACTION_DEAL;
         request3.type=ORDER_TYPE_SELL;
         request3.type_filling=ORDER_FILLING_FOK;
         request3.symbol=pair_3;
         request3.magic=MajB1;
         request3.volume=(MathRound(100*b0*start_lot))/100;
         request3.deviation=9999;
         request3.price=SymbolInfoDouble(pair_3,SYMBOL_BID);
         request3.comment=pair_3+"1";
         OrderSend(request3,result3);
         p3=0;
        }



      if(p4==1)
        {
         request4.action = TRADE_ACTION_DEAL;
         request4.type=ORDER_TYPE_BUY;
         request4.type_filling=ORDER_FILLING_FOK;
         request4.symbol=pair_4;
         request4.magic=MajB1;
         request4.volume=(MathRound(100*b0*start_lot))/100;
         request4.deviation=9999;
         request4.price=SymbolInfoDouble(pair_4,SYMBOL_ASK);
         request4.comment=pair_4+"1";
         OrderSend(request4,result4);
         p4=0;
        }


      if(p5==1)
        {
         request5.action = TRADE_ACTION_DEAL;
         request5.type=ORDER_TYPE_BUY;
         request5.type_filling=ORDER_FILLING_FOK;
         request5.symbol=pair_5;
         request5.magic=MajB1;
         request5.volume=(MathRound(100*b0*start_lot))/100;
         request5.deviation=9999;
         request5.price=SymbolInfoDouble(pair_5,SYMBOL_ASK);
         request5.comment=pair_5+"1";
         OrderSend(request5,result5);
         p5=0;
        }



      if(p6==1)
        {
         request6.action = TRADE_ACTION_DEAL;
         request6.type=ORDER_TYPE_SELL;
         request6.type_filling=ORDER_FILLING_FOK;
         request6.symbol=pair_6;
         request6.magic=MajB1;
         request6.volume=(MathRound(100*b0*start_lot))/100;
         request6.deviation=9999;
         request6.price=SymbolInfoDouble(pair_6,SYMBOL_BID);
         request6.comment=pair_6+"1";
         OrderSend(request6,result6);
         p6=0;
        }


      if(p7==1)
        {
         request7.action = TRADE_ACTION_DEAL;
         request7.type=ORDER_TYPE_SELL;
         request7.type_filling=ORDER_FILLING_FOK;
         request7.symbol=pair_7;
         request7.magic=MajB1;
         request7.volume=(MathRound(100*b0*start_lot))/100;
         request7.deviation=9999;
         request7.price=SymbolInfoDouble(pair_7,SYMBOL_BID);
         request7.comment=pair_7+"1";
         OrderSend(request7,result7);
         p7=0;
        }


      if(p8==1)
        {
         request8.action = TRADE_ACTION_DEAL;
         request8.type=ORDER_TYPE_SELL;
         request8.type_filling=ORDER_FILLING_FOK;
         request8.symbol=pair_8;
         request8.magic=MajB1;
         request8.volume=(MathRound(100*b0*start_lot))/100;
         request8.deviation=9999;
         request8.price=SymbolInfoDouble(pair_8,SYMBOL_BID);
         request8.comment=pair_8+"1";
         OrderSend(request8,result8);
         p8=0;
        }



      if(p9==1)
        {
         request9.action = TRADE_ACTION_DEAL;
         request9.type=ORDER_TYPE_SELL;
         request9.type_filling=ORDER_FILLING_FOK;
         request9.symbol=pair_9;
         request9.magic=MajB1;
         request9.volume=(MathRound(100*b0*start_lot))/100;
         request9.deviation=9999;
         request9.price=SymbolInfoDouble(pair_9,SYMBOL_BID);
         request9.comment=pair_9+"1";
         OrderSend(request9,result9);
         p9=0;
        }


      time=TimeCurrent()+2;
      b0=0;
     }





   if(time<=TimeCurrent() && T.hour>3 && T.hour<23 && T.day_of_year<350 && T.day_of_year>6)

     {
      Vol1=0;
      Vol2=0;
      Vol3=0;
      Vol4=0;
      Vol5=0;
      Vol6=0;
      Vol7=0;
      Vol8=0;
      Vol9=0;
      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);

         if((inf.Magic())==MajB1 && inf.Profit() >=10*inf.Volume()*MaxProfit)
           {
            if(inf.Symbol()==pair_1)
              {
               trade.PositionOpen(pair_1,ORDER_TYPE_BUY,start_lot,SymbolInfoDouble(pair_1,SYMBOL_ASK),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p1=1;
              }
            if(inf.Symbol()==pair_2)
              {
               trade.PositionOpen(pair_2,ORDER_TYPE_SELL,start_lot,SymbolInfoDouble(pair_2,SYMBOL_BID),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p2=1;
              }
            if(inf.Symbol()==pair_3)
              {
               trade.PositionOpen(pair_3,ORDER_TYPE_SELL,start_lot,SymbolInfoDouble(pair_3,SYMBOL_BID),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p3=1;
              }
            if(inf.Symbol()==pair_4)
              {
               trade.PositionOpen(pair_4,ORDER_TYPE_BUY,start_lot,SymbolInfoDouble(pair_4,SYMBOL_ASK),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p4=1;
              }
            if(inf.Symbol()==pair_5)
              {
               trade.PositionOpen(pair_5,ORDER_TYPE_BUY,start_lot,SymbolInfoDouble(pair_5,SYMBOL_ASK),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p5=1;
              }
            if(inf.Symbol()==pair_6)
              {
               trade.PositionOpen(pair_6,ORDER_TYPE_SELL,start_lot,SymbolInfoDouble(pair_6,SYMBOL_BID),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p6=1;
              }
            if(inf.Symbol()==pair_7)
              {
               trade.PositionOpen(pair_7,ORDER_TYPE_SELL,start_lot,SymbolInfoDouble(pair_7,SYMBOL_BID),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p7=1;
              }
            if(inf.Symbol()==pair_8)
              {
               trade.PositionOpen(pair_8,ORDER_TYPE_SELL,start_lot,SymbolInfoDouble(pair_8,SYMBOL_BID),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p8=1;
              }
            if(inf.Symbol()==pair_9)
              {
               trade.PositionOpen(pair_9,ORDER_TYPE_SELL,start_lot,SymbolInfoDouble(pair_9,SYMBOL_BID),0,0,"Basic");
               b0=double(inf.Volume()/start_lot)*PosMult;
               p9=1;
              }
            equity_max=inf.Profit()+equity_max;
            AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
            trade.PositionClose(PositionGetTicket(CnT),50) ;

            b=0;
           }

         if((inf.Magic())==MajB1 && inf.Profit()<=-10*inf.Volume()*MinProfit)
           {
            if(inf.Symbol()==pair_1)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p1=1;
              }
            if(inf.Symbol()==pair_2)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p2=1;
              }
            if(inf.Symbol()==pair_3)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p3=1;
              }
            if(inf.Symbol()==pair_4)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p4=1;
              }
            if(inf.Symbol()==pair_5)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p5=1;
              }
            if(inf.Symbol()==pair_6)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p6=1;
              }
            if(inf.Symbol()==pair_7)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p7=1;
              }
            if(inf.Symbol()==pair_8)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p8=1;
              }
            if(inf.Symbol()==pair_9)
              {
               b0=double(inf.Volume()/start_lot)*NegMult;
               p9=1;
              }
            equity_max=inf.Profit()+equity_max;
            AllClosed=inf.Profit()+inf.Swap()+inf.Commission()+AllClosed;
            trade.PositionClose(PositionGetTicket(CnT),50) ;

            b=0;
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
               if(inf.Symbol()== pair_2 && inf.PositionType()==ORDER_TYPE_BUY)
                 {
                  Vol2=Vol2+MathRound(inf.Volume()*100)/100;
                 }
               else
                  if(inf.Symbol()== pair_2 && inf.PositionType()==ORDER_TYPE_SELL)
                    {
                     Vol2=Vol2-MathRound(inf.Volume()*100)/100;
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
                        else
                           if(inf.Symbol()== pair_4 && inf.PositionType()==ORDER_TYPE_SELL)
                             {
                              Vol4=Vol4-MathRound(inf.Volume()*100)/100;
                             }
                           else
                              if(inf.Symbol()== pair_4 && inf.PositionType()==ORDER_TYPE_BUY)
                                {
                                 Vol4=Vol4+MathRound(inf.Volume()*100)/100;
                                }
                              else
                                 if(inf.Symbol()== pair_5 && inf.PositionType()==ORDER_TYPE_SELL)
                                   {
                                    Vol5=Vol5-MathRound(inf.Volume()*100)/100;
                                   }
                                 else
                                    if(inf.Symbol()== pair_5 && inf.PositionType()==ORDER_TYPE_BUY)
                                      {
                                       Vol5=Vol5+MathRound(inf.Volume()*100)/100;
                                      }
                                    else
                                       if(inf.Symbol()== pair_6 && inf.PositionType()==ORDER_TYPE_SELL)
                                         {
                                          Vol6=Vol6-MathRound(inf.Volume()*100)/100;
                                         }
                                       else
                                          if(inf.Symbol()== pair_6 && inf.PositionType()==ORDER_TYPE_BUY)
                                            {
                                             Vol6=Vol6+MathRound(inf.Volume()*100)/100;
                                            }
                                          else
                                             if(inf.Symbol()== pair_7 && inf.PositionType()==ORDER_TYPE_BUY)
                                               {
                                                Vol7=Vol7+MathRound(inf.Volume()*100)/100;
                                               }
                                             else
                                                if(inf.Symbol()== pair_7 && inf.PositionType()==ORDER_TYPE_SELL)
                                                  {
                                                   Vol7=Vol7-MathRound(inf.Volume()*100)/100;
                                                  }
                                                else
                                                   if(inf.Symbol()== pair_8 && inf.PositionType()==ORDER_TYPE_BUY)
                                                     {
                                                      Vol8=Vol8+MathRound(inf.Volume()*100)/100;
                                                     }
                                                   else
                                                      if(inf.Symbol()== pair_8 && inf.PositionType()==ORDER_TYPE_SELL)
                                                        {
                                                         Vol8=Vol8-MathRound(inf.Volume()*100)/100;
                                                        }
                                                      else
                                                         if(inf.Symbol()== pair_9 && inf.PositionType()==ORDER_TYPE_BUY)
                                                           {
                                                            Vol9=Vol9+MathRound(inf.Volume()*100)/100;
                                                           }
                                                         else
                                                            if(inf.Symbol()== pair_9 && inf.PositionType()==ORDER_TYPE_SELL)
                                                              {
                                                               Vol9=Vol9-MathRound(inf.Volume()*100)/100;
                                                              }







         CnT--;
        }
      time=TimeCurrent()+2;


     }







   if((AccountInfoDouble(ACCOUNT_EQUITY)>=(equity_min+TotProfit)))

     {

      CnT=PositionsTotal()-1;


      while(CnT>=0)

        {

         inf.SelectByIndex(CnT);



         if(inf.Magic()==MajB1||inf.Magic()==MajS1  || inf.Comment()=="Basic")
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

      s=0;

      b0=1;
      s0=1;
      b1=1;
      s1=2;
      b2=1;
      s2=2;
      bt=0;

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
      Vol1=0;
      Vol2=0;
      Vol3=0;
      Vol4=0;
      Vol5=0;
      Vol6=0;
      Vol7=0;
      Vol8=0;
      Vol9=0;

      PriceB=0;
      PriceS=0;
      TicketB=0;
      TicketS=0;
      p1=1;
      p2=1;
      p3=1;

      p4=1;
      p5=1;
      p6=1;

      p7=1;
      p8=1;
      p9=1;

      AllClosed=0;
     }




   Comment(((b+s)%2),"\n",T.hour,"      ",TimeGMT(),"\n",
           "Total=",PositionsTotal(),"\n","MaxEquity_Last=",equity_max,"\n","FirstEquity=",equity_min,"\n","All_Closed=",AllClosed,"\n"
           ,"\n",pair_1,"=",(MathRound(100*Vol1))/100,"\n",pair_2,"=",(MathRound(100*Vol2))/100,"\n",pair_3,"=",(MathRound(100*Vol3))/100,"\n"
           ,pair_4,"=",(MathRound(100*Vol4))/100,"\n",pair_5,"=",(MathRound(100*Vol5))/100,"\n",pair_6,"=",(MathRound(100*Vol6))/100,"\n"
           ,pair_7,"=",(MathRound(100*Vol7))/100,"\n",pair_8,"=",(MathRound(100*Vol8))/100,"\n",pair_9,"=",(MathRound(100*Vol9))/100,"\n","\n",
           "b=",b,"\n","s=",s);



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
