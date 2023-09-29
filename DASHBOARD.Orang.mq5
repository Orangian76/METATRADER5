//+------------------------------------------------------------------+
//|                                                --DASHBOARD--.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>
//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input string symbol_1="XAUUSD.";
input string symbol_2="USDCAD.";
input string symbol_3="USDJPY.";
input string symbol_4="USDCHF.";
input string symbol_5="AUDUSD.";
input string symbol_6="EURUSD.";
input string symbol_7="NZDUSD.";
input string symbol_8="EURCAD.";
input string symbol_9="NZDCAD.";
input string symbol_10="AUDCAD.";

input string    ___________________="===== Edit_Profit settings =====";

input string           InpName_Profit="Edit_Profit";       // Object name 
input string           InText_Profit="Profit";            // Object text 
input string           InpFont_Profit="Tahoma";             // Font 
input int              InpFontSize_Profit=12;              // Font size 
input ENUM_ALIGN_MODE  InpAlign_Profit=ALIGN_CENTER;       // Text alignment type 
input bool             InpReadOnly_Profit=false;           // Ability to edit 
input ENUM_BASE_CORNER InpCorner_Profit=CORNER_LEFT_UPPER; // Chart corner for anchoring 
input color            InpColor_Profit=clrGreen;           // Text color 
input color            InpBackColor_Profit=clrWhite;       // Background color 
input color            InpBorderColor_Profit=clrBlack;     // Border color 
input bool             InpBack_Profit=false;               // Background object 
input bool             InSelection_Profit=false;          // Highlight to move 
input bool             InpHidden_Profit=true;              // Hidden in the object list 
input long             InpZOrder_Profit=0;                 // Priority for mouse click 

input string    __________________="===== Edit_Loss settings =====";


input string           InpName_Loss="Edit_Loss";              // Object name 
input string           InText_Loss="Loss";              // Object text 
input string           InpFont_Loss="Tahoma";             // Font 
input int              InpFontSize_Loss=12;              // Font size 
input ENUM_ALIGN_MODE  InpAlign_Loss=ALIGN_CENTER;       // Text alignment type 
input bool             InpReadOnly_Loss=false;           // Ability to edit 
input ENUM_BASE_CORNER InpCorner_Loss=CORNER_LEFT_UPPER; // Chart corner for anchoring 
input color            InpColor_Loss=clrRed;           // Text color 
input color            InpBackColor_Loss=clrWhite;       // Background color 
input color            InpBorderColor_Loss=clrBlack;     // Border color 
input bool             InpBack_Loss=false;               // Background object 
input bool             InSelection_Loss=false;          // Highlight to move 
input bool             InpHidden_Loss=true;              // Hidden in the object list 
input long             InpZOrder_Loss=0;                 // Priority for mouse click 

//.............................

input string    ____________________________="===== Edit_Profit_amount_B settings =====";

input string           InpName_Profit_amount_B ="Edit_Profit_amount_B";       // Object name 
input string           InText_Profit_amount_B="SET_TP_B";            // Object text 
input string           InpFont_Profit_amount_B="Tahoma";             // Font 
input int              InpFontSize_Profit_amount_B=9;              // Font size 
input ENUM_ALIGN_MODE  InpAlign_Profit_amount_B=ALIGN_CENTER;       // Text alignment type 
input bool             InpReadOnly_Profit_amount_B=false;           // Ability to edit 
input ENUM_BASE_CORNER InpCorner_Profit_amount_B=CORNER_LEFT_UPPER; // Chart corner for anchoring 
input color            InpColor_Profit_amount_B=clrGreen;           // Text color 
input color            InpBackColor_Profit_amount_B=clrLightGreen;       // Background color 
input color            InpBorderColor_Profit_amount_B=clrBlack;     // Border color 
input bool             InpBack_Profit_amount_B=false;               // Background object 
input bool             InSelection_Profit_amount_B=false;          // Highlight to move 
input bool             InpHidden_Profit_amount_B=true;              // Hidden in the object list 
input long             InpZOrder_Profit_amount_B=0;                 // Priority for mouse click 

input string    __________________________________="===== Edit_Loss_amount_B settings =====";


input string           InpName_Loss_amount_B="Edit_Loss_amount_B";              // Object name 
input string           InText_Loss_amount_B="SET_SL_B";              // Object text 
input string           InpFont_Loss_amount_B="Tahoma";             // Font 
input int              InpFontSize_Loss_amount_B=9;              // Font size 
input ENUM_ALIGN_MODE  InpAlign_Loss_amount_B=ALIGN_CENTER;       // Text alignment type 
input bool             InpReadOnly_Loss_amount_B=false;           // Ability to edit 
input ENUM_BASE_CORNER InpCorner_Loss_amount_B=CORNER_LEFT_UPPER; // Chart corner for anchoring 
input color            InpColor_Loss_amount_B=clrRed;           // Text color 
input color            InpBackColor_Loss_amount_B=clrLightGreen;       // Background color 
input color            InpBorderColor_Loss_amount_B=clrBlack;     // Border color 
input bool             InpBack_Loss_amount_B=false;               // Background object 
input bool             InSelection_Loss_amount_B=false;          // Highlight to move 
input bool             InpHidden_Loss_amount_B=true;              // Hidden in the object list 
input long             InpZOrder_Loss_amount_B=0;                 // Priority for mouse click 

input string    ___________________________________________="===== Edit_Profit_amount_S settings =====";

input string           InpName_Profit_amount_S ="Edit_Profit_amount_S";       // Object name 
input string           InText_Profit_amount_S="SET_TP_S";            // Object text 
input string           InpFont_Profit_amount_S="Tahoma";             // Font 
input int              InpFontSize_Profit_amount_S=9;              // Font size 
input ENUM_ALIGN_MODE  InpAlign_Profit_amount_S=ALIGN_CENTER;       // Text alignment type 
input bool             InpReadOnly_Profit_amount_S=false;           // Ability to edit 
input ENUM_BASE_CORNER InpCorner_Profit_amount_S=CORNER_LEFT_UPPER; // Chart corner for anchoring 
input color            InpColor_Profit_amount_S=clrGreen;           // Text color 
input color            InpBackColor_Profit_amount_S=clrPink;       // Background color 
input color            InpBorderColor_Profit_amount_S=clrBlack;     // Border color 
input bool             InpBack_Profit_amount_S=false;               // Background object 
input bool             InSelection_Profit_amount_S=false;          // Highlight to move 
input bool             InpHidden_Profit_amount_S=true;              // Hidden in the object list 
input long             InpZOrder_Profit_amount_S=0;                 // Priority for mouse click 

//.............................

input string    ______________________________________="===== Edit_Loss_amount_S settings =====";


input string           InpName_Loss_amount_S="Edit_Loss_amount_S";              // Object name 
input string           InText_Loss_amount_S="SET_SL_S";              // Object text 
input string           InpFont_Loss_amount_S="Tahoma";             // Font 
input int              InpFontSize_Loss_amount_S=9;              // Font size 
input ENUM_ALIGN_MODE  InpAlign_Loss_amount_S=ALIGN_CENTER;       // Text alignment type 
input bool             InpReadOnly_Loss_amount_S=false;           // Ability to edit 
input ENUM_BASE_CORNER InpCorner_Loss_amount_S=CORNER_LEFT_UPPER; // Chart corner for anchoring 
input color            InpColor_Loss_amount_S=clrRed;           // Text color 
input color            InpBackColor_Loss_amount_S=clrPink;       // Background color 
input color            InpBorderColor_Loss_amount_S=clrBlack;     // Border color 
input bool             InpBack_Loss_amount_S=false;               // Background object 
input bool             InSelection_Loss_amount_S=false;          // Highlight to move 
input bool             InpHidden_Loss_amount_S=true;              // Hidden in the object list 
input long             InpZOrder_Loss_amount_S=0;                 // Priority for mouse click 

input string    ____________________="===== SIZE settings =====";

input double X=0;
input double Y=11;
input double FONT_KEY=12;
 double XSIZE=700;
 double YSIZE=40;
input int N_column=8;

//------------------------------------------------------------------
double profit_ALL,profit_BUY,profit_SELL,lots_BUY,lots_SELL,f,ff,xx,XXX,XXXX,YYY,tyTyTyp,OPP,TICKETA,TICKETB ;
int MAGIC,count ;
input int MaxSlippage=5;
 
int count_COMMENT,count_ALL_COMMENT,maggic,countSET_HEDGEE;

string text,name,PROFIT,LOSS,comment,commentt,COM,bbb,SET_TP_B,SET_SL_B,SET_TP_S,SET_SL_S;

//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CExpert ExtExpert;
CPositionInfo pi;
   CTrade trade;

