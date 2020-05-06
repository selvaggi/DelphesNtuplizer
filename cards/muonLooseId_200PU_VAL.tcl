## Fullsim Efficiency for muon_efficiency2D_looseID, multiplying ISO Fullsim/Delphes? True

set EfficiencyFormula{
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 10.0 && pt <= 12.0) * (0.982146954308) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 12.0 && pt <= 14.0) * (0.993407037324) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 14.0 && pt <= 16.0) * (0.985662192045) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 16.0 && pt <= 18.0) * (0.999265150215) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 18.0 && pt <= 20.0) * (1.00296129414) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 20.0 && pt <= 26.0) * (1.00111880005) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 26.0 && pt <= 32.0) * (0.993714109511) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 32.0 && pt <= 38.0) * (0.997192158132) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 38.0 && pt <= 44.0) * (0.99591522885) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 44.0 && pt <= 50.0) * (0.995916821194) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 50.0 && pt <= 60.0) * (0.996809642974) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 60.0 && pt <= 70.0) * (0.99365836805) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 70.0 && pt <= 80.0) * (0.993453372749) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 80.0 && pt <= 90.0) * (1.00588235294) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 90.0 && pt <= 100.0) * (1.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 100.0 && pt <= 120.0) * (1.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 120.0 && pt <= 140.0) * (1.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 140.0 && pt <= 160.0) * (1.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 160.0 && pt <= 180.0) * (1.0) +
	(abs(eta) > 0.0 && abs(eta) <= 1.0) * (pt > 180.0 && pt <= 200.0) * (1.0) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 10.0 && pt <= 12.0) * (0.956678277046) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 12.0 && pt <= 14.0) * (0.978269106893) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 14.0 && pt <= 16.0) * (0.980054311268) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 16.0 && pt <= 18.0) * (0.979123173278) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 18.0 && pt <= 20.0) * (0.986750269979) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 20.0 && pt <= 26.0) * (0.994415296247) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 26.0 && pt <= 32.0) * (0.991643184958) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 32.0 && pt <= 38.0) * (0.988981414967) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 38.0 && pt <= 44.0) * (0.990683049367) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 44.0 && pt <= 50.0) * (0.991531074811) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 50.0 && pt <= 60.0) * (0.986390755233) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 60.0 && pt <= 70.0) * (0.98427672956) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 70.0 && pt <= 80.0) * (0.993506493506) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 80.0 && pt <= 90.0) * (1.0) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 90.0 && pt <= 100.0) * (1.0) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 100.0 && pt <= 120.0) * (0.979591836735) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 120.0 && pt <= 140.0) * (0.952380952381) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 140.0 && pt <= 160.0) * (1.0) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 160.0 && pt <= 180.0) * (1.0) +
	(abs(eta) > 1.0 && abs(eta) <= 1.5) * (pt > 180.0 && pt <= 200.0) * (1.0) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 10.0 && pt <= 12.0) * (0.960205189066) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 12.0 && pt <= 14.0) * (0.986605646766) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 14.0 && pt <= 16.0) * (0.972732180675) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 16.0 && pt <= 18.0) * (0.990219263265) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 18.0 && pt <= 20.0) * (0.98661827883) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 20.0 && pt <= 26.0) * (0.989740323683) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 26.0 && pt <= 32.0) * (0.99188570496) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 32.0 && pt <= 38.0) * (0.98878503485) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 38.0 && pt <= 44.0) * (0.99197935025) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 44.0 && pt <= 50.0) * (0.989640801266) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 50.0 && pt <= 60.0) * (0.990217845591) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 60.0 && pt <= 70.0) * (0.984092763447) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 70.0 && pt <= 80.0) * (1.0) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 80.0 && pt <= 90.0) * (1.0) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 90.0 && pt <= 100.0) * (1.0) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 100.0 && pt <= 120.0) * (0.988505747126) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 120.0 && pt <= 140.0) * (0.975609756098) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 140.0 && pt <= 160.0) * (1.0) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 160.0 && pt <= 180.0) * (1.0) +
	(abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 180.0 && pt <= 200.0) * (1.0) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 10.0 && pt <= 12.0) * (0.618082705665) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 12.0 && pt <= 14.0) * (0.626297577855) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 14.0 && pt <= 16.0) * (0.673621421166) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 16.0 && pt <= 18.0) * (0.651198928793) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 18.0 && pt <= 20.0) * (0.595945730247) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 20.0 && pt <= 26.0) * (0.623657753702) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 26.0 && pt <= 32.0) * (0.634463950474) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 32.0 && pt <= 38.0) * (0.629775408759) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 38.0 && pt <= 44.0) * (0.628194271764) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 44.0 && pt <= 50.0) * (0.607678133136) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 50.0 && pt <= 60.0) * (0.612397000036) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 60.0 && pt <= 70.0) * (0.629238778669) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 70.0 && pt <= 80.0) * (0.631748726655) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 80.0 && pt <= 90.0) * (0.589285714286) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 90.0 && pt <= 100.0) * (0.6875) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 100.0 && pt <= 120.0) * (0.772727272727) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 120.0 && pt <= 140.0) * (0.769230769231) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 140.0 && pt <= 160.0) * (1.0) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 160.0 && pt <= 180.0) * (0.4) +
	(abs(eta) > 2.5 && abs(eta) <= 3.0) * (pt > 180.0 && pt <= 200.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 10.0 && pt <= 12.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 12.0 && pt <= 14.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 14.0 && pt <= 16.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 16.0 && pt <= 18.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 18.0 && pt <= 20.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 20.0 && pt <= 26.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 26.0 && pt <= 32.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 32.0 && pt <= 38.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 38.0 && pt <= 44.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 44.0 && pt <= 50.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 50.0 && pt <= 60.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 60.0 && pt <= 70.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 70.0 && pt <= 80.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 80.0 && pt <= 90.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 90.0 && pt <= 100.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 100.0 && pt <= 120.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 120.0 && pt <= 140.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 140.0 && pt <= 160.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 160.0 && pt <= 180.0) * (0.0) +
	(abs(eta) > 3.0 && abs(eta) <= 4.0) * (pt > 180.0 && pt <= 200.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 10.0 && pt <= 12.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 12.0 && pt <= 14.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 14.0 && pt <= 16.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 16.0 && pt <= 18.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 18.0 && pt <= 20.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 20.0 && pt <= 26.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 26.0 && pt <= 32.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 32.0 && pt <= 38.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 38.0 && pt <= 44.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 44.0 && pt <= 50.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 50.0 && pt <= 60.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 60.0 && pt <= 70.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 70.0 && pt <= 80.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 80.0 && pt <= 90.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 90.0 && pt <= 100.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 100.0 && pt <= 120.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 120.0 && pt <= 140.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 140.0 && pt <= 160.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 160.0 && pt <= 180.0) * (0.0) +
	(abs(eta) > 4.0 && abs(eta) <= 5.0) * (pt > 180.0 && pt <= 200.0) * (0.0)
}
