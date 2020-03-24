/*Groc prod dataset*/
LIBNAME cc 'H:\Peanut Butter';
/*importing prod_peanut butter xls file for brand names*/
proc import datafile = 'H:\Peanut Butter\prod_peanbutr.xls'
out = pnut_butr
dbms = xls
replace;
run;
/*dropping unwanted variables*/
data pnut_butr;
set pnut_butr (drop = L1 L2 Level SY GE VEND ITEM _STUBSPEC_1542RC);
run;

proc print data = pnut_butr(obs =10); run;

/*removing ounces into a separate column*/
data prod_p_butr_fin;
set pnut_butr;
n_ounces =SUBSTR(L9,length(L9)-3,4);
ounces = input(substr (n_ounces, 1, length(n_ounces)-2),2.);
run;
proc print data = prod_p_butr_fin; var ounces; run;
proc contents data = prod_p_butr_fin; run;

/*renaming variables as desired*/
data prod_pbutr;
set prod_p_butr_fin (drop = n_ounces L9);
rename L3= Owner L4 = Company L5 = Brand;
run;
proc print data = prod_pbutr (obs =10); run;

/*importing the groceries scanner data file*/
DATA groc;
INFILE 'H:\Peanut Butter\peanbutr_groc_1114_1165.txt' FIRSTOBS=2;
INPUT IRI_KEY 1-7 WEEK 9-12 SY 14-15  GE 17-18 VEND 20-24  ITEM 26-30  UNITS 32-36 DOLLARS 38-45  F $ 47-50  D 52 PR 54;
RUN;

proc print data = groc (obs =10); run;


/*For merging creating UPC column with sy, ge, vend & item columns in groc file*/
data groc_new(drop = sy_n ge_n vend_n item_n sy ge vend item);
set groc;
sy_n = put(sy, z2.);
ge_n = put (ge, z2.);
vend_n = put (vend, z5.);
item_n = put (item, z5.);
upc = cats(sy_n,'-',ge_n,'-',vend_n,'-',item_n);
run;

proc print data = groc_new (obs =50); run;


/*joining prod peanut butter xls file with groc file using UPC*/ 
proc sql;
create table groc_l as
select A.*,B.* from groc_new as A left join prod_pbutr as B on A.upc=B.upc;
quit;

proc print data = groc_l (obs = 5000); run;
proc contents data = groc_l; run;

/*import IRI_week translation file*/
proc import datafile = 'H:\Peanut Butter\IRI week translation.xls'
out = iri_week
dbms = xls
replace;
run;

data iri_wk(drop = D Calendar_date IRI_week_1);
set iri_week;
run; 

proc print data = iri_wk; run;
proc contents data = iri_wk; run;

/*joining updated groc file with iri week translation file*/
proc sql;
create table groc_lates as
select C.*, D.* from groc_l as C left join iri_wk as D on C.WEEK=D.IRI_Week;
quit;
proc print data = groc_lates(obs = 1000);run; 

/*proc print data = groc_lates; 
var IRI_KEY WEEK UNITS DOLLARS F D PR upc Owner Company Brand VOL_EQ ounces week Calendar_week_starting_on Calendar_week_ending_on;
where week = 1114;
run;*/
proc contents data = groc_lates; run;

/*creating price/ounce column*/
data groc_fin (drop = m);
set groc_lates;
m = dollars/units;
dol_unit_ounce = m/ounces;
run;
proc print data = groc_fin (obs =10); run;
proc freq data = groc_fin order = freq; table  IRI_key; run;

/*importing delivery stores file*/
data ds;
infile "H:\Peanut Butter\Delivery_Stores.txt" FIRSTOBS = 2 ;
input IRI_KEY 1-7 OU $ 9-10 Market_Name $ 21-44 Open 46-49 Clsd 51-54 MskdName $ 56-63;
run;
proc print data = ds (obs =10);run;
proc freq data =ds  order = freq; table  IRI_key; run;

/*joining delivery stores and groc_fin using IRI key*/
proc sql;
create table groc_fin2 as
select E.*, F.* from groc_fin as E left join ds as F on E.Iri_Key=F.IRI_key;
quit;
proc print data = groc_fin2 (obs =10);run;

proc freq data =groc_fin2  order = freq; table  Brand; run;

/*Combining like brands together*/
data groc_fin3;
set groc_fin2;
if Brand in ('JIF','JIF SMOOTH SENSATIONS', 'SIMPLY JIF' ) then Brand='JIF';
if Brand in ('SKIPPY', 'SKIPPY SUPER CHUNK', 'SKIPPY DOUBLY DELICIOUS') then Brand = 'SKIPPY';
if Brand in ('PETER PAN','PETER PAN SMART CHOICE', 'PETER PAN PLUS') then Brand = 'PETER PAN';
if Brand not in ('JIF', 'PRIVATE LABEL', 'SKIPPY', 'PETER PAN', 'SMUCKERS', 'REESES') then Brand = 'OTHER';
if D = 1 or D = 2 then DISP = 1; else DISP = 0;
if F ne ('NONE') then FEATURE = 1; else FEATURE = 0;
run;
proc freq data =groc_fin3 order = freq; table  Brand; run;
proc print data = groc_fin3 (obs =10);run;


