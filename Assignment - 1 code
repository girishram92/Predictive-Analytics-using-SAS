proc import datafile = 'H:\HW 2\peanut.txt'
out = pnut_butr
dbms = tab
replace;
run;
proc print data = pnut_butr(obs =10); run;


data ds;
infile "H:\HW 2\Delivery_Stores.txt" FIRSTOBS = 2 ;
input IRI_KEY 1-7 OU $ 9-10 Market_Name $ 21-44 Open 46-49 Clsd 51-54 MskdName $ 56-63;
run;
proc print data = ds (obs =10);run;


proc sql;
create table pnutbtr as select pnut_butr.*,ds.* from pnut_butr, ds where pnut_butr.IRI_KEY = ds.IRI_KEY;quit;
proc print data = pnutbtr (obs =10);run;

data final;
set pnutbtr(drop = L1 Level STUBSPEC_1542RC________________ SY GE VEND ITEM);
run;
proc print data = final (obs =10);run;

data final;
set final (rename = (F = Feature D = Display PR = Price_Reduction L2 = P_Butter_type L3= Owner L4 = Company L5 = Brand ));
run;


1)proc sql Outobs = 6 ;
create table sales_by_brand AS SELECT DISTINCT Brand, sum(DOLLARS) as Dollar_Sales
FROM final
GROUP BY Brand
ORDER BY Dollar_Sales DESC; quit;
proc print data = sales_by_brand; run;

proc sql;
select Brand, DOLLAR_SALES, ((DOLLAR_SALES/sum(DOLLAR_SALES))*100) AS MARKET_SHARE 
FROM sales_by_brand 
ORDER BY DOLLAR_SALES DESC ;quit;

2) PROC TABULATE data= final order=freq;
CLASS Brand Company;
VAR DOLLARS;
TABLE Company*Brand,
      DOLLARS*(SUM) ;
RUN;

3) data final;
set final;
if Brand not in ('JIF', 'PRIVATE LABEL', 'SKIPPY','PETER PAN','SKIPPY SUPER CHUNK','SMUCKERS') then Brand = 'OTHER';
run;
proc freq data =final order = freq; table  Brand; run;

4) proc sql;
create table four AS
select WEEK,Brand,Display, Feature, (DOLLARS/UNITS) AS PRICE_PER_UNIT FROM final;
quit;
proc means data= four; var PRICE_PER_UNIT; class Brand Display Feature;run;

5)proc tabulate data = final order = freq out = test; class Market_Name; var dollars; table Market_Name, dollars * (SUM); run; 
proc report data = test out = test;  define dollars_sum / order descending ;run;
proc print data = test(obs = 5); var Market_Name dollars_sum; run;

6) proc tabulate data = final order = freq out = sixth; class MskdName; var dollars; table MskdName, dollars * (SUM); run;
proc report data = sixth out = sixth;  define dollars_sum / order descending ;run;
proc print data = sixth(obs =10); var MskdName dollars_sum;run;

7)
proc sql;
create table week_sales_by_brand AS
select WEEK,Brand,(DOLLARS/UNITS) AS PRICE_PER_UNIT FROM final;
quit;

proc print data=week_sales_by_brand (obs=10);run;
proc tabulate data = week_sales_by_brand out = seven ; class week Brand; 
var PRICE_PER_UNIT; table Week,PRICE_PER_UNIT * Brand *(MEAN); run;

proc sgplot data= seven;
vline week / response=PRICE_PER_UNIT_Mean GROUP= Brand;
ods graphics on / width=10in height=5in;
run;

9) data q9;
set final;
if MskdName in ('Chain55', 'Chain122', 'Chain30') then MskdName = 'LARGE';
else if MskdName in ('Chain137', 'Chain5', 'Chain69') then MskdName = 'SMALL';
run;
quit;
proc print data=q9 (obs=10000);run;

proc sql;
create table ninth as Select *,(DOLLARS/UNITS) AS PRICE_PER_UNIT from q9 where Brand = 'JIF';quit;
proc print data=ninth (obs=10);run;

