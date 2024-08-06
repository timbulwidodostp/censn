** MLE function for censored skew-normal regression
** Author: André Moser

** Institute of Social and Preventive Medicine (ISPM)
** University of Bern
** Finkenhubelweg 11
** CH-3012 Bern
** Switzerland

** Date: 31th May 2016

** Reference: Moser et al. (2015), Modeling absolute differences in life expectancy with a censored skew-normal regression approach. PeerJ 3:e1162; DOI 10.7717/peerj.1162

** Remark: Location and scale parameter in centered parametrisation; Shape parameter has to be converted from DP to CP via eq (A1) in the Supplemental Information in Moser et al. (2015)

program define sn_ltrun
	version 11.0
	args logl mu sigma alph
	
	local failure "$S_cen"
   	local ltrun "$S_ltrun"
	
	quietly replace `logl'=  cond(`failure'==1,ln(sqrt(1-2/_pi*`alph'^2/(1+`alph'^2))/`sigma')-0.5*(sqrt(2/_pi)*`alph'/sqrt(1+`alph'^2)+sqrt(1-2/_pi*`alph'^2/(1+`alph'^2))*(($ML_y1-`mu')/`sigma'))^2+ln(normal(`alph'*(sqrt(2/_pi)*`alph'/sqrt(1+`alph'^2)+sqrt(1-2/_pi*`alph'^2/(1+`alph'^2))*(($ML_y1-`mu')/`sigma'))))-ln(1-2*(binormal(0,sqrt(2/_pi)*`alph'/sqrt(1+`alph'^2)+((`ltrun'-`mu')/`sigma')*sqrt(1-2/_pi*`alph'^2/(1+`alph'^2)), -`alph'/( sqrt(1+`alph'^2) )))),ln(1-2*(binormal(0,sqrt(2/_pi)*`alph'/sqrt(1+`alph'^2)+sqrt(1-2/_pi*`alph'^2/(1+`alph'^2))*(($ML_y1-`mu')/`sigma'), -`alph'/( sqrt(1+`alph'^2) ))))-ln(1-2*(binormal(0,sqrt(2/_pi)*`alph'/sqrt(1+`alph'^2)+((`ltrun'-`mu')/`sigma')*sqrt(1-2/_pi*`alph'^2/(1+`alph'^2)), -`alph'/( sqrt(1+`alph'^2) )))))
  
end