//------------------------------------------------------------------

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
      {
      if(id==CHARTEVENT_OBJECT_CLICK)
       {    
               for(int i=0; i<PositionsTotal(); i++)
              {
              if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
              
               if(PositionGetString(POSITION_COMMENT) =="" ) {COM=PositionGetSymbol(i)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")" ; } 
               if(PositionGetString(POSITION_COMMENT) !="" ) {COM= StringSubstr(PositionGetString(POSITION_COMMENT),0,3)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")" ; } 
 
//------------------------------------------------------------------
               if(sparam==COM  )
                 {
 
                     int retF_CloseAll=MessageBox(" WOULD YOU LIKE TO Close "  +COM,"\n"+"\n" ,MB_YESNO|MB_ICONQUESTION);
                                                 
                     if(retF_CloseAll==IDNO) {break;}
                     if(retF_CloseAll==IDYES) {  F_CloseAll(COM ); dielet_object(COM);}
                      
           ObjectSetInteger(0,PositionGetString(POSITION_COMMENT),OBJPROP_STATE,false);
              }
//------------------------------------------------------------------
              }
 
     }
 if(id==CHARTEVENT_OBJECT_CLICK)
       {    
               for(int i=0; i<PositionsTotal(); i++)
              {
              if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
              

               if( PositionGetString(POSITION_COMMENT) !="" || PositionGetString(POSITION_COMMENT) ==""  ) {COM= "ALL" ; } 
               
if(sparam==COM  )
                 {
 
                     int retF_CloseAll=MessageBox(" WOULD YOU LIKE to Close "  +COM,"\n"+"\n" ,MB_YESNO|MB_ICONQUESTION);
                                                 
                     if(retF_CloseAll==IDNO) {break;}
                     if(retF_CloseAll==IDYES) {  F_CloseAll(COM ); dielet_object(COM);}
                      
           ObjectSetInteger(0,PositionGetString(POSITION_COMMENT),OBJPROP_STATE,false);
              }
//------------------------------------------------------------------
              }
 
     }
if(id==CHARTEVENT_OBJECT_CLICK)
       {    
               for(int i=0; i<1; i++)
              {
              if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
              

               if( PositionGetString(POSITION_COMMENT) !="" || PositionGetString(POSITION_COMMENT) ==""  ) {COM= "SET_HEDGE" ; } 
 
//------------------------------------------------------------------
               if(sparam==COM  )
                 {
 
                     int retF_CloseAll=MessageBox(" WOULD YOU LIKE to "  +COM,"\n"+"\n" ,MB_YESNO|MB_ICONQUESTION);
                                                 
                     if(retF_CloseAll==IDNO) {break;}
                     if(retF_CloseAll==IDYES) { set_hedge();}
                      
           ObjectSetInteger(0,PositionGetString(POSITION_COMMENT),OBJPROP_STATE,false);
              }
//------------------------------------------------------------------
              }
 
     }
     
if(id==CHARTEVENT_OBJECT_CLICK)
       {    
               for(int i=0; i<1; i++)
              {
              if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
              

               if( PositionGetString(POSITION_COMMENT) !="" || PositionGetString(POSITION_COMMENT) ==""  ) {COM= "CLOSEBY" ; } 
 
//------------------------------------------------------------------
               if(sparam==COM  )
                 {
 
                     int retF_CloseAll=MessageBox(" WOULD YOU LIKE  "  +COM,"\n"+"\n" ,MB_YESNO|MB_ICONQUESTION);
                                                 
                     if(retF_CloseAll==IDNO) {break;}
                     if(retF_CloseAll==IDYES) {  F_CLOSEBY_ALL();  }
                      
           ObjectSetInteger(0,PositionGetString(POSITION_COMMENT),OBJPROP_STATE,false);
              }
//------------------------------------------------------------------
              }
 
     }
 }
//------------------------------------------------------------------
//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit()
  {
EventSetMillisecondTimer(500);
//--- ok
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
    EventKillTimer();
   ObjectsDeleteAll(0);
   Comment("");
  }
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
Comment(F_COUNTER_HEDGE( countSET_HEDGEE));
 
     comment=""; 
 draw_KEY_SET(0);
 draw_KEY_CLOSEBY(0);
 draw_KEY_ALL_ORDER(0);
for(int  j=0; j<PositionsTotal() ; j++)
{
   if(PositionSelectByTicket(PositionGetTicket(j))==false)continue;
             
     {  
      if((PositionGetString(POSITION_COMMENT)!= ""  && StringSubstr(PositionGetString(POSITION_COMMENT),0,3) != StringSubstr(comment,0,3)) ||( PositionGetString(POSITION_COMMENT) == ""  && PositionGetSymbol(j)!=comment  )    )   
        {draw_KEY(j);  } 
 
     }
}
if(PositionsTotal()==0) {  ObjectsDeleteAll(0);}
}
//+------------------------------------------------------------------+
void draw_KEY(int i)
  {
      commentt=StringSubstr(PositionGetString(POSITION_COMMENT),0,3); 
       maggic=DoubleToString(MathRound(PositionGetInteger(POSITION_MAGIC)/1000),0);
       if(commentt==""){ commentt=PositionGetSymbol(i);}
      
 

 //+------------------------------------------------------------------+ 
       if(ObjectFind(0,commentt+"("+maggic+")")==-1)
       {
if( (ObjectsTotal(0,-1,-1)/8)>=N_column ){XXX=X+1144+11  ; YYY=3.6*((ObjectsTotal(0,-1,-1)/8)-N_column)*Y; }
if( (ObjectsTotal(0,-1,-1)/8)<N_column ){XXX=X+11  ;  YYY=3.6*((ObjectsTotal(0,-1,-1)/8))*Y; }
     
         ObjectCreate(0,commentt+"("+maggic+")",OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_XDISTANCE,XXX);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_YDISTANCE,YYY);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_XSIZE,XSIZE);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_YSIZE,YSIZE);
       }
string x="M="+maggic+"|C="+commentt+"|LB="+DoubleToString(F_Lots_BUY(commentt+"("+maggic+")"),2)+"|L="+DoubleToString(F_Lots_SELL(commentt+"("+maggic+")"),2)

+"|NB="+(F_COUNTER(commentt+"("+maggic+")",POSITION_TYPE_BUY,count)) 
+"|N="+(F_COUNTER(commentt+"("+maggic+")",POSITION_TYPE_SELL,count)) 
+"|PB="+DoubleToString(F_ProfitCheck_BUY(commentt+"("+maggic+")"),0)+
"|S="+DoubleToString(F_ProfitCheck_SELL(commentt+"("+maggic+")"),0)+
"|T="+DoubleToString(F_ProfitCheck_ALL(commentt+"("+maggic+")"),0);


         ObjectSetString(0,commentt+"("+maggic+")",OBJPROP_TEXT,x);

         if(profit_ALL<0){ f=clrLightPink;}
         if(profit_ALL>0){ f=clrLightGreen;}

         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_COLOR,Black);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_BGCOLOR,f);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_BORDER_COLOR,Black);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_BORDER_TYPE,BORDER_SUNKEN);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_BACK,false);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_STATE,false);
         ObjectSetInteger(0,commentt+"("+maggic+")",OBJPROP_FONTSIZE,FONT_KEY);
