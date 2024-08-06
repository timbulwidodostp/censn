{smcl}
{* *! version 1.0  31may2016}{...}
{cmd:help censn}, Version 1.1, 31 May 2016
{hline}

{title:Title}

{phang}
{bf:censn} {hline 2} Censored skew-normal regression with delayed entry


{title:Syntax}

{p 8 17 2}
{cmdab:censn}
[{depvar}]
[{varlist}]
{ifin}
{weight}
{cmd:,} failure(var1) lefttrun(var2) [{it:options}: {it:{help level}} {it:{help maximize:maximize_options}} {it:{help vce_option:cluster(clustvar)}}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt depvar}}Dependent variable{p_end}
{synopt:{opt varlist}}Covariates{p_end}
{synopt:{opt failure}}Failure variable{p_end}
{synopt:{opt lefttrun}}Left-truncation (delayed entry) variable{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
Clustered sandwich estimators are allowed; see {help vce_option}.{p_end}

{title:Description}

{pstd}
{cmd:censn} fits, via maximum likelihood estimation (MLE), a censored skew-normal regression with delayed entry.
 Location and scale parameters in Stata MLE output are in centered parametrisation (CP) form. Shape parameter in Stata MLE output
 is in direct parametrisation, and is converted to a skewness parameter in CP via equation (A1) in the Supplemental Information in Moser et al. (2015).


{title:References}

{pstd}
Moser et al. (2015), Modeling absolute differences in life expectancy with a censored skew-normal regression approach. PeerJ 3:e1162; DOI 10.7717/peerj.1162

{title:Examples}

{phang}{cmd:webuse} cancer, clear

{phang}* age: assumed to be age at study inclusion{p_end}
{phang}* age1: age at study end{p_end}
{phang}gen age1=age+studytime{p_end}

{phang}* stset dataset{p_end}
{phang}{cmd:stset} age1, failure(died) enter(age){p_end}

{phang}* Skew-normal regression {p_end}
{phang}{cmd:censn} age1 i.drug, failure(died) lefttrun(age){p_end}
{phang}* Same example with stset syntax {p_end}
{phang}{cmd:censn} _t i.drug, failure(_d) lefttrun(_t0){p_end}
{phang}predict time1{p_end}

{phang}* Example with probability weights {p_end}
{phang}gen wght=runiform()*10{p_end}
{phang}summ wght{p_end}
{phang}{cmd:censn} age1 i.drug [pw=wght], failure(died) lefttrun(age){p_end}


{phang}**** Comparison with Weibull survival regression{p_end}

{phang}{cmd:streg} i.drug, d(w){p_end}
{phang}predict time2, time{p_end}

{title:Updates}

Date: 25 Feb 2016
Author: André Moser
Changes: pweights included.

Date: 31 May 2016
Author: André Moser
Changes: cluster option included / Syntax change (censor -> failure).

{title:Authors}

André Moser, Kerri M. Clough-Gorr, Marcel Zwahlen

Institute of Social and Preventive Medicine (ISPM)
University of Bern
Finkenhubelweg 11
CH-3012 Bern
Switzerland

Bern, May 2016