/*export final data as txt*/
libname cc "H:\Peanut Butter";
run;
proc export data=groc_fin3
outfile="H:\Peanut Butter\groc_fin3.txt"
dbms= TAB
replace; PUTNAMES = YES;
run;
/**/
proc sql;
create table sales_by_brand AS SELECT DISTINCT Brand, sum(dol_unit_ounce) as Dollar_Sales_per_ounce
FROM groc_fin3
GROUP BY Brand
ORDER BY Dollar_Sales_per_ounce DESC; quit;
proc print data = sales_by_brand; run;

/* subsetting data only for top 3 brands*/
data groc_fin3;
set groc_fin3;
where brand in ('JIF','PETER PAN','PRIVATE LABEL');
run;

/*************/
/*calculating total units sold *//**/
proc sql;
create table annual_units as select sum(units)as total_units from groc_fin3;
quit;
proc print data = annual_units (obs =10);run;

/* total_units=21773768*/
/**/
data groc_fin3;
set groc_fin3;
Total_Annual_Units=.;
run;
proc print data = groc_fin3 (obs =10); run;

/*Dollar Sales of Brands*/
proc means sum data= groc_fin3 maxdec=2;
var dol_unit_ounce;
class Brand;
output out=dollarb(where=(_Type_=1)) sum=Dollar_Sales;
run;

proc sort data=dollarb;
by descending Dollar_Sales;
run;

proc print data=dollarb;
var brand _FREQ_ Dollar_Sales;
run;


/*market share in terms of units sales*/
proc means sum data= groc_fin3 maxdec=2;
var Units;
class Brand;
output out=unitsb(where=(_Type_=1)) sum=units_by_brand;
run;

proc sort data=unitsb;
by descending units_by_brand;
run;

proc print data=unitsb;
var brand _FREQ_ units_by_brand;
run;

proc sql;
update groc_fin3
set Total_Annual_Units=(select sum(units_by_brand) from unitsb);
quit;
proc print data = groc_fin3 (obs =10); run;

data groc_fin3;
set groc_fin3;
units_by_brand = .;
run;
proc sql;
update groc_fin3 as u
   set units_by_brand=(select units_by_brand from unitsb as n
			where u.brand=n.brand)
		where u.brand in (select brand from unitsb);
quit;
proc print data = groc_fin3 (obs =10); run;

data groc_fin3;
set groc_fin3;
market_share=(Units_by_brand/Total_Annual_Units);
run;
proc print data = groc_fin3 (obs =10); run;

/*weighted columns*/

data groc_fin3;
set groc_fin3;
format weighted_PR 4.2 weighted_Disp 4.2 weighted_Feature 4.2 weighted_price_per_ounce 4.2;
weighted_Disp= DISP*Market_share;
weighted_Feature= FEATURE*Market_share;
weighted_price_per_ounce= dol_unit_ounce*Market_share;
weighted_PR=PR*Market_share;run;

proc print data = groc_fin3 (obs =100); run;

data JIF PETER_PAN PRIVATE_LABEL;
set groc_fin3;
if brand = 'JIF' then output JIF;
else if brand = 'PETER PAN' then output PETER_PAN;
else if brand = 'PRIVATE LABEL' then output PRIVATE_LABEL;
run;
proc print data = JIF (obs = 10); run;

data JIF;
set JIF;
format wt_price_brand1 4.2 PR_wt_brand1 4.2 disp_wt_brand1 4.2 Feature_wt_brand1 4.2;
wt_price_brand1 = weighted_price_per_ounce;
PR_wt_brand1 = weighted_PR;
disp_wt_brand1 = weighted_Disp;
Feature_wt_brand1 = weighted_Feature;
run;

data PETER_PAN;
set PETER_PAN;
format wt_price_brand2 4.2 PR_wt_brand2 4.2 disp_wt_brand2 4.2 Feature_wt_brand2 4.2;
wt_price_brand2 = weighted_price_per_ounce;
PR_wt_brand2 = weighted_PR;
disp_wt_brand2 = weighted_Disp;
Feature_wt_brand2 = weighted_Feature;
run;

data PRIVATE_LABEL;
set PRIVATE_LABEL;
format wt_price_brand3 4.2 PR_wt_brand3 4.2 disp_wt_brand3 4.2 Feature_wt_brand3 4.2;
wt_price_brand3 = weighted_price_per_ounce;
PR_wt_brand3 = weighted_PR;
disp_wt_brand3 = weighted_Disp;
Feature_wt_brand3 = weighted_Feature;
run;


data JIF;
set JIF;
format price_PR1 4.2 price_F1 4.2 PR_F1 4.2;
price_PR1 = wt_price_brand1*PR_wt_brand1;
price_F1 = wt_price_brand1*Feature_wt_brand1;
PR_F1 = PR_wt_brand1*Feature_wt_brand1;
run;

