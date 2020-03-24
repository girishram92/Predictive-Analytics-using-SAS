LIBNAME cc 'H:\HW5';
DATA a1;
SET cc.CC10;
proc print data=a1 (obs=10);RUN;

proc means data = a1 N Mean Mode Median Min Max nmiss;
run;

proc means data=a1;var age dur;run;

proc freq data=a1;table age dur;run;

data a1;
set a1;
if age = .
 then age=45;
if dur=.
 then dur=37;run;
proc print data=a1 (obs=10);run;

data a1;
set a1;
if tottrans = 0
 then active = 0;
else
 active = 1;
climit = limit/10000;
ttrans = tottrans/10000;
profit = totfc + ((1.6/100)*totrans);
run;
proc print data=a1 (obs=10);RUN;

proc means data=a1;var profit;run;

data a1;
set a1;
if profit < 0
 then profit = 0;
run;

proc print data=a1 (obs=10);RUN;

proc means data = a1 nmiss;
run;

/*tobit*/

proc qlim data=a1;
   model profit = age ttrans rewards climit numcard dm ds ts net standard gold platinum quantum sectorA sectorB sectorC sectorD sectorE sectorF;
   endogenous profit ~ censored(lb=0);
run;

/*selection model*/

proc qlim data=a1;
   model active = age rewards climit numcard dm ds ts net standard gold platinum quantum sectorA sectorB sectorC sectorD sectorE sectorF /discrete;
   model totfc = age ttrans rewards climit numcard dm ds ts net standard gold platinum quantum sectorA sectorB sectorC sectorD sectorE sectorF / select(active=1);
run;

/*survival analysis*/

data a1;
set a1;
if dur=37
 then censor=1;
else
 censor = 0;
 run;
proc print data=a1 (obs=10);RUN;

proc freq data=a1; table censor;run;

/*a.proportional hazard model*/

proc phreg data=a1;
   model dur*censor(1)= age ttrans rewards climit numcard dm ds ts net standard gold platinum quantum sectorA sectorB sectorC sectorD sectorE sectorF;
run;

proc lifereg data = a1;
  model dur*censor(1)= age ttrans rewards climit numcard dm ds ts net standard gold platinum quantum sectorA sectorB sectorC sectorD sectorE sectorF/covb distribution=weibull;
run;

proc lifetest data=a1;
time dur*censor(1);
strata sectorA sectorB sectorC sectorD sectorE sectorF;
run;