//------------------------------------,,,,,,,,,

       if(ObjectFind(0,"darge"+commentt+"("+maggic+")")==-1)
       {
if( (ObjectsTotal(0,-1,-1)/8)>=N_column ){XXXX=X+1144  ; YYY=3.6*((ObjectsTotal(0,-1,-1)/8)-N_column)*Y; }
if( (ObjectsTotal(0,-1,-1)/8)<N_column ){XXXX=X  ;  YYY=3.6*((ObjectsTotal(0,-1,-1)/8))*Y; }
     
         ObjectCreate(0,"darge"+commentt+"("+maggic+")",OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_XDISTANCE,XXXX);
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_YDISTANCE,YYY);
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_XSIZE,11);
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_YSIZE,YSIZE);
       } 
 
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_COLOR,clrBrown);
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_BGCOLOR,clrBrown);
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_BORDER_TYPE,BORDER_SUNKEN);
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_BACK,false);
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_HIDDEN,false);
         ObjectSetInteger(0,"darge"+commentt+"("+maggic+")",OBJPROP_STATE,false);

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit+commentt+"("+maggic+")")==-1)
EditCreate(0,InpName_Profit+commentt+"("+maggic+")",0,XXX+696,YYY,66,YSIZE,InText_Profit,InpFont_Profit,InpFontSize_Profit,InpAlign_Profit,InpReadOnly_Profit,
InpCorner_Profit,InpColor_Profit,InpBackColor_Profit,InpBorderColor_Profit,InpBack_Profit,InSelection_Profit,InpHidden_Profit,InpZOrder_Profit);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss+commentt+"("+maggic+")")==-1)
EditCreate(0,InpName_Loss+commentt+"("+maggic+")",0,XXX+761,YYY,66,YSIZE,InText_Loss,InpFont_Loss,InpFontSize_Loss,InpAlign_Loss,InpReadOnly_Loss,
InpCorner_Loss,InpColor_Loss,InpBackColor_Loss,InpBorderColor_Loss,InpBack_Loss,InSelection_Loss,InpHidden_Loss,InpZOrder_Loss);
if(ObjectFind(0,InpName_Loss+commentt+"("+maggic+")")==-1)
{
   ObjectSetInteger(0,InpName_Loss+commentt+"("+maggic+")",OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit+commentt+"("+maggic+")")==-1)
{
   ObjectSetInteger(0,InpName_Profit+commentt+"("+maggic+")",OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}

EditTextGet(PROFIT,0,InpName_Profit+commentt+"("+maggic+")");       // text 
EditTextGet(LOSS,0,InpName_Loss+commentt+"("+maggic+")");       // text 


   if(StringToDouble(PROFIT)==0){PROFIT=DoubleToString(10000000000000000000000);}
   if(StringToDouble(LOSS)==0){LOSS=DoubleToString(-10000000000000000000000);}

   if(StringToDouble(PROFIT)<=F_ProfitCheck_ALL(commentt+"("+maggic+")")  ){F_CloseAll(commentt+"("+maggic+")"); dielet_object(commentt+"("+maggic+")");}
   if(StringToDouble(LOSS)>=F_ProfitCheck_ALL(commentt+"("+maggic+")")  ){F_CloseAll(commentt+"("+maggic+")"); dielet_object(commentt+"("+maggic+")"); }
  

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit_amount_B+commentt+"("+maggic+")")==-1)
EditCreate(0,InpName_Profit_amount_B+commentt+"("+maggic+")",0,XXX+830,YYY,66,YSIZE,InText_Profit_amount_B,InpFont_Profit_amount_B,InpFontSize_Profit_amount_B,InpAlign_Profit_amount_B,InpReadOnly_Profit_amount_B,
InpCorner_Profit_amount_B,InpColor_Profit_amount_B,InpBackColor_Profit_amount_B,InpBorderColor_Profit_amount_B,InpBack_Profit_amount_B,InSelection_Profit_amount_B,InpHidden_Profit_amount_B,InpZOrder_Profit_amount_B);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss_amount_B+commentt+"("+maggic+")")==-1)
EditCreate(0,InpName_Loss_amount_B+commentt+"("+maggic+")",0,XXX+895,YYY,66,YSIZE,InText_Loss_amount_B,InpFont_Loss_amount_B,InpFontSize_Loss_amount_B,InpAlign_Loss_amount_B,InpReadOnly_Loss_amount_B,
InpCorner_Loss_amount_B,InpColor_Loss_amount_B,InpBackColor_Loss_amount_B,InpBorderColor_Loss_amount_B,InpBack_Loss_amount_B,InSelection_Loss_amount_B,InpHidden_Loss_amount_B,InpZOrder_Loss_amount_B);
if(ObjectFind(0,InpName_Loss_amount_B+commentt+"("+maggic+")")==-1)
{
   ObjectSetInteger(0,InpName_Loss_amount_B+commentt+"("+maggic+")",OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit_amount_B+commentt+"("+maggic+")")==-1)
{
   ObjectSetInteger(0,InpName_Profit_amount_B+commentt+"("+maggic+")",OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}

EditTextGet(SET_TP_B,0,InpName_Profit_amount_B+commentt+"("+maggic+")");
if( PositionGetDouble(POSITION_TP)==0 && StringToDouble(SET_TP_B)!=0 )
{
MODIFY_BUY(commentt+"("+maggic+")",NormalizeDouble(StringToDouble(SET_TP_B),_Digits),PositionGetDouble(POSITION_SL));
}
if( PositionGetDouble(POSITION_SL)==0&& StringToDouble(SET_TP_B)!=0)
{
EditTextGet(SET_SL_B,0,InpName_Loss_amount_B+commentt+"("+maggic+")");
MODIFY_BUY(commentt+"("+maggic+")",PositionGetDouble(POSITION_TP),NormalizeDouble(StringToDouble(SET_SL_B),_Digits));
} 





  //+------------------------------------------------------------------+
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit_amount_S+commentt+"("+maggic+")")==-1)
EditCreate(0,InpName_Profit_amount_S+commentt+"("+maggic+")",0,XXX+960,YYY,66,YSIZE,InText_Profit_amount_S,InpFont_Profit_amount_S,InpFontSize_Profit_amount_S,InpAlign_Profit_amount_S,InpReadOnly_Profit_amount_S,
InpCorner_Profit_amount_S,InpColor_Profit_amount_S,InpBackColor_Profit_amount_S,InpBorderColor_Profit_amount_S,InpBack_Profit_amount_S,InSelection_Profit_amount_S,InpHidden_Profit_amount_S,InpZOrder_Profit_amount_S);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss_amount_S+commentt+"("+maggic+")")==-1)
EditCreate(0,InpName_Loss_amount_S+commentt+"("+maggic+")",0,XXX+1025,YYY,66,YSIZE,InText_Loss_amount_S,InpFont_Loss_amount_S,InpFontSize_Loss_amount_S,InpAlign_Loss_amount_S,InpReadOnly_Loss_amount_S,
InpCorner_Loss_amount_S,InpColor_Loss_amount_S,InpBackColor_Loss_amount_S,InpBorderColor_Loss_amount_S,InpBack_Loss_amount_S,InSelection_Loss_amount_S,InpHidden_Loss_amount_S,InpZOrder_Loss_amount_S);
if(ObjectFind(0,InpName_Loss_amount_S+commentt+"("+maggic+")")==-1)
{
   ObjectSetInteger(0,InpName_Loss_amount_S+commentt+"("+maggic+")",OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit_amount_S+commentt+"("+maggic+")")==-1)
{
   ObjectSetInteger(0,InpName_Profit_amount_S+commentt+"("+maggic+")",OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}

EditTextGet(SET_TP_S,0,InpName_Profit_amount_S+commentt+"("+maggic+")");
if( PositionGetDouble(POSITION_TP)==0 && StringToDouble(SET_TP_S)!=0 )
{
MODIFY_SELL(commentt+"("+maggic+")",NormalizeDouble(StringToDouble(SET_TP_S),_Digits),PositionGetDouble(POSITION_SL));
}
if( PositionGetDouble(POSITION_SL)==0&& StringToDouble(SET_TP_S)!=0)
{
EditTextGet(SET_SL_S,0,InpName_Loss_amount_S+commentt+"("+maggic+")");
MODIFY_SELL(commentt+"("+maggic+")",PositionGetDouble(POSITION_TP),NormalizeDouble(StringToDouble(SET_SL_S),_Digits));
} 


  //+------------------------------------------------------------------+

 //  Comment(F_COUNTER_COMMENT(count_COMMENT));
//--- chart window size 
   long x_distance;
   long y_distance;
//--- set window size 
   if(!ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,x_distance))
     {
      Print("Failed to get the chart width! Error code = ",GetLastError());
      return;
     }
   if(!ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0,y_distance))
     {
      Print("Failed to get the chart height! Error code = ",GetLastError());
      return;
     }
//--- define the step for changing the edit field 
   int x_step=(int)x_distance/64;
//--- set edit field coordinates and its size 
     x=XSIZE+66;
   int y=9;
   int x_size=66;
   int y_size=43;
//--- store the text in the local variable 
   string PROFIT=InText_Profit;
   string LOSS=InText_Loss;
//--- create edit field       
//--- stretch the edit field 
//--- redraw the chart and wait for 1 second 
  
   }
   
//+------------------------------------------------------------------+