proc sql;
create table nine_fin as select * from nine_fin where MskdName = 'LARGE' or MskdName = 'SMALL'; quit;
proc print data = nine_fin (obs = 1000); run; 

proc ttest data = ni_fin ;var PRICE_PER_UNIT; class MskdName;run;

10) 
/Market_Name/

proc sql;
create table mkt_nam as Select Market_Name,DOLLARS from final where Brand = 'JIF';quit; 
proc anova data=mkt_nam;class Market_Name;model DOLLARS=Market_Name;run;

/Feature/

proc sql;
create table feat as Select Feature,DOLLARS from final where Brand = 'JIF';quit; 
proc anova data=feat;class Feature;model DOLLARS=Feature;run;

/Display/
proc ttest data=final;class Price_Reduction;var DOLLARS;run;

11) proc sql;
create table q10 as select *,(DOLLARS/UNITS) AS PRICE_PER_UNIT from final;run;
proc sql;
create table q11 as select WEEK,Brand,UNITS,DOLLARS,PRICE_PER_UNIT,Price_Reduction,Display,Feature from q10 where Brand in ('JIF');quit;
proc sql;
create table q12 as select WEEK, Price_Reduction,Display,Feature, AVG(PRICE_PER_UNIT) AS AVG_PRICE_PER_UNIT, AVG(DOLLARS) AS WEEKLY_DOLLAR_SALES from q11 group by week;quit;
proc print data=q12 (obs=15);run;


proc glmselect data=q12;
class Price_Reduction Display Feature;
model WEEKLY_DOLLAR_SALES  = Price_Reduction Display Feature AVG_PRICE_PER_UNIT / selection = backward(select=ADJRSQ) stats = all  stb;
quit;

11) d)
data qlog;
      set q12;
     logsales = log(WEEKLY_DOLLAR_SALES );
	 logprice = log(AVG_PRICE_PER_UNIT);
   run;
   proc print data=qlog (obs=10);run;
proc glmselect data=qlog;
class Price_Reduction Display Feature;
model logsales  = Price_Reduction Display Feature logprice / selection = backward(select=ADJRSQ) stats = all  stb;
quit;

11) f)
proc glmselect data=q12;
class Price_Reduction Display Feature;
model WEEKLY_DOLLAR_SALES  = Price_Reduction Display Feature AVG_PRICE_PER_UNIT Display*Feature*AVG_PRICE_PER_UNIT / selection = backward(select=ADJRSQ) stats = all  stb;
quit;

11 g)
data qsquare;
      set q12;
      sqprice = AVG_PRICE_PER_UNIT*AVG_PRICE_PER_UNIT;
   run;
   proc print data=qsquare (obs=10);run;

proc glmselect data=qsquare;
class Price_Reduction Display Feature;
model WEEKLY_DOLLAR_SALES  = Price_Reduction Display Feature AVG_PRICE_PER_UNIT sqprice/ selection = backward(select=ADJRSQ) stats = all  stb;
quit;

11) h)
proc reg data=q12;
model WEEKLY_DOLLAR_SALES  = Price_Reduction Display AVG_PRICE_PER_UNIT / TOL VIF COLLIN;
quit;

11) i)
proc model data=q12;
   parms b0 b1 b2 b3;
   WEEKLY_DOLLAR_SALES = b0 + b1 * pr + b2 * pd + b3*AVG_PRICE_PER_UNIT;
   fit WEEKLY_DOLLAR_SALES / white breusch =(1 pr pd AVG_PRICE_PER_UNIT););
run;

proc model data=q12;
parms b0 b1 b2 b3;
AVG_PRICE_PER_UNIT_INV=1/AVG_PRICE_PER_UNIT;
WEEKLY_DOLLAR_SALES = b0 + b1 * pr + b2 * pd + b3*AVG_PRICE_PER_UNIT;
fit WEEKLY_DOLLAR_SALES / white ;
weight AVG_PRICE_PER_UNIT_INV;
run;