data PETER_PAN;
set PETER_PAN;
format price_PR2 4.2 price_F2 4.2 PR_F2 4.2;
price_PR2 = wt_price_brand2*PR_wt_brand2;
price_F2 = wt_price_brand2*Feature_wt_brand2;
PR_F2 = PR_wt_brand2*Feature_wt_brand2;
run;

data PRIVATE_LABEL;
set PRIVATE_LABEL;
format price_PR3 4.2 price_F3 4.2 PR_F3 4.2;
price_PR3 = wt_price_brand3*PR_wt_brand3;
price_F3 = wt_price_brand3*Feature_wt_brand3;
PR_F3 = PR_wt_brand3*Feature_wt_brand3;
run;

data final_groc;
set JIF PETER_PAN PRIVATE_LABEL;
 
if wt_price_brand2 = '.' then wt_price_brand2= 0;
if PR_wt_brand2 = '.' then PR_wt_brand2= 0;
if disp_wt_brand2 = '.' then disp_wt_brand2= 0;
if Feature_wt_brand2 = '.' then Feature_wt_brand2= 0;
if price_PR2 = '.' then price_PR2= 0;
if price_F2 = '.' then price_F2= 0;
if PR_F2 = '.' then PR_F2= 0;

if wt_price_brand1 = '.' then wt_price_brand1 = 0;
if PR_wt_brand1= '.' then PR_wt_brand1= 0;
if disp_wt_brand1 = '.' then disp_wt_brand1= 0;
if Feature_wt_brand1 = '.' then Feature_wt_brand1= 0;
if price_PR1 = '.' then price_PR1= 0;
if price_F1 = '.' then price_F1= 0;
if PR_F1= '.' then PR_F1= 0;

if wt_price_brand3 = '.' then wt_price_brand3= 0;
if PR_wt_brand3 = '.' then PR_wt_brand3= 0;
if disp_wt_brand3 = '.' then disp_wt_brand3= 0;
if Feature_wt_brand3 = '.' then Feature_wt_brand3= 0;
if price_PR3 = '.' then price_PR3= 0;
if price_F3 = '.' then price_F3= 0;
if PR_F3 = '.' then PR_F3= 0;
run;

proc print data = final_groc (obs =10); run;

/*creating total ounces sold column*/
data final_groc;
set final_groc;
total_ounces_sold=units*ounces;
run;
proc print data = final_groc (obs =10); run;

proc reg data = final_groc;
model total_ounces_sold = wt_price_brand1 wt_price_brand2 wt_price_brand3 
					disp_wt_brand1 disp_wt_brand2 disp_wt_brand3 
					Feature_wt_brand1 Feature_wt_brand2 Feature_wt_brand3 
					PR_wt_brand1 PR_wt_brand2 PR_wt_brand3 
					price_PR1 price_PR2 price_PR3 
					price_F1 price_F2 price_F3 
					PR_F1 PR_F2 PR_F3; 
					run;
proc means data = final_groc;
var dol_unit_ounce; class brand; run;

proc means data = final_groc;
var total_ounces_sold ; class brand; run;


/*Model -2 */

proc freq data= groc_fin3;
table product_type sugar_content size PROCESS TEXTURE FLAVOR_SCENT SALT_SODIUM_CONTENT;
run;
/*For the brand PETER PAN, 
size is missing for more than 95% of the records, 
Process is missing for more than 99% of the records, 
salt/sodium content is missing for more than 80% of the records. 
So considering only Flavor/scent Texture, Sugar content and Product type for analysis.*/

data PETER_PAN;
set PETER_PAN;
total_ounces_sold=units*ounces;
run;

/*doing anova test to check whether sales differ for different Flavor_scent*/
proc anova data= PETER_PAN;
class Flavor_scent;
model total_ounces_sold = Flavor_scent;
run;

/*Anova test result is significant */

/*doing anova test to check whether sales differ for different Sugar_content*/
proc anova data= PETER_PAN;
class sugar_content;
model total_ounces_sold = sugar_content;
run;
/*Anova test result is significant */

/*doing anova test to check whether sales differ for different product_type*/
proc anova data= PETER_PAN;
class product_type;
model total_ounces_sold = product_type;
run;
/*Anova test result is significant */

/*doing anova test to check whether sales differ for different texture*/
proc anova data= PETER_PAN;
class texture;
model total_ounces_sold = texture;
run;
/*Anova test result is significant */

/*==========================================*/

/*Model -3*/
proc import datafile = 'h:\final\fp.csv'
 out = p
 dbms = CSV
 replace
 ;
run;
proc print data = p(obs =10); run;

proc panel data=p;
class marital_status combined_pre_tax_income_of_hh hh_age hh_edu hh_occ male_working_hour_code marital_status children_group_code;
id panid week;
model luo = combined_pre_tax_income_of_hh family_size hh_age hh_edu hh_occ male_working_hour_code marital_status children_group_code number_of_dogs /ranone plots=none;
run;
