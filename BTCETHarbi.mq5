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

input int Spre=10;

//input ENUM_ORDER_TYPE start_order_type=ORDER_TYPE_BUY;//START ORDER TYPE
input string pair_1="BTCUSD";
input string pair_2="ETHUSD";
input string BigSpread="pair_1";//SET Biggest Spread between pair_1 or pair_2 or pair_3 or pair_4
input int STOPPERCENT=70;//LOSS of EquityPercent To Close All SYSTEM 
double ED=1;
input double start_lot=0.01;//START LOT
input int BITCOIN_STEP=400;
input int Ethereum_STEP=20;
input double SLB=1;
input double SLE=2;
input double TPB=1;
input int TPE=2;
int BS=0;
int ET=0;
double lot_find=0;

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
int MajIB=0;
int MajIS=0;
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
double Vol=0;
ulong TicketB=0;
ulong TicketS=0;
double  equity_max;
double  equity_min;
double Price;
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
int b2=0;
int b3=1;
int b4=1;

int bt=0;
int b=0;
int s0=0;
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
  
Print("BTC INITIALIZING!.");

  equity_firstBuy=AccountInfoDouble(ACCOUNT_EQUITY);
  equity_max=AccountInfoDouble(ACCOUNT_EQUITY);
  equity_min=AccountInfoDouble(ACCOUNT_EQUITY);

  PriceB=SymbolInfoDouble(pair_1,SYMBOL_BID);
  PriceS=SymbolInfoDouble(pair_2,SYMBOL_ASK);
  MajB=order_magic;
  MajS=order_magic+1000;
  MajIB=order_magic-1000;
  MajIS=order_magic-2000;
  Price=SymbolInfoDouble(pair_1,SYMBOL_BID);
  BS=BITCOIN_STEP;
  ET=Ethereum_STEP;
    

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
   MqlTradeRequest request1={};
   MqlTradeResult  result1={};
   MqlTradeRequest request2={};
   MqlTradeResult  result2={};
   MqlTradeRequest request3={};
   MqlTradeResult  result3={};
   MqlTradeRequest request4={};
   MqlTradeResult  result4={};

   datetime tm=TimeCurrent();
   MqlDateTime T;
   TimeToStruct(tm,T);
 

//  if (CopyBuffer(RS,0,0,20,rsi) < 0){Print("CopyBufferRSI error =",GetLastError());}



//      eurdkk=(MathRound(10000*SymbolInfoDouble(pair_1,SYMBOL_BID)*SymbolInfoDouble(pair_2,SYMBOL_BID)))/10000;
      

if((b2==0||Vol>=(SymbolInfoDouble(pair_1,SYMBOL_BID)/SymbolInfoDouble(pair_2,SYMBOL_ASK))+0.5||Vol<=(SymbolInfoDouble(pair_1,SYMBOL_BID)/SymbolInfoDouble(pair_2,SYMBOL_ASK))-0.5))
   {
   
   Price=100;
   if ( (MathRound(100*b2*start_lot))/100 < 14.4 && s0<=0) {

 //  b2=b1+b0;
 //  b0=b1;
 //  b1=b2;
     b1=b1+1;
     b2=b1;
                }
              
          
   tim=2; 
   ptim=T.hour; 
   pipB=0;

       

      //Buy
       Vol= SymbolInfoDouble(pair_1,SYMBOL_BID)/SymbolInfoDouble(pair_2,SYMBOL_ASK);
       request1.action = TRADE_ACTION_DEAL;
       request1.type=ORDER_TYPE_BUY;
       request1.symbol=pair_1;
       request1.magic=MajB;
       request1.volume=(MathRound(100*start_lot))/100;
       request1.deviation=50;
       request1.price=SymbolInfoDouble(pair_1,SYMBOL_ASK);
       PriceB=SymbolInfoDouble(pair_1,SYMBOL_BID);
       request1.comment="BTCb";
 //      request1.sl=request1.price-(SLB*BS);
//       request1.tp=request1.price+(TPB*BS);
       OrderSend(request1,result1); 
       
         
       request3.action = TRADE_ACTION_DEAL;
       request3.type=ORDER_TYPE_SELL;
       request3.symbol=pair_1;
       request3.magic=MajIB;
       request3.volume=(MathRound(100*start_lot))/100;
       request3.deviation=50;
       request3.price=SymbolInfoDouble(pair_1,SYMBOL_BID);
       request3.comment="BTCib";
 //      request3.sl=request3.price-(SLB*BS);
//       request3.tp=request3.price+(TPB*BS);
       OrderSend(request3,result3);         

       
  
      //Sell 

       request2.action = TRADE_ACTION_DEAL;
       request2.type=ORDER_TYPE_SELL;
       request2.symbol=pair_2;
       request2.magic=MajS;
       request2.volume=(MathRound(100*Vol*start_lot))/100;
       request2.deviation=50;
       request2.price=SymbolInfoDouble(pair_2,SYMBOL_BID);
       PriceS=SymbolInfoDouble(pair_2,SYMBOL_ASK);
       request2.comment="ETHs";
 //      request2.sl=request2.price+(SLE*ET);      
  //     request2.tp=request2.price-(TPE*ET);
       OrderSend(request2,result2);

       request4.action = TRADE_ACTION_DEAL;
       request4.type=ORDER_TYPE_BUY;
       request4.symbol=pair_2;
       request4.magic=MajIS;
       request4.volume=(MathRound(100*Vol*start_lot))/100;
       request4.deviation=50;
       request4.price=SymbolInfoDouble(pair_2,SYMBOL_ASK);
       request4.comment="ETHis";
 //      request4.sl=request4.price+(SLE*ET);      
  //     request4.tp=request4.price-(TPE*ET);
       OrderSend(request4,result4);
      time=TimeCurrent()+10;         
 
   }
 
    if(time<=TimeCurrent())
      
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
           
               

           if(inf.Magic()==MajB)
           {
            TempProfit1= inf.Profit()+inf.Swap()+inf.Commission();
            profit1=profit1+TempProfit1;

           }

           if(inf.Magic()==MajS)
           {
            TempProfit2= inf.Profit()+inf.Swap()+inf.Commission();
            profit2=profit2+TempProfit2;

           }
           if(inf.Magic()==MajIB)
           {
            TempProfit3= inf.Profit()+inf.Swap()+inf.Commission();
            profit3=profit3+TempProfit3;

           }

           if(inf.Magic()==MajIS)
           {
             TempProfit4= inf.Profit()+inf.Swap()+inf.Commission();
             profit4=profit4+TempProfit4;

            }         
           
           CnT--;
          } 
          
        time=TimeCurrent()+10;
                  
       }
       
       
