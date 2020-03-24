/*HW 3*/
proc import datafile = "H:\HW 3\wage_updated" out = wage1
dbms = csv replace;
run; 

data wage2;
set wage1;
wagey=(wage*hr);
lwage=log(wagey);
run;

proc print data=wage2(obs=10);run;

data wage3;
set wage2;
drop VAR1;
if hr = "0" then delete;run;
proc print data = wage3 (obs=10);run;

1) proc reg data=wage3;
      model lwage = age edu numkid hr married salaried selfempl locunemp/ tol vif collin corrb;
	  output out = t1 student=res1 cookd = cookd1 h = lev1;  
  run; 
  
2)
data lndata;
set wage3;
lnage = log(age);
sqage = age*age;
sqedu = edu*edu;
sqhr = hr*hr;
lnhr = log(hr);
sqfamearn = famearn * famearn;
lnfamearn = log(famearn);
run;
/EDU - non-linear/
proc reg data=lndata;
model lwage = age edu sqedu numkid hr married salaried selfempl locunemp;
run;

/famearn - non-linear/
proc reg data=lndata;
model lwage = age edu sqfamearn numkid hr married salaried selfempl locunemp famearn;
run;


3) proc model data=wage3;
   parms b0 b1 b2 b3 b4 b5 b6 b7 b8 b9;
   lwage = b0 + b1 *age  + b2 * edu + b3 * numkid + b4 * hr + b5 * married + b6 * salaried + b7 * selfempl + b8 * locunemp + b9 * famearn;
   fit lwage / white pagan = (1 age edu numkid hr married salaried selfempl locunemp famearn);
run;

/*to interpret numkid effect on wage*/
proc glmselect data= wage3;
class numkid married salaried selfempl;
model lwage  = age numkid hr married edu salaried selfempl famearn locunemp / selection = forward (select=ADJRSQ) stats = all  stb;
quit;

4)  proc panel data=wage3;
	id ID year ;
	model lwage = age edu numkid hr married salaried selfempl locunemp/ FIXONE;
  run;
  proc panel data=wage3;
	id year ID;
	model lwage = age edu numkid hr married salaried selfempl locunemp/ ranone;
  run;
  proc panel data=wage3;
	id year ID;
	model lwage = age edu numkid hr married salaried selfempl locunemp/ fixtwo ;
  run;
  proc panel data=wage3;
	id year ID;
	model lwage = age edu numkid hr married salaried selfempl locunemp/ rantwo;
  run;