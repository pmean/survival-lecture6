* class6.sas
  written by Steve Simon
  October 21, 2018;

** preliminaries **;

%let path=/folders/myfolders;
%let xpath=c:/Users/simons/Documents/SASUniversityEdition/myfolders;

ods pdf file="&path/survival-lecture6/sas/class6.pdf";

libname survival
  "&path/data";
  
filename heroin
  "&path/data/heroin.txt";
  
data survival.heroin;
  infile "&path/data/heroin.txt" dlm='09'x firstobs=2;
  input id clinic status time prison dose @@;
run;

proc print
    data=survival.heroin(obs=5);
run;

proc lifetest
    notable
    outsurv=km_by_clinic
    plots=survival
    data=survival.heroin;
  time time*status(0);
  strata clinic;
  title "Comparison of survival for clinic for heroin data";
run;

proc print
    data=km_by_clinic(obs=5);
  title1 "Kaplan-Meier values";
run;

data km_by_clinic;
  set km_by_clinic;
  cloglog = log(-log(SURVIVAL));
run;

proc sgplot
    data=km_by_clinic;
  series x=time y=cloglog / group=clinic;
  title1 "Complementary log-log plot";
run;

proc lifetest
    notable
    plots=survival
    data=survival.heroin;
  time time*status(0);
  strata prison;
  title "Comparison of survival for clinic for heroin data";
run;

proc lifetest
    notable
    plots=survival
    data=survival.heroin;
  time time*status(0);
  strata dose(40, 50, 60, 70);
  title "Comparison of survival for dose groups for heroin data";
run;


ods pdf close;
