## Fullsim Efficiency for photon_efficiency2D_looseID, multiplying ISO Fullsim/Delphes? False

set PromptFormula{
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 8.0 && pt <= 10.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 10.0 && pt <= 12.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 12.0 && pt <= 15.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 15.0 && pt <= 17.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 17.0 && pt <= 20.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 20.0 && pt <= 26.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 26.0 && pt <= 32.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 32.0 && pt <= 38.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 38.0 && pt <= 44.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 44.0 && pt <= 50.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 50.0 && pt <= 60.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 60.0 && pt <= 70.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 70.0 && pt <= 80.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 80.0 && pt <= 90.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 90.0 && pt <= 100.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 100.0 && pt <= 120.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 120.0 && pt <= 140.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 140.0 && pt <= 160.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 160.0 && pt <= 180.0) * (0.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 180.0 && pt <= 200.0) * (0.0) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 8.0 && pt <= 10.0) * (0.125) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 10.0 && pt <= 12.0) * (0.333333333333) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 12.0 && pt <= 15.0) * (0.411764705882) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 15.0 && pt <= 17.0) * (0.111111111111) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 17.0 && pt <= 20.0) * (0.6) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 20.0 && pt <= 26.0) * (0.4) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 26.0 && pt <= 32.0) * (0.7) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 32.0 && pt <= 38.0) * (0.529411764706) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 38.0 && pt <= 44.0) * (0.8) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 44.0 && pt <= 50.0) * (0.75) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 50.0 && pt <= 60.0) * (0.777777777778) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 60.0 && pt <= 70.0) * (0.585365853659) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 70.0 && pt <= 80.0) * (0.911764705882) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 80.0 && pt <= 90.0) * (0.774193548387) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 90.0 && pt <= 100.0) * (0.655172413793) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 100.0 && pt <= 120.0) * (0.706896551724) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 120.0 && pt <= 140.0) * (0.679245283019) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 140.0 && pt <= 160.0) * (0.714285714286) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 160.0 && pt <= 180.0) * (0.511363636364) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 180.0 && pt <= 200.0) * (0.477611940299) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 8.0 && pt <= 10.0) * (0.0358208955224) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 10.0 && pt <= 12.0) * (0.0548387096774) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 12.0 && pt <= 15.0) * (0.103646833013) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 15.0 && pt <= 17.0) * (0.179245283019) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 17.0 && pt <= 20.0) * (0.157782515991) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 20.0 && pt <= 26.0) * (0.158227848101) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 26.0 && pt <= 32.0) * (0.176724137931) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 32.0 && pt <= 38.0) * (0.148264984227) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 38.0 && pt <= 44.0) * (0.109657947686) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 44.0 && pt <= 50.0) * (0.0990806945863) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 50.0 && pt <= 60.0) * (0.073304825901) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 60.0 && pt <= 70.0) * (0.0720775287704) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 70.0 && pt <= 80.0) * (0.0724907063197) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 80.0 && pt <= 90.0) * (0.0738916256158) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 90.0 && pt <= 100.0) * (0.0518838789376) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 100.0 && pt <= 120.0) * (0.0626902008521) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 120.0 && pt <= 140.0) * (0.0653514180025) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 140.0 && pt <= 160.0) * (0.0553009471433) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 160.0 && pt <= 180.0) * (0.0451908396947) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 180.0 && pt <= 200.0) * (0.0326354679803) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 8.0 && pt <= 10.0) * (0.0) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 10.0 && pt <= 12.0) * (0.0116279069767) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 12.0 && pt <= 15.0) * (0.0) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 15.0 && pt <= 17.0) * (0.00609756097561) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 17.0 && pt <= 20.0) * (0.0) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 20.0 && pt <= 26.0) * (0.00204081632653) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 26.0 && pt <= 32.0) * (0.00196078431373) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 32.0 && pt <= 38.0) * (0.0) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 38.0 && pt <= 44.0) * (0.00896860986547) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 44.0 && pt <= 50.0) * (0.0041928721174) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 50.0 && pt <= 60.0) * (0.0128055878929) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 60.0 && pt <= 70.0) * (0.0154577883472) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 70.0 && pt <= 80.0) * (0.0233766233766) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 80.0 && pt <= 90.0) * (0.0204081632653) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 90.0 && pt <= 100.0) * (0.0282413350449) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 100.0 && pt <= 120.0) * (0.0155183116077) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 120.0 && pt <= 140.0) * (0.0222634508349) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 140.0 && pt <= 160.0) * (0.0282112845138) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 160.0 && pt <= 180.0) * (0.0316879951249) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 180.0 && pt <= 200.0) * (0.0333745364648)
}