void draw_KEY_ALL_ORDER(int i)
{
      commentt=StringSubstr("ALL",0,3); 
       maggic=DoubleToString(MathRound(PositionGetInteger(POSITION_MAGIC)/1000),0);
       if(commentt==""){ commentt=StringSubstr("ALL",0,3);}
      
 

 //+------------------------------------------------------------------+ 
       if(ObjectFind(0,commentt)==-1)
       {
if( (ObjectsTotal(0,-1,-1)/8)>=N_column ){XXX=X+1144+11  ; YYY=3.6*((ObjectsTotal(0,-1,-1)/8)-N_column)*Y; }
if( (ObjectsTotal(0,-1,-1)/8)<N_column ){XXX=X+11  ;  YYY=3.6*((ObjectsTotal(0,-1,-1)/8))*Y; }
     
         ObjectCreate(0,commentt,OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,commentt,OBJPROP_XDISTANCE,XXX);
         ObjectSetInteger(0,commentt,OBJPROP_YDISTANCE,YYY);
         ObjectSetInteger(0,commentt ,OBJPROP_XSIZE,XSIZE);
         ObjectSetInteger(0,commentt ,OBJPROP_YSIZE,YSIZE);
       }
string x="       "+commentt+"|LB="+DoubleToString(F_Lots_BUY(commentt),2)+"|L="+DoubleToString(F_Lots_SELL(commentt),2)

+"|NB="+(F_COUNTER(commentt ,POSITION_TYPE_BUY,count)) 
+"|N="+(F_COUNTER(commentt ,POSITION_TYPE_SELL,count)) 
+"|PB="+DoubleToString(F_ProfitCheck_BUY(commentt ),0)+
"|S="+DoubleToString(F_ProfitCheck_SELL(commentt ),0)+
"|T="+DoubleToString(F_ProfitCheck_ALL(commentt ),0);


         ObjectSetString(0,commentt,OBJPROP_TEXT,x);

         if(profit_ALL<0){ f=clrLightPink;}
         if(profit_ALL>0){ f=clrLightGreen;}

         ObjectSetInteger(0,commentt,OBJPROP_COLOR,Black);
         ObjectSetInteger(0,commentt,OBJPROP_BGCOLOR,f);
         ObjectSetInteger(0,commentt,OBJPROP_BORDER_COLOR,Black);
         ObjectSetInteger(0,commentt,OBJPROP_BORDER_TYPE,BORDER_SUNKEN);
         ObjectSetInteger(0,commentt,OBJPROP_BACK,false);
         ObjectSetInteger(0,commentt,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,commentt ,OBJPROP_STATE,false);
         ObjectSetInteger(0,commentt ,OBJPROP_FONTSIZE,FONT_KEY);
//------------------------------------,,,,,,,,,

       if(ObjectFind(0,"darge"+commentt)==-1)
       {
if( (ObjectsTotal(0,-1,-1)/8)>=N_column ){XXXX=X+1144  ; YYY=3.6*((ObjectsTotal(0,-1,-1)/8)-N_column)*Y; }
if( (ObjectsTotal(0,-1,-1)/8)<N_column ){XXXX=X  ;  YYY=3.6*((ObjectsTotal(0,-1,-1)/8))*Y; }
     
         ObjectCreate(0,"darge"+commentt ,OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_XDISTANCE,XXXX);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_YDISTANCE,YYY);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_XSIZE,11);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_YSIZE,YSIZE);
       } 
 
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_COLOR,clrBrown);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_BGCOLOR,clrBrown);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_BORDER_TYPE,BORDER_SUNKEN);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_BACK,false);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_HIDDEN,false);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_STATE,false);

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit+commentt )==-1)
EditCreate(0,InpName_Profit+commentt,0,XXX+696,YYY,66,YSIZE,InText_Profit,InpFont_Profit,InpFontSize_Profit,InpAlign_Profit,InpReadOnly_Profit,
InpCorner_Profit,InpColor_Profit,InpBackColor_Profit,InpBorderColor_Profit,InpBack_Profit,InSelection_Profit,InpHidden_Profit,InpZOrder_Profit);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss+commentt )==-1)
EditCreate(0,InpName_Loss+commentt,0,XXX+761,YYY,66,YSIZE,InText_Loss,InpFont_Loss,InpFontSize_Loss,InpAlign_Loss,InpReadOnly_Loss,
InpCorner_Loss,InpColor_Loss,InpBackColor_Loss,InpBorderColor_Loss,InpBack_Loss,InSelection_Loss,InpHidden_Loss,InpZOrder_Loss);
if(ObjectFind(0,InpName_Loss+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Loss+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Profit+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}

EditTextGet(PROFIT,0,InpName_Profit+commentt );       // text 
EditTextGet(LOSS,0,InpName_Loss+commentt );       // text 


   if(StringToDouble(PROFIT)==0){PROFIT=DoubleToString(10000000000000000000000);}
   if(StringToDouble(LOSS)==0){LOSS=DoubleToString(-10000000000000000000000);}

   if(StringToDouble(PROFIT)<=F_ProfitCheck_ALL(commentt )  ){F_CloseAll(commentt ); dielet_object(commentt );}
   if(StringToDouble(LOSS)>=F_ProfitCheck_ALL(commentt )  ){F_CloseAll(commentt ); dielet_object(commentt ); }
  

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit_amount_B+commentt )==-1)
EditCreate(0,InpName_Profit_amount_B+commentt ,0,XXX+830,YYY,66,YSIZE,InText_Profit_amount_B,InpFont_Profit_amount_B,InpFontSize_Profit_amount_B,InpAlign_Profit_amount_B,InpReadOnly_Profit_amount_B,
InpCorner_Profit_amount_B,InpColor_Profit_amount_B,InpBackColor_Profit_amount_B,InpBorderColor_Profit_amount_B,InpBack_Profit_amount_B,InSelection_Profit_amount_B,InpHidden_Profit_amount_B,InpZOrder_Profit_amount_B);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss_amount_B+commentt )==-1)
EditCreate(0,InpName_Loss_amount_B+commentt,0,XXX+895,YYY,66,YSIZE,InText_Loss_amount_B,InpFont_Loss_amount_B,InpFontSize_Loss_amount_B,InpAlign_Loss_amount_B,InpReadOnly_Loss_amount_B,
InpCorner_Loss_amount_B,InpColor_Loss_amount_B,InpBackColor_Loss_amount_B,InpBorderColor_Loss_amount_B,InpBack_Loss_amount_B,InSelection_Loss_amount_B,InpHidden_Loss_amount_B,InpZOrder_Loss_amount_B);
if(ObjectFind(0,InpName_Loss_amount_B+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Loss_amount_B+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit_amount_B+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Profit_amount_B+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit_amount_S+commentt )==-1)
EditCreate(0,InpName_Profit_amount_S+commentt ,0,XXX+960,YYY,66,YSIZE,InText_Profit_amount_S,InpFont_Profit_amount_S,InpFontSize_Profit_amount_S,InpAlign_Profit_amount_S,InpReadOnly_Profit_amount_S,
InpCorner_Profit_amount_S,InpColor_Profit_amount_S,InpBackColor_Profit_amount_S,InpBorderColor_Profit_amount_S,InpBack_Profit_amount_S,InSelection_Profit_amount_S,InpHidden_Profit_amount_S,InpZOrder_Profit_amount_S);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss_amount_S+commentt )==-1)
EditCreate(0,InpName_Loss_amount_S+commentt ,0,XXX+1025,YYY,66,YSIZE,InText_Loss_amount_S,InpFont_Loss_amount_S,InpFontSize_Loss_amount_S,InpAlign_Loss_amount_S,InpReadOnly_Loss_amount_S,
InpCorner_Loss_amount_S,InpColor_Loss_amount_S,InpBackColor_Loss_amount_S,InpBorderColor_Loss_amount_S,InpBack_Loss_amount_S,InSelection_Loss_amount_S,InpHidden_Loss_amount_S,InpZOrder_Loss_amount_S);
if(ObjectFind(0,InpName_Loss_amount_S+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Loss_amount_S+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit_amount_S+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Profit_amount_S+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}




  //+------------------------------------------------------------------+

 //  Comment(F_COUNTER_COMMENT(count_COMMENT));
//--- chart window size 
   long x_distance;
   long y_distance;
//--- set window size 
   if(!ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,x_distance))
     {
      Print("Failed to get the chart width! Error code = ",GetLastError());
      return;
     }
   if(!ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0,y_distance))
     {
      Print("Failed to get the chart height! Error code = ",GetLastError());
      return;
     }
//--- define the step for changing the edit field 
   int x_step=(int)x_distance/64;
//--- set edit field coordinates and its size 
     x=XSIZE+66;
   int y=9;
   int x_size=66;
   int y_size=43;
//--- store the text in the local variable 
   string PROFIT=InText_Profit;
   string LOSS=InText_Loss;
//--- create edit field       
//--- stretch the edit field 
//--- redraw the chart and wait for 1 second 
  
 
   }
   
   
   //+------------------------------------------------------------------+

