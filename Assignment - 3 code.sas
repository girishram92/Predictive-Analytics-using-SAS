proc import datafile = 'H:\HW 4\pims.xls'
out = pims
dbms = xls replace;
getnames=yes;
run;

PROC SYSLIN data = pims 2SLS SIMPLE outest = result; 
ENDOGENOUS ms qual plb price dc;
INSTRUMENTS pion ef phpf plpf psc papc ncomp mktexp pnp custtyp ncust custsize penew cap rbvi emprody union ;
MODEL MS = qual plb price pion ef phpf plpf psc papc ncomp mktexp;
MODEL qual = price dc pion ef tyrp mktexp pnp;
MODEL PLB = dc pion tyrp ef pnp custtyp ncust custsize;
MODEL Price = ms qual dc pion ef tyrp mktexp pnp;
MODEL dc =ms qual pion ef tyrp penew cap rbvi emprody union; 
RUN;

proc reg data = pims;
model MS=qual plb price pion ef phpf plpf psc papc ncomp mktexp;
run;