if(profit1+profit2>=(800*b1*start_lot))
   
   {

    CnT=PositionsTotal()-1;


        while(CnT>=0)
         
          {

          inf.SelectByIndex(CnT);
           
               

           if((inf.Magic())==MajB||(inf.Magic())==MajS) 
            {
             trade.PositionClose(PositionGetTicket(CnT),50) ;
             Print("CloseProfitSingle");
            }
           
           CnT--;
          } 
          }
          
          
          
  if(profit3+profit4>=(800*b1*start_lot))
   
   {

    CnT=PositionsTotal()-1;


        while(CnT>=0)
         
          {

          inf.SelectByIndex(CnT);
           
               

           if((inf.Magic())==MajIB||(inf.Magic())==MajIS) 
            {
             trade.PositionClose(PositionGetTicket(CnT),50) ;
             Print("CloseProfitSingle");
            }
           
           CnT--;
          } 
          }
    
if((AccountInfoDouble(ACCOUNT_EQUITY)>=(equity_max+(600*(0.5*b1)*start_lot))))
   
   {

    CnT=PositionsTotal()-1;


        while(CnT>=0)
         
          {

          inf.SelectByIndex(CnT);
           
               

           if((inf.Magic())==MajB||(inf.Magic())==MajS) 
            {
             trade.PositionClose(PositionGetTicket(CnT),50) ;
             Print("CloseProfitAll");
            }
           
           CnT--;
          }  
       phase_Buy=0;
       phase_Sell=0;
       s=0;
       b0=0;
       s0=0;       
       b1=1;
       s1=1;
       b2=0;
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
       Vol=0;
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
       BS=BITCOIN_STEP;
       ET=Ethereum_STEP;
      Sleep(7200000);
      Price=SymbolInfoDouble(pair_1,SYMBOL_BID);
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
   Price=0;
   b0=0;
   b1=1;
   b2=5;
   } 
   
   

Comment(T.hour  ,"      ",TimeGMT(),"\n",(MathRound(100*profit1))/100,"\n",(MathRound(100*profit2))/100,"\n",(MathRound(100*(profit3+profit4)))/100,"\n",(MathRound(100*profit4))/100,"\n",
   "Total=",PositionsTotal(),"\n","MaxEquity_Last=",equity_max,"\n","MinEquity_Last=",equity_min,"\n","Eqity=",AccountInfoDouble(ACCOUNT_EQUITY)
  ,"\n","       ",BITCOIN_STEP,"\n",BS,"\n",
   "b0=",b0,"\n","b1=",b1,"\n","b2=",b2,"\n","s=",s,"\n","PriceB=",PriceB,"\n","PriceS=",PriceS,"\n","PriceB+=",PriceB+BS,"\n","PriceS-=",PriceS-BS,"\n"
  "Price=",Price,"\n","Price-now=",(MathAbs(Price-(SymbolInfoDouble(pair_1,SYMBOL_BID)))),"\n","TicketB=",TicketB,"\n","TicketS=",TicketS);


  
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