void draw_KEY_CLOSEBY(int i)
{
      commentt=StringSubstr("CLOSEBY",0,7); 
       maggic=DoubleToString(MathRound(PositionGetInteger(POSITION_MAGIC)/1000),0);
       if(commentt==""){ commentt=StringSubstr("CLOSEBY",0,7);}
      
 

 //+------------------------------------------------------------------+ 
       if(ObjectFind(0,commentt)==-1)
       {
if( (ObjectsTotal(0,-1,-1)/8)>=N_column ){XXX=X+1144+11  ; YYY=3.6*((ObjectsTotal(0,-1,-1)/8)-N_column)*Y; }
if( (ObjectsTotal(0,-1,-1)/8)<N_column ){XXX=X+11  ;  YYY=3.6*((ObjectsTotal(0,-1,-1)/8))*Y; }
     
         ObjectCreate(0,commentt,OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,commentt,OBJPROP_XDISTANCE,XXX);
         ObjectSetInteger(0,commentt,OBJPROP_YDISTANCE,YYY);
         ObjectSetInteger(0,commentt ,OBJPROP_XSIZE,XSIZE);
         ObjectSetInteger(0,commentt ,OBJPROP_YSIZE,YSIZE);
       }
string x="       "+commentt+"|LB="+DoubleToString(F_Lots_BUY(commentt),2)+"|L="+DoubleToString(F_Lots_SELL(commentt),2)

+"|NB="+(F_COUNTER(commentt ,POSITION_TYPE_BUY,count)) 
+"|N="+(F_COUNTER(commentt ,POSITION_TYPE_SELL,count)) 
+"|PB="+DoubleToString(F_ProfitCheck_BUY(commentt ),0)+
"|S="+DoubleToString(F_ProfitCheck_SELL(commentt ),0)+
"|T="+DoubleToString(F_ProfitCheck_ALL(commentt ),0);


         ObjectSetString(0,commentt,OBJPROP_TEXT,x);

         if(profit_ALL<0){ f=clrLightPink;}
         if(profit_ALL>0){ f=clrLightGreen;}

         ObjectSetInteger(0,commentt,OBJPROP_COLOR,Black);
         ObjectSetInteger(0,commentt,OBJPROP_BGCOLOR,f);
         ObjectSetInteger(0,commentt,OBJPROP_BORDER_COLOR,Black);
         ObjectSetInteger(0,commentt,OBJPROP_BORDER_TYPE,BORDER_SUNKEN);
         ObjectSetInteger(0,commentt,OBJPROP_BACK,false);
         ObjectSetInteger(0,commentt,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,commentt ,OBJPROP_STATE,false);
         ObjectSetInteger(0,commentt ,OBJPROP_FONTSIZE,FONT_KEY);
//------------------------------------,,,,,,,,,

       if(ObjectFind(0,"darge"+commentt)==-1)
       {
if( (ObjectsTotal(0,-1,-1)/8)>=N_column ){XXXX=X+1144  ; YYY=3.6*((ObjectsTotal(0,-1,-1)/8)-N_column)*Y; }
if( (ObjectsTotal(0,-1,-1)/8)<N_column ){XXXX=X  ;  YYY=3.6*((ObjectsTotal(0,-1,-1)/8))*Y; }
     
         ObjectCreate(0,"darge"+commentt ,OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_XDISTANCE,XXXX);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_YDISTANCE,YYY);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_XSIZE,11);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_YSIZE,YSIZE);
       } 
 
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_COLOR,clrBrown);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_BGCOLOR,clrBrown);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_BORDER_TYPE,BORDER_SUNKEN);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_BACK,false);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_HIDDEN,false);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_STATE,false);

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit+commentt )==-1)
EditCreate(0,InpName_Profit+commentt,0,XXX+696,YYY,66,YSIZE,InText_Profit,InpFont_Profit,InpFontSize_Profit,InpAlign_Profit,InpReadOnly_Profit,
InpCorner_Profit,InpColor_Profit,InpBackColor_Profit,InpBorderColor_Profit,InpBack_Profit,InSelection_Profit,InpHidden_Profit,InpZOrder_Profit);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss+commentt )==-1)
EditCreate(0,InpName_Loss+commentt,0,XXX+761,YYY,66,YSIZE,InText_Loss,InpFont_Loss,InpFontSize_Loss,InpAlign_Loss,InpReadOnly_Loss,
InpCorner_Loss,InpColor_Loss,InpBackColor_Loss,InpBorderColor_Loss,InpBack_Loss,InSelection_Loss,InpHidden_Loss,InpZOrder_Loss);
if(ObjectFind(0,InpName_Loss+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Loss+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Profit+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}

EditTextGet(PROFIT,0,InpName_Profit+commentt );       // text 
EditTextGet(LOSS,0,InpName_Loss+commentt );       // text 


   if(StringToDouble(PROFIT)==0){PROFIT=DoubleToString(10000000000000000000000);}
   if(StringToDouble(LOSS)==0){LOSS=DoubleToString(-10000000000000000000000);}

   if(StringToDouble(PROFIT)<=F_ProfitCheck_ALL(commentt )  ){F_CloseAll(commentt ); dielet_object(commentt );}
   if(StringToDouble(LOSS)>=F_ProfitCheck_ALL(commentt )  ){F_CloseAll(commentt ); dielet_object(commentt ); }
  

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit_amount_B+commentt )==-1)
EditCreate(0,InpName_Profit_amount_B+commentt ,0,XXX+830,YYY,66,YSIZE,InText_Profit_amount_B,InpFont_Profit_amount_B,InpFontSize_Profit_amount_B,InpAlign_Profit_amount_B,InpReadOnly_Profit_amount_B,
InpCorner_Profit_amount_B,InpColor_Profit_amount_B,InpBackColor_Profit_amount_B,InpBorderColor_Profit_amount_B,InpBack_Profit_amount_B,InSelection_Profit_amount_B,InpHidden_Profit_amount_B,InpZOrder_Profit_amount_B);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss_amount_B+commentt )==-1)
EditCreate(0,InpName_Loss_amount_B+commentt,0,XXX+895,YYY,66,YSIZE,InText_Loss_amount_B,InpFont_Loss_amount_B,InpFontSize_Loss_amount_B,InpAlign_Loss_amount_B,InpReadOnly_Loss_amount_B,
InpCorner_Loss_amount_B,InpColor_Loss_amount_B,InpBackColor_Loss_amount_B,InpBorderColor_Loss_amount_B,InpBack_Loss_amount_B,InSelection_Loss_amount_B,InpHidden_Loss_amount_B,InpZOrder_Loss_amount_B);
if(ObjectFind(0,InpName_Loss_amount_B+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Loss_amount_B+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit_amount_B+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Profit_amount_B+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit_amount_S+commentt )==-1)
EditCreate(0,InpName_Profit_amount_S+commentt ,0,XXX+960,YYY,66,YSIZE,InText_Profit_amount_S,InpFont_Profit_amount_S,InpFontSize_Profit_amount_S,InpAlign_Profit_amount_S,InpReadOnly_Profit_amount_S,
InpCorner_Profit_amount_S,InpColor_Profit_amount_S,InpBackColor_Profit_amount_S,InpBorderColor_Profit_amount_S,InpBack_Profit_amount_S,InSelection_Profit_amount_S,InpHidden_Profit_amount_S,InpZOrder_Profit_amount_S);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss_amount_S+commentt )==-1)
EditCreate(0,InpName_Loss_amount_S+commentt ,0,XXX+1025,YYY,66,YSIZE,InText_Loss_amount_S,InpFont_Loss_amount_S,InpFontSize_Loss_amount_S,InpAlign_Loss_amount_S,InpReadOnly_Loss_amount_S,
InpCorner_Loss_amount_S,InpColor_Loss_amount_S,InpBackColor_Loss_amount_S,InpBorderColor_Loss_amount_S,InpBack_Loss_amount_S,InSelection_Loss_amount_S,InpHidden_Loss_amount_S,InpZOrder_Loss_amount_S);
if(ObjectFind(0,InpName_Loss_amount_S+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Loss_amount_S+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit_amount_S+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Profit_amount_S+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}




  //+------------------------------------------------------------------+

 //  Comment(F_COUNTER_COMMENT(count_COMMENT));
//--- chart window size 
   long x_distance;
   long y_distance;
//--- set window size 
   if(!ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,x_distance))
     {
      Print("Failed to get the chart width! Error code = ",GetLastError());
      return;
     }
   if(!ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0,y_distance))
     {
      Print("Failed to get the chart height! Error code = ",GetLastError());
      return;
     }
//--- define the step for changing the edit field 
   int x_step=(int)x_distance/64;
//--- set edit field coordinates and its size 
     x=XSIZE+66;
   int y=9;
   int x_size=66;
   int y_size=43;
//--- store the text in the local variable 
   string PROFIT=InText_Profit;
   string LOSS=InText_Loss;
//--- create edit field       
//--- stretch the edit field 
//--- redraw the chart and wait for 1 second 
  
 
   }
   
   
   //+------------------------------------------------------------------+

