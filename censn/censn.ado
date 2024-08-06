** Program code for MLE censored skew-normal regression
** Author: André Moser

** Institute of Social and Preventive Medicine (ISPM)
** University of Bern
** Finkenhubelweg 11
** CH-3012 Bern
** Switzerland

** Date: 31th May 2016

** Reference: Moser et al. (2015), Modeling absolute differences in life expectancy with a censored skew-normal regression approach. PeerJ 3:e1162; DOI 10.7717/peerj.1162

** Remark: Location and scale parameter in centered parametrisation; Shape parameter has to be converted from DP to CP via eq (5) in Moser et al. (2013)

program censn
	version 11
	if replay() {
		if (`"`e(cmd)'"' != "censn") error 301
		Replay `0'
	}
	else	Estimate `0'
end

program Estimate, eclass sortpreserve
	syntax varlist(fv) [if] [in] [pweight], FAIlure(namelist) LEFTtrun(namelist) [Level(cilevel) nlLOg CLuster(varname) *]
	mlopts mlopts, `options'
	
	gettoken lhs rhs : varlist
	_fv_check_depvar `lhs'
	
	global S_cen `failure'
	global S_ltrun `lefttrun'
	
    	if "`cluster'" != "" {
        	local clopt cluster(`cluster')
    	}

	if "`weight'" != "" { 
			local wgt "[`weight'`exp']" 
	}
	
	// mark the estimation sample
	marksample touse
	markout `touse'

	// initial values
	quietly summ `lhs' if `touse', detail
	local mean = r(mean)
	local scale = r(sd)
	local shape = r(skewness)
	local initopt init(/mu=`mean' /sigma=`scale' /shape=`shape') search(off)

	`qui' di as txt _n "Fitting constant-only model:"
	ml model lf sn_ltrun				///
		(mu: `lhs' = `rhs')				///
		(sigma: `lhs' = )			///
		(shape: `lhs' = ) ///
		`wgt' if `touse',	///
		`initopt'				///
		`mlopts'				///
		`clopt'				///
		nocnsnotes				///
		missing					///
		maximize

	matrix define tempmat=e(b)
	matrix define tempmatV0=e(V)
	matrix tempmatV=tempmatV0[e(k),e(k)]
	
	matrix tempmat[1,e(k)]=0.5*(4-_pi)*sign(tempmat[1,e(k)])*(tempmat[1,e(k)]^2/(_pi/2+(_pi/2-1)*tempmat[1,e(k)]^2))^1.5
	matrix tempmatV[1,1]=0.5*(4-_pi)*sign(sqrt(tempmatV[1,1]))*(sqrt(tempmatV[1,1])^2/(_pi/2+(_pi/2-1)*sqrt(tempmatV[1,1])^2))^1.5
	
	ereturn local cmd censn

	Replay , level(`level')
	
	`qui' di as txt _n "{bf:Skewness parameter in CP}"
	`qui' di as txt _n "{bf:Coef.: }" tempmat[1,e(k)]
	`qui' di as txt _n "{bf:Std. Err.: }" tempmatV[1,1]
	`qui' di as txt _n "{bf:[`level'% CI]: }" tempmat[1,e(k)]-invnormal(1-(1-`level'/100)/2)*tempmatV[1,1] " , " tempmat[1,e(k)]+invnormal(1-(1-`level'/100)/2)*tempmatV[1,1]
	matrix drop tempmat tempmatV0 tempmatV
end

program Replay
	syntax [, Level(cilevel) ]
	ml display , level(`level')
end
