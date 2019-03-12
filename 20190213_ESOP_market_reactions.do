/*Created: 13/02/2019
Last updated: 13/02/2019
Project: Employee Stock Options
For use with: SIRCA CRD and AEOD
Programming environment: STATA
Version: 15.1
Author: Sam Sherry
Objective: Calculate market reactions to ESS policy announcements*/

/* Set location of working directory*/
cd "C:\Users\12219352\Documents\stata\working"
clear all

/* MARKET REACTIONS TO ESS POLICY ANNOUNCEMENTS*/

/* Label event days*/
use prices_combined, clear
sort ticker date
gen date_num=date, after(date)
gen year=year(date),after(stockcode)
sort ticker year
save prices_combined, replace

/* Import list of firms with employee share plans*/
import delimited ess_firmlist.csv, varnames(1) clear
gen date=date(releasedate,"DMY"),after(instrument)
format %td date
drop releasedate
rename instrument ticker 
drop announcementheader
drop if date==.
sort ticker
duplicates drop ticker, force
keep ticker 
gen ess_firm=1
save ess_firm, replace
merge 1:m ticker using prices_combined 
drop if _merge==1
drop _merge
replace ess_firm=0 if ess_firm==.
summ
sort ticker year
save prices_combined, replace

/* Import option plan firms*/
use 3B_firmlist, clear
sort ticker
duplicates drop ticker, force
drop ann_date
rename optionplan_3B esop_firm
summ
save esop_firms, replace
merge 1:m ticker using prices_combined
drop if _merge==1
drop _merge
replace esop_firm=0 if esop_firm==.
gen neither=1 if esop_firm==0 & ess_firm==0 
replace neither=0 if neither==.
summ

/* Set as panel data*/
sort ticker date
encode ticker, gen(newcode)
order newcode
sort newcode date
duplicates report newcode date
xtset newcode date
by newcode: gen stkret=ln(close[_n]/close[_n-1])
sort date
save prices_event_study, replace

/* Import market prices*/
import delimited AORD_Jul04_Dec16.csv, varnames(1) clear
drop open high low adjclose volume
gen datevar=date(date,"DMY")
format %td datevar
drop date
rename datevar date
rename close aord
order date
sort date
tsset date
gen mktret=ln(aord[_n]/aord[_n-1])
save aord, replace

/* Merge market prices with daily price data*/
use aord, clear
merge 1:m date using prices_event_study
sort newcode date
keep if _merge==3
drop _merge
order newcode ticker date
save prices_event_study, replace

/* 2009 Policy Changes*/
/* Event I - 12 May 2009*/
/* Note budget handed down in evening, so day 0 is 13 May*/
/* Note - include firms with share plans and option plans*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==18030
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event II - 25 May 2009*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==18042
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event III - 5 June 2009*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==18053
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event IV - 1 July 2009*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==18079
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event V - 14 August 2009*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==18123
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event VI - 21 October 2009*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==18191
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event VII - 2 December 2009*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==18233
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* 2015 Policy Changes*/
/* Note - only include option plans only*/
/* Event I - 1 August 2014*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==19936
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event II - 14 October 2014*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==20010
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event III - 14 January 2015*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==20102
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event IV - 25 March 2015*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==20172
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal

/* Event V - 25 June 2015*/
use prices_event_study, clear
by newcode: gen day_cnt=_n
gen target_day=day_cnt if date_num==20264
by newcode: egen max_target_day=max(target_day)
gen evday=day_cnt-max_target_day 
drop day_cnt target_day max_target_day
drop if evday==.
sort evday
gen evt_window=1 if evday>=-1 & evday<=1 /*event window (-1,1)*/
gen est_window=1 if evday<=-10 & evday>=-365 /*estimation window (-365,-10)*/
drop if evt_window==. & est_window==.
sort newcode date
gen ar=stkret-mktret
drop if evt_window==.
sort newcode date
by newcode: egen car=sum(ar) if evt_window==1
keep if evday==1
bysort ess_firm: summ car, detail
tabstat car, by(ess_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(ess_firm) unequal
tabstat car, by(esop_firm) statistics (N mean median sd min max) columns(statistics)
estpost ttest car, by(esop_firm) unequal