void draw_KEY_SET(int i)
{
      commentt=StringSubstr("SET_HEDGE",0,9); 
       maggic=DoubleToString(MathRound(PositionGetInteger(POSITION_MAGIC)/1000),0);
       if(commentt==""){ commentt=StringSubstr("SET_HEDGE",0,9);}
      
 

 //+------------------------------------------------------------------+ 
       if(ObjectFind(0,commentt)==-1)
       {
if( (ObjectsTotal(0,-1,-1)/8)>=N_column ){XXX=X+1144+11  ; YYY=3.6*((ObjectsTotal(0,-1,-1)/8)-N_column)*Y; }
if( (ObjectsTotal(0,-1,-1)/8)<N_column ){XXX=X+11  ;  YYY=3.6*((ObjectsTotal(0,-1,-1)/8))*Y; }
     
         ObjectCreate(0,commentt,OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,commentt,OBJPROP_XDISTANCE,XXX);
         ObjectSetInteger(0,commentt,OBJPROP_YDISTANCE,YYY);
         ObjectSetInteger(0,commentt ,OBJPROP_XSIZE,XSIZE);
         ObjectSetInteger(0,commentt ,OBJPROP_YSIZE,YSIZE);
       }
string x="       "+commentt+"|LB="+DoubleToString(F_Lots_BUY(commentt),2)+"|L="+DoubleToString(F_Lots_SELL(commentt),2)

+"|NB="+(F_COUNTER(commentt ,POSITION_TYPE_BUY,count)) 
+"|N="+(F_COUNTER(commentt ,POSITION_TYPE_SELL,count)) 
+"|PB="+DoubleToString(F_ProfitCheck_BUY(commentt ),0)+
"|S="+DoubleToString(F_ProfitCheck_SELL(commentt ),0)+
"|T="+DoubleToString(F_ProfitCheck_ALL(commentt ),0);


         ObjectSetString(0,commentt,OBJPROP_TEXT,x);

         if(profit_ALL<0){ f=clrLightPink;}
         if(profit_ALL>0){ f=clrLightGreen;}

         ObjectSetInteger(0,commentt,OBJPROP_COLOR,Black);
         ObjectSetInteger(0,commentt,OBJPROP_BGCOLOR,f);
         ObjectSetInteger(0,commentt,OBJPROP_BORDER_COLOR,Black);
         ObjectSetInteger(0,commentt,OBJPROP_BORDER_TYPE,BORDER_SUNKEN);
         ObjectSetInteger(0,commentt,OBJPROP_BACK,false);
         ObjectSetInteger(0,commentt,OBJPROP_HIDDEN,true);
         ObjectSetInteger(0,commentt ,OBJPROP_STATE,false);
         ObjectSetInteger(0,commentt ,OBJPROP_FONTSIZE,FONT_KEY);
//------------------------------------,,,,,,,,,

       if(ObjectFind(0,"darge"+commentt)==-1)
       {
if( (ObjectsTotal(0,-1,-1)/8)>=N_column ){XXXX=X+1144  ; YYY=3.6*((ObjectsTotal(0,-1,-1)/8)-N_column)*Y; }
if( (ObjectsTotal(0,-1,-1)/8)<N_column ){XXXX=X  ;  YYY=3.6*((ObjectsTotal(0,-1,-1)/8))*Y; }
     
         ObjectCreate(0,"darge"+commentt ,OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_XDISTANCE,XXXX);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_YDISTANCE,YYY);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_XSIZE,11);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_YSIZE,YSIZE);
       } 
 
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_COLOR,clrBrown);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_BGCOLOR,clrBrown);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_BORDER_TYPE,BORDER_SUNKEN);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_BACK,false);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_HIDDEN,false);
         ObjectSetInteger(0,"darge"+commentt ,OBJPROP_STATE,false);

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit+commentt )==-1)
EditCreate(0,InpName_Profit+commentt,0,XXX+696,YYY,66,YSIZE,InText_Profit,InpFont_Profit,InpFontSize_Profit,InpAlign_Profit,InpReadOnly_Profit,
InpCorner_Profit,InpColor_Profit,InpBackColor_Profit,InpBorderColor_Profit,InpBack_Profit,InSelection_Profit,InpHidden_Profit,InpZOrder_Profit);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss+commentt )==-1)
EditCreate(0,InpName_Loss+commentt,0,XXX+761,YYY,66,YSIZE,InText_Loss,InpFont_Loss,InpFontSize_Loss,InpAlign_Loss,InpReadOnly_Loss,
InpCorner_Loss,InpColor_Loss,InpBackColor_Loss,InpBorderColor_Loss,InpBack_Loss,InSelection_Loss,InpHidden_Loss,InpZOrder_Loss);
if(ObjectFind(0,InpName_Loss+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Loss+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Profit+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}

EditTextGet(PROFIT,0,InpName_Profit+commentt );       // text 
EditTextGet(LOSS,0,InpName_Loss+commentt );       // text 


   if(StringToDouble(PROFIT)==0){PROFIT=DoubleToString(10000000000000000000000);}
   if(StringToDouble(LOSS)==0){LOSS=DoubleToString(-10000000000000000000000);}

   if(StringToDouble(PROFIT)<=F_ProfitCheck_ALL(commentt )  ){F_CloseAll(commentt ); dielet_object(commentt );}
   if(StringToDouble(LOSS)>=F_ProfitCheck_ALL(commentt )  ){F_CloseAll(commentt ); dielet_object(commentt ); }
  

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit_amount_B+commentt )==-1)
EditCreate(0,InpName_Profit_amount_B+commentt ,0,XXX+830,YYY,66,YSIZE,InText_Profit_amount_B,InpFont_Profit_amount_B,InpFontSize_Profit_amount_B,InpAlign_Profit_amount_B,InpReadOnly_Profit_amount_B,
InpCorner_Profit_amount_B,InpColor_Profit_amount_B,InpBackColor_Profit_amount_B,InpBorderColor_Profit_amount_B,InpBack_Profit_amount_B,InSelection_Profit_amount_B,InpHidden_Profit_amount_B,InpZOrder_Profit_amount_B);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss_amount_B+commentt )==-1)
EditCreate(0,InpName_Loss_amount_B+commentt,0,XXX+895,YYY,66,YSIZE,InText_Loss_amount_B,InpFont_Loss_amount_B,InpFontSize_Loss_amount_B,InpAlign_Loss_amount_B,InpReadOnly_Loss_amount_B,
InpCorner_Loss_amount_B,InpColor_Loss_amount_B,InpBackColor_Loss_amount_B,InpBorderColor_Loss_amount_B,InpBack_Loss_amount_B,InSelection_Loss_amount_B,InpHidden_Loss_amount_B,InpZOrder_Loss_amount_B);
if(ObjectFind(0,InpName_Loss_amount_B+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Loss_amount_B+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit_amount_B+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Profit_amount_B+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}

//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Profit_amount_S+commentt )==-1)
EditCreate(0,InpName_Profit_amount_S+commentt ,0,XXX+960,YYY,66,YSIZE,InText_Profit_amount_S,InpFont_Profit_amount_S,InpFontSize_Profit_amount_S,InpAlign_Profit_amount_S,InpReadOnly_Profit_amount_S,
InpCorner_Profit_amount_S,InpColor_Profit_amount_S,InpBackColor_Profit_amount_S,InpBorderColor_Profit_amount_S,InpBack_Profit_amount_S,InSelection_Profit_amount_S,InpHidden_Profit_amount_S,InpZOrder_Profit_amount_S);
//+------------------------------------------------------------------+ 
if(ObjectFind(0,InpName_Loss_amount_S+commentt )==-1)
EditCreate(0,InpName_Loss_amount_S+commentt ,0,XXX+1025,YYY,66,YSIZE,InText_Loss_amount_S,InpFont_Loss_amount_S,InpFontSize_Loss_amount_S,InpAlign_Loss_amount_S,InpReadOnly_Loss_amount_S,
InpCorner_Loss_amount_S,InpColor_Loss_amount_S,InpBackColor_Loss_amount_S,InpBorderColor_Loss_amount_S,InpBack_Loss_amount_S,InSelection_Loss_amount_S,InpHidden_Loss_amount_S,InpZOrder_Loss_amount_S);
if(ObjectFind(0,InpName_Loss_amount_S+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Loss_amount_S+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}
   if(ObjectFind(0,InpName_Profit_amount_S+commentt )==-1)
{
   ObjectSetInteger(0,InpName_Profit_amount_S+commentt ,OBJPROP_YDISTANCE,3.6*(ObjectsTotal(0,-1,-1)/8)*Y);
}




  //+------------------------------------------------------------------+

 //  Comment(F_COUNTER_COMMENT(count_COMMENT));
//--- chart window size 
   long x_distance;
   long y_distance;
//--- set window size 
   if(!ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,x_distance))
     {
      Print("Failed to get the chart width! Error code = ",GetLastError());
      return;
     }
   if(!ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0,y_distance))
     {
      Print("Failed to get the chart height! Error code = ",GetLastError());
      return;
     }
//--- define the step for changing the edit field 
   int x_step=(int)x_distance/64;
//--- set edit field coordinates and its size 
     x=XSIZE+66;
   int y=9;
   int x_size=66;
   int y_size=43;
//--- store the text in the local variable 
   string PROFIT=InText_Profit;
   string LOSS=InText_Loss;
//--- create edit field       
//--- stretch the edit field 
//--- redraw the chart and wait for 1 second 
  
 
   }
   

void F_CloseAll(string COMMENT)
{
   for(int i=PositionsTotal()-1; i>=0; i--)
   if(pi.SelectByTicket(PositionGetTicket(i)))
          if(( StringSubstr(pi.Comment(),0,3)+"("+DoubleToString(pi.Magic(),0)+")"==COMMENT)||(pi.Comment()=="" && pi.Symbol()+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT  ) || COMMENT=="ALL")
           {
            int ticket=pi.Ticket();
            if(pi.SelectByTicket(PositionGetTicket(i))==true);
              {
               
               trade.PositionClose(pi.Ticket());
              }
          dielet_object( COMMENT);

           }

   for(int i=PositionsTotal()-1; i>=0; i--)
     if(pi.SelectByTicket(PositionGetTicket(i)))
          if(( StringSubstr(pi.Comment(),0,3)+"("+DoubleToString(pi.Magic(),0)+")"==COMMENT)||(pi.Comment()=="" && pi.Symbol()+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT  )|| COMMENT=="ALL")
           {
            int ticket=pi.Ticket();
            if(pi.SelectByTicket(PositionGetTicket(ticket))==true);
              {
               
               trade.PositionClose(pi.Ticket());
              }
          dielet_object( COMMENT);

           }
   for(int i=PositionsTotal()-1; i>=0; i--)
      if(pi.SelectByTicket(PositionGetTicket(i)))
          if(( StringSubstr(pi.Comment(),0,3)+"("+DoubleToString(pi.Magic(),0)+")"==COMMENT)||(pi.Comment()=="" && pi.Symbol()+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT  )|| COMMENT=="ALL")
           {
            int ticket=pi.Ticket();
            if(pi.SelectByTicket(PositionGetTicket(ticket))==true);
              {
    
               trade.PositionClose(pi.Ticket());
              }

           }
          dielet_object( COMMENT);
        
           }

//+------------------------------------------------------------------+



//+------------------------------------------------------------------+//+------------------------------------------------------------------+
double F_Lots_BUY(string COMMENT)
  {
   int total=PositionsTotal();
   lots_BUY=0;
   for(int cnt=total-1; cnt>=0; cnt--)
     {
      PositionSelectByTicket(PositionGetTicket(cnt));
          if(( (COMMENT=="ALL" || COMMENT=="SET_HEDGE" || COMMENT=="CLOSEBY")  && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY )|| (StringSubstr(PositionGetString(POSITION_COMMENT),0,3)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)||(PositionGetString(POSITION_COMMENT)=="" && PositionGetSymbol(cnt)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY ))
         lots_BUY+=PositionGetDouble(POSITION_VOLUME);
     }
   return (lots_BUY);
  }
//+------------------------------------------------------------------+
double F_Lots_SELL(string COMMENT)
  {
   int total=PositionsTotal();
   lots_SELL=0;
   for(int cnt=total-1; cnt>=0; cnt--)
     {
     PositionSelectByTicket(PositionGetTicket(cnt));
          if(( (COMMENT=="ALL" || COMMENT=="SET_HEDGE" || COMMENT=="CLOSEBY")  && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY )||( StringSubstr(PositionGetString(POSITION_COMMENT),0,3)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)||(PositionGetString(POSITION_COMMENT)=="" && PositionGetSymbol(cnt)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL ))
         lots_SELL+=PositionGetDouble(POSITION_VOLUME);
     }
   return (lots_SELL);
  }
//+------------------------------------------------------------------+
int F_COUNTER(string COMMENT,int cmd,int  &count)
  {
   count=0;

   for(int i=0; i<PositionsTotal(); i++)
     {
      if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
        {
          if(( StringSubstr(PositionGetString(POSITION_COMMENT),0,3)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT && PositionGetInteger(POSITION_TYPE)==cmd)
          ||(PositionGetString(POSITION_COMMENT)=="" && PositionGetSymbol(i)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT  && PositionGetInteger(POSITION_TYPE)==cmd )
          || ((COMMENT=="ALL" || COMMENT=="SET_HEDGE" || COMMENT=="CLOSEBY") && PositionGetInteger(POSITION_TYPE)==cmd ))
            count++;
        }
     }
   return(count);
  }
  //+------------------------------------------------------------------+
int F_COUNTER_HEDGE( int & N_HEDGE)
  {
   N_HEDGE=0;

   for(int i=0; i<PositionsTotal(); i++)
     {
      if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
        {
          if(  StringSubstr(PositionGetString(POSITION_COMMENT),0,9)=="SET_HEDGE"    )
            N_HEDGE++;
        }
     }
   return(N_HEDGE);
  }
//+------------------------------------------------------------------+
int F_COUNTER_COMMENT( int  &count_COMMENT)
  {
   count_COMMENT=0;
   string  COMMENT="";
   for(int i=0; i<1; i++)
     {
      if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
        
          COMMENT=PositionGetString(POSITION_COMMENT) ;
          count_COMMENT++;
    for(int i=1; i<PositionsTotal(); i++)
     {
      if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
        {
         if(  StringSubstr(PositionGetString(POSITION_COMMENT),0,3)==StringSubstr(COMMENT,0,3) ) {COMMENT=PositionGetString(POSITION_COMMENT); }
         if(  StringSubstr(PositionGetString(POSITION_COMMENT),0,3)!=StringSubstr(COMMENT,0,3) ) {COMMENT=PositionGetString(POSITION_COMMENT); count_COMMENT++; }
          
        }
     }
     }
   return(count_COMMENT);
  }
//+------------------------------------------------------------------+
int F_COUNTER_COMMENT_ALL(int  &count_ALL_COMMENT)
  {
   count_ALL_COMMENT=0;

   datetime LastTime=0;
   for(int i=0; i<PositionsTotal(); i++)
     {
      if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
        {
         if(PositionGetInteger(POSITION_TIME)>LastTime  )
           {count_ALL_COMMENT++; LastTime=PositionGetInteger(POSITION_TIME);}
        }
     }
   return(count_ALL_COMMENT);
  }
//+------------------------------------------------------------------ 
double F_ProfitCheck_ALL(string COMMENT)
  {
   profit_ALL=0;
   int total=PositionsTotal();
   for(int cnt=total-1; cnt>=0; cnt--)
     {
      PositionSelectByTicket(PositionGetTicket(cnt));
      if((StringSubstr(PositionGetString(POSITION_COMMENT),0,3)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT&& PositionGetString(POSITION_COMMENT)!="")
      || (PositionGetString(POSITION_COMMENT)=="" && PositionGetSymbol(cnt)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT)
      || ((COMMENT=="ALL" || COMMENT=="SET_HEDGE" || COMMENT=="CLOSEBY")) )
         profit_ALL+=NormalizeDouble(PositionGetDouble(POSITION_PROFIT)+pi.Commission()+pi.Swap(),3);
     }
   return(profit_ALL);
  }

//+------------------------------------------------------------------ 
double F_ProfitCheck_SELL(string COMMENT)
  {
   profit_SELL=0;
   int total=PositionsTotal();
   for(int cnt=total-1; cnt>=0; cnt--)
     {
      PositionSelectByTicket(PositionGetTicket(cnt));
      if((StringSubstr(PositionGetString(POSITION_COMMENT),0,3)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT&& PositionGetString(POSITION_COMMENT)!="")||
         (PositionGetString(POSITION_COMMENT)=="" && PositionGetSymbol(cnt)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT)|| 
         ((COMMENT=="ALL" || COMMENT=="SET_HEDGE" || COMMENT=="CLOSEBY"))  )
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
         profit_SELL+=NormalizeDouble(PositionGetDouble(POSITION_PROFIT)+pi.Commission()+pi.Swap(),3);
     }
   return(profit_SELL);
  }
//+------------------------------------------------------------------ 
double F_ProfitCheck_BUY(string COMMENT)
  {
   profit_BUY=0;
   int total=PositionsTotal();
   for(int cnt=total-1; cnt>=0; cnt--)
     {
      PositionSelectByTicket(PositionGetTicket(cnt));
      if((StringSubstr(PositionGetString(POSITION_COMMENT),0,3)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT&& PositionGetString(POSITION_COMMENT)!="")|| (PositionGetString(POSITION_COMMENT)=="" && PositionGetSymbol(cnt)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT) || 
      ((COMMENT=="ALL" || COMMENT=="SET_HEDGE" || COMMENT=="CLOSEBY") )  )
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
         profit_BUY+=NormalizeDouble(PositionGetDouble(POSITION_PROFIT)+pi.Commission()+pi.Swap(),3);
     }
   return(profit_BUY);
  }
 
//+------------------------------------------------------------------+ 
//| Create Edit object                                               | 
//+------------------------------------------------------------------+ 
bool EditCreate(const long             chart_ID=0,               // chart's ID 
                const string           name="Edit",              // object name 
                const int              sub_window=0,             // subwindow index 
                const int              x=0,                      // X coordinate 
                const int              y=0,                      // Y coordinate 
                const int              width=50,                 // width 
                const int              height=18,                // height 
                const string           text="Text",              // text 
                const string           font="Tahoma",             // font 
                const int              font_size=10,             // font size 
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // alignment type 
                const bool             read_only=false,          // ability to edit 
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                const color            clr=clrBlack,             // text color 
                const color            back_clr=clrWhite,        // background color 
                const color            border_clr=clrNONE,       // border color 
                const bool             back=false,               // in the background 
                const bool             selection=false,          // highlight to move 
                const bool             hidden=true,              // hidden in the object list 
                const long             z_order=0)                // priority for mouse click 
  {

//--- reset the error value 
   ResetLastError();
//--- create edit field 
   if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create \"Edit\" object! Error code = ",GetLastError());
      return(false);
     }
//--- set object coordinates 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set object size 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the text 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the type of text alignment in the object 
   ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
//--- enable (true) or cancel (false) read-only mode 
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
//--- set the chart's corner, relative to which object coordinates are defined 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set text color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution 
   return(true);
  }
//+------------------------------------------------------------------+
bool EditTextGet(string      &text,// text 
                 const long   chart_ID=0,  // chart's ID 
                 const string name="Edit") // object name 
  {
//--- reset the error value 
   ResetLastError();
//--- get object text 
   if(!ObjectGetString(chart_ID,name,OBJPROP_TEXT,0,text))
     {
      Print(__FUNCTION__,
            ": failed to get the text! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution 
   return(true);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void dielet_object(string COMMENT)
{
  for (int z = 0; z < 50; z++)
{
if (ObjectFind(0, COMMENT != -1)) ObjectDelete(0, COMMENT);
else break;
}
for (int g = 0; g < 50; g++)
{
if (ObjectFind(0, InpName_Profit+COMMENT != -1)) {ObjectDelete(0, InpName_Profit+COMMENT); ObjectDelete(0, InpName_Profit_amount_B+COMMENT);ObjectDelete(0, InpName_Profit_amount_S+COMMENT);ObjectDelete(0,"darge"+COMMENT); }
else break;
}
for (int h = 0; h < 50; h++)
{
if (ObjectFind(0, InpName_Loss+COMMENT != -1)) {ObjectDelete(0, InpName_Loss+COMMENT); ObjectDelete(0, InpName_Loss_amount_B+COMMENT);ObjectDelete(0,InpName_Loss_amount_S+COMMENT);}
else break;
} 


}

 
//...............................
void MODIFY_BUY(string COMMENT,double ttttp,double loooos)
{

for(int iii=0;iii<PositionsTotal();iii++)
{
if(PositionSelectByTicket(PositionGetTicket(iii))==true)
if((StringSubstr(PositionGetString(POSITION_COMMENT),0,3)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT)||(PositionGetString(POSITION_COMMENT)=="" && PositionGetSymbol(iii)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT  ))
{
if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
if(!trade.PositionModify(PositionGetTicket(iii),NormalizeDouble(loooos,_Digits),NormalizeDouble(ttttp,_Digits)))
PrintFormat("Modify buy error=",GetLastError());
}
}


}

//...............................
void MODIFY_SELL(string COMMENT,double ttttp,double loooos)
{

for(int iii=0;iii<PositionsTotal();iii++)
{
if(PositionSelectByTicket(PositionGetTicket(iii))==true)
if((StringSubstr(PositionGetString(POSITION_COMMENT),0,3)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT)||(PositionGetString(POSITION_COMMENT)=="" && PositionGetSymbol(iii)+"("+DoubleToString(PositionGetInteger(POSITION_MAGIC),0)+")"==COMMENT  ))
{
if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
if(!trade.PositionModify(PositionGetTicket(iii),NormalizeDouble(loooos,_Digits),NormalizeDouble(ttttp,_Digits)))
PrintFormat("Modify sell error=",GetLastError());
}
}


}

//+------------------------------------------------------------------+  
 double SetOrder(string symbol,int type,double lot,string com,int MagicNumber)
  {
MqlTradeRequest request;
MqlTradeResult result;
request.symbol=symbol;
request.type=type;
request.volume=lot;
request.comment=com;
request.magic=MagicNumber;
   int ticket=-1,tries=0;
   while(ticket==-1 && tries<1000)
     {
       double entry=0; if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) entry=SymbolInfoDouble(symbol,SYMBOL_BID); if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) entry=SymbolInfoDouble(symbol,SYMBOL_BID);
      trade.OrderSend(request,result);
      int err=GetLastError();
      if(ticket==-1 && err>0)
         Print("err=",err);
      if(ticket<0) tries++;
     }
     return(ticket);
  }
//+------------------------------------------------------------------+

double set_hedge(void)
{
double TYPE1=-1;
 double TYPE2=-1;
 double TYPE3=-1;
 double TYPE4=-1;
 double TYPE5=-1;
 double TYPE6=-1;
 double TYPE7=-1;
 double TYPE8=-1;
 double TYPE9=-1;
 double TYPE10=-1;
 
 double NEWTYPE1=-1;
 double NEWTYPE2=-1;
 double NEWTYPE3=-1;
 double NEWTYPE4=-1;
 double NEWTYPE5=-1;
 double NEWTYPE6=-1;
 double NEWTYPE7=-1;
 double NEWTYPE8=-1;
 double NEWTYPE9=-1;
 double NEWTYPE10=-1;

double lot1=0;
double lot2=0;
double lot3=0;
double lot4=0;
double lot5=0;
double lot6=0;
double lot7=0;
double lot8=0;
double lot9=0;
double lot10=0;

   
TYPE1=(LAST_TYP(symbol_1,tyTyTyp)) ;
TYPE2=(LAST_TYP(symbol_2,tyTyTyp)) ;
TYPE3=(LAST_TYP(symbol_3,tyTyTyp)) ;
TYPE4=(LAST_TYP(symbol_4,tyTyTyp)) ;
TYPE5=(LAST_TYP(symbol_5,tyTyTyp)) ;
TYPE6=(LAST_TYP(symbol_6,tyTyTyp)) ;
TYPE7=(LAST_TYP(symbol_7,tyTyTyp)) ;
TYPE8=(LAST_TYP(symbol_8,tyTyTyp)) ;
TYPE9=(LAST_TYP(symbol_9,tyTyTyp)) ;
TYPE10=(LAST_TYP(symbol_10,tyTyTyp)) ;
 
lot1=NormalizeDouble(F_Lots_SUM(symbol_1),2);
lot2=NormalizeDouble(F_Lots_SUM(symbol_2),2);
lot3=NormalizeDouble(F_Lots_SUM(symbol_3),2);
lot4=NormalizeDouble(F_Lots_SUM(symbol_4),2);
lot5=NormalizeDouble(F_Lots_SUM(symbol_5),2);
lot6=NormalizeDouble(F_Lots_SUM(symbol_6),2);
lot7=NormalizeDouble(F_Lots_SUM(symbol_7),2);
lot8=NormalizeDouble(F_Lots_SUM(symbol_8),2);
lot9=NormalizeDouble(F_Lots_SUM(symbol_9),2);
lot10=NormalizeDouble(F_Lots_SUM(symbol_10),2);
if(F_COUNTER_HEDGE(   countSET_HEDGEE)==0)
 {
 if(LAST_TYP(symbol_1,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE1=1;}
 else{NEWTYPE1=0;}
 if(LAST_TYP(symbol_2,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE2=1;}
 else{NEWTYPE2=0;}
 if(LAST_TYP(symbol_3,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE3=1;}
 else{NEWTYPE3=0;}
 if(LAST_TYP(symbol_4,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE4=1;}
 else{NEWTYPE4=0;}
 if(LAST_TYP(symbol_5,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE5=1;}
 else{NEWTYPE5=0;}
 if(LAST_TYP(symbol_6,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE6=1;}
 else{NEWTYPE6=0;}
 if(LAST_TYP(symbol_7,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE7=1;}
 else{NEWTYPE7=0;}
 if(LAST_TYP(symbol_8,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE8=1;}
 else{NEWTYPE8=0;}
 if(LAST_TYP(symbol_9,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE9=1;}
 else{NEWTYPE9=0;}
 if(LAST_TYP(symbol_10,tyTyTyp)==POSITION_TYPE_BUY){NEWTYPE10=1;}
 else{NEWTYPE10=0;}
 
 if(NEWTYPE1==1){
      if(symbol_1!=""){trade.Sell(lot1,symbol_1,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_1!=""){trade.Buy(lot1,symbol_1,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 
 if(NEWTYPE2==1){
      if(symbol_2!=""){trade.Sell(lot2,symbol_2,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_2!=""){trade.Buy(lot2,symbol_2,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 
 if(NEWTYPE3==1){
      if(symbol_3!=""){trade.Sell(lot3,symbol_3,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_3!=""){trade.Buy(lot3,symbol_3,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 
 if(NEWTYPE4==1){
      if(symbol_4!=""){trade.Sell(lot4,symbol_4,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_4!=""){trade.Buy(lot4,symbol_4,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 
 if(NEWTYPE5==1){
      if(symbol_5!=""){trade.Sell(lot5,symbol_5,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_5!=""){trade.Buy(lot5,symbol_5,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 
 if(NEWTYPE6==1){
      if(symbol_6!=""){trade.Sell(lot6,symbol_6,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_6!=""){trade.Buy(lot6,symbol_6,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 
 if(NEWTYPE7==1){
      if(symbol_7!=""){trade.Sell(lot7,symbol_7,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_7!=""){trade.Buy(lot7,symbol_7,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 
 if(NEWTYPE8==1){
      if(symbol_8!=""){trade.Sell(lot8,symbol_8,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_8!=""){trade.Buy(lot8,symbol_8,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 
 if(NEWTYPE9==1){
      if(symbol_9!=""){trade.Sell(lot9,symbol_9,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_9!=""){trade.Buy(lot9,symbol_9,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 
 if(NEWTYPE10==1){
      if(symbol_10!=""){trade.Sell(lot10,symbol_10,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 else{if(symbol_10!=""){trade.Buy(lot10,symbol_10,0,0,0,"SET_HEDGE"+"("+DoubleToString(MAGIC,0)+")");}}
 }

return(true);}
 
//+------------------------------------------------------------------+
double F_Lots_SUM(string symbollll)
  {
   int total=PositionsTotal();
   double lots_symbollll=0;
   for(int cnt=total-1; cnt>=0; cnt--)
     {
     PositionSelectByTicket(PositionGetTicket(cnt));
      
          if (symbollll==PositionGetSymbol(cnt)   && (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY || (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)))  
         lots_symbollll+=PositionGetDouble(POSITION_VOLUME);
     }
   return (lots_symbollll);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------
double LAST_TYP(string SYMBOL,double & tyTyp)
  {
   tyTyp=-1;
  datetime time=0;
   for(int i=0; i<PositionsTotal(); i++)
     {
      if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
      if(  SYMBOL==PositionGetSymbol(i) && PositionGetInteger(POSITION_TIME)>time  && (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY|| PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL))
        {tyTyp= PositionGetInteger(POSITION_TYPE); time=PositionGetInteger(POSITION_TIME); }
     }
   return(tyTyp);
  }


//+------------------------------------------------------------------+

double OP_TYP(double typ,double  &OP)
  {
   OP=-1;
   if(typ==POSITION_TYPE_BUY){OP=ORDER_TYPE_SELL;}
   if(typ==POSITION_TYPE_SELL){OP=ORDER_TYPE_BUY;}
   return(OP);
  }

//+------------------------------------------------------------------+

void F_CLOSEBY_ALL()
{
   for(int i=PositionsTotal()-1; i>=0; i--)
     if(PositionSelectByTicket(PositionGetTicket(i)))
            {
            string SYMBOLCL=PositionGetSymbol(i);
            LASTTICKETA(SYMBOLCL);
               trade.PositionCloseBy(TICKETA,TICKETB);
           }  
}

//+------------------------------------------------------------------+

void LASTTICKETA(string SYMBOLCL)
{
  datetime timeA=0;
  datetime timeB=0;
  TICKETA=0;
  TICKETB=0;
  int type1=0;
  int type2=0;
   for(int i=0; i<PositionsTotal(); i++)
     {
      if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
      if(  SYMBOLCL==PositionGetSymbol(i)  && (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY || PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) )
        {TICKETA= PositionGetTicket(i); timeA= PositionGetInteger(POSITION_TIME); type1=PositionGetInteger(POSITION_TYPE); }
     }
   for(int i=0; i<PositionsTotal(); i++)
     {
      if(PositionSelectByTicket(PositionGetTicket(i))==false)continue;
      if(  SYMBOLCL==PositionGetSymbol(i) &&  type1!=PositionGetInteger(POSITION_TYPE) )
        {TICKETB= PositionGetTicket(i); timeB=PositionGetInteger(POSITION_TIME); }
     }
 }

//+------------------------------------------------------------------+

