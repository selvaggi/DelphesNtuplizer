########################################
#
#  Main authors: Michele Selvaggi (CERN)
#
#  Released on: Nov. 2020
#
#  Version: v06
#
#  Notes: - added DNN tau tagging ( 01/04/2019)
#         - removed BTaggingMTD, and replaced BTagging with latest DeepJet parameterisation (20/07/2019)
#         - adding electrons, muons and photon fakes
#         - removed ele/mu/gamma CHS collections
#         - adding medium WPs for ele/mu/photons
#
#
#######################################
# Order of execution of various modules
#######################################
  

set ExecutionPath {

  PileUpMerger
  ParticlePropagator
  TrackMergerProp

  DenseProp
  DenseMergeTracks
  DenseTrackFilter

  ChargedHadronTrackingEfficiency
  ElectronTrackingEfficiency
  MuonTrackingEfficiency

  ChargedHadronMomentumSmearing
  ElectronEnergySmearing
  MuonMomentumSmearing

  TrackMerger

  ECal
  HCal

  PhotonEnergySmearing
  ElectronFilter

  TrackPileUpSubtractor
  RecoPuFilter

  TowerMerger
  NeutralEFlowMerger

  EFlowMerger
  EFlowMergerCHS
  Rho

  LeptonFilterNoLep
  LeptonFilterLep
  RunPUPPIBase
  RunPUPPIMerger
  RunPUPPI

  EFlowFilterPuppi
  EFlowFilterCHS

  GenParticleFilter
  PhotonFilter

  NeutrinoFilter

  GenJetFinder
  FastJetFinder

  PhotonIsolation

  PhotonLooseID
  PhotonMediumID
  PhotonTightID

  ElectronIsolation

  ElectronLooseEfficiency
  ElectronMediumEfficiency
  ElectronTightEfficiency

  MuonIsolation

  MuonLooseIdEfficiency
  MuonMediumIdEfficiency
  MuonTightIdEfficiency

  MissingET
  PuppiMissingET
  GenMissingET
  GenPileUpMissingET

  GenJetFinderAK8
  FastJetFinderAK8
  JetPileUpSubtractor
  JetPileUpSubtractorAK8
  FastJetFinderPUPPI
  FastJetFinderPUPPIAK8

  ScalarHT

  JetEnergyScale
  JetEnergyScaleAK8
  JetEnergyScalePUPPI
  JetEnergyScalePUPPIAK8

  JetFlavorAssociation
  JetFlavorAssociationAK8
  JetFlavorAssociationPUPPI
  JetFlavorAssociationPUPPIAK8

  BTagging
  BTaggingAK8
  BTaggingPUPPILoose
  BTaggingPUPPIMedium
  BTaggingPUPPITight
  BTaggingPUPPIAK8

  TauTaggingCutBased
  TauTaggingDNNMedium
  TauTaggingDNNTight

  TauTaggingAK8CutBased
  TauTaggingAK8DNNMedium
  TauTaggingAK8DNNTight

  TauTaggingPUPPICutBasedLoose
  TauTaggingPUPPICutBasedMedium
  TauTaggingPUPPICutBasedTight
  TauTaggingPUPPICutBasedVeryTight

  TauTaggingPUPPIDNNMedium
  TauTaggingPUPPIDNNTight

  TauTaggingPUPPIAK8CutBased
  TauTaggingPUPPIAK8DNNMedium
  TauTaggingPUPPIAK8DNNTight

  JetFakeMakerLoose
  JetFakeMakerMedium
  JetFakeMakerTight

  PhotonFakeMergerLoose
  PhotonFakeMergerMedium
  PhotonFakeMergerTight

  ElectronFakeMergerLoose
  ElectronFakeMergerMedium
  ElectronFakeMergerTight

  MuonFakeMergerLoose
  MuonFakeMergerMedium
  MuonFakeMergerTight

  TreeWriter
}


###############
# PileUp Merger
###############

module PileUpMerger PileUpMerger {
  set InputArray Delphes/stableParticles

  set ParticleOutputArray stableParticles
  set VertexOutputArray vertices

  # pre-generated minbias input file
  set PileUpFile /eos/cms/store/group/upgrade/delphes/PhaseII/MinBias_100k.pileup
  #set PileUpFile MinBias_100k.pileup
  
  # average expected pile up
  set MeanPileUp 200

  # maximum spread in the beam direction in m
  set ZVertexSpread 0.25

  # maximum spread in time in s
  set TVertexSpread 800E-12

  # vertex smearing formula f(z,t) (z,t need to be respectively given in m,s) - {exp(-(t^2/160e-12^2/2))*exp(-(z^2/0.053^2/2))}
  set VertexDistributionFormula {exp(-(t^2/160e-12^2/2))*exp(-(z^2/0.053^2/2))}

}



#####################################
# Track propagation to calorimeters
#####################################

module ParticlePropagator ParticlePropagator {
  set InputArray PileUpMerger/stableParticles

  set OutputArray stableParticles
  set NeutralOutputArray neutralParticles
  set ChargedHadronOutputArray chargedHadrons
  set ElectronOutputArray electrons
  set MuonOutputArray muons

  # radius of the magnetic field coverage, in m
  set Radius 1.29
  # half-length of the magnetic field coverage, in m
  set HalfLength 3.0

  # magnetic field
  set Bz 3.8
}


##############
# Track merger
##############

module Merger TrackMergerProp {
# add InputArray InputArray
  add InputArray ParticlePropagator/chargedHadrons
  add InputArray ParticlePropagator/electrons
  add InputArray ParticlePropagator/muons
  set OutputArray tracks
}


####################################
# Track propagation to pseudo-pixel
####################################

module ParticlePropagator DenseProp {

  set InputArray TrackMergerProp/tracks

  # radius of the first pixel layer
  set Radius 0.3
  set RadiusMax 1.29
  # half-length of the magnetic field coverage, in m
  set HalfLength 0.7
  set HalfLengthMax 3.0

  # magnetic field
  set Bz 3.8
}


####################
# Dense Track merger
###################

module Merger DenseMergeTracks {
# add InputArray InputArray
  add InputArray DenseProp/chargedHadrons
  add InputArray DenseProp/electrons
  add InputArray DenseProp/muons
  set OutputArray tracks
}

######################
#   Dense Track Filter
######################

module DenseTrackFilter DenseTrackFilter {

  set TrackInputArray DenseMergeTracks/tracks

  set TrackOutputArray tracks
  set ChargedHadronOutputArray chargedHadrons
  set ElectronOutputArray electrons
  set MuonOutputArray muons

  set EtaPhiRes 0.003
  set EtaMax 4.0

  set pi [expr {acos(-1)}]

  set nbins_phi [expr {$pi/$EtaPhiRes} ]
  set nbins_phi [expr {int($nbins_phi)} ]

  set PhiBins {}
  for {set i -$nbins_phi} {$i <= $nbins_phi} {incr i} {
    add PhiBins [expr {$i * $pi/$nbins_phi}]
  }

  set nbins_eta [expr {$EtaMax/$EtaPhiRes} ]
  set nbins_eta [expr {int($nbins_eta)} ]

  for {set i -$nbins_eta} {$i <= $nbins_eta} {incr i} {
    set eta [expr {$i * $EtaPhiRes}]
    add EtaPhiBins $eta $PhiBins
  }

}



####################################
# Charged hadron tracking efficiency
####################################

module Efficiency ChargedHadronTrackingEfficiency {
  ## particles after propagation
  set InputArray  DenseTrackFilter/chargedHadrons
  set OutputArray chargedHadrons
  # tracking efficiency formula for charged hadrons
  set EfficiencyFormula {
      (pt <= 0.2) * (0.00) + \
          (abs(eta) <= 1.2) * (pt > 0.2 && pt <= 1.0) * (pt * 0.96) + \
          (abs(eta) <= 1.2) * (pt > 1.0) * (0.97) + \
          (abs(eta) > 1.2 && abs(eta) <= 2.5) * (pt > 0.2 && pt <= 1.0) * (pt*0.85) + \
          (abs(eta) > 1.2 && abs(eta) <= 2.5) * (pt > 1.0) * (0.87) + \
          (abs(eta) > 2.5 && abs(eta) <= 4.0) * (pt > 0.2 && pt <= 1.0) * (pt*0.8) + \
          (abs(eta) > 2.5 && abs(eta) <= 4.0) * (pt > 1.0) * (0.82) + \
          (abs(eta) > 4.0) * (0.00)
  }
}


#####################################
# Electron tracking efficiency - ID
####################################

module Efficiency ElectronTrackingEfficiency {
  set InputArray  DenseTrackFilter/electrons
  set OutputArray electrons
  # tracking efficiency formula for electrons
  set EfficiencyFormula {
      (pt <= 0.2) * (0.00) + \
          (abs(eta) <= 1.2) * (pt > 0.2 && pt <= 1.0) * (pt * 0.96) + \
          (abs(eta) <= 1.2) * (pt > 1.0) * (0.97) + \
          (abs(eta) > 1.2 && abs(eta) <= 2.5) * (pt > 0.2 && pt <= 1.0) * (pt*0.85) + \
          (abs(eta) > 1.2 && abs(eta) <= 2.5) * (pt > 1.0 && pt <= 10.0) * (0.82+pt*0.01) + \
          (abs(eta) > 1.2 && abs(eta) <= 2.5) * (pt > 10.0) * (1.0) + \
          (abs(eta) > 2.5 && abs(eta) <= 4.0) * (pt > 0.2 && pt <= 1.0) * (pt*0.8) + \
          (abs(eta) > 2.5 && abs(eta) <= 4.0) * (pt > 1.0 && pt <= 10.0) * (0.8+pt*0.01) + \
          (abs(eta) > 2.5 && abs(eta) <= 4.0) * (pt > 10.0) * (1.0) + \
          (abs(eta) > 4.0) * (0.00)

  }
  # eta 1.2-2.5 had 0.9 and 2.5-4.0 had 0.85 above 10 GeV
}

##########################
# Muon tracking efficiency
##########################

module Efficiency MuonTrackingEfficiency {
  set InputArray DenseTrackFilter/muons
  set OutputArray muons
  # tracking efficiency formula for muons
  set EfficiencyFormula {
      (pt <= 0.2) * (0.00) + \
          (abs(eta) <= 1.2) * (pt > 0.2 && pt <= 1.0) * (pt * 1.00) + \
          (abs(eta) <= 1.2) * (pt > 1.0) * (1.00) + \
          (abs(eta) > 1.2 && abs(eta) <= 2.8) * (pt > 0.2 && pt <= 1.0) * (pt*1.00) + \
          (abs(eta) > 1.2 && abs(eta) <= 2.8) * (pt > 1.0) * (1.00) + \
          (abs(eta) > 2.8 && abs(eta) <= 4.0) * (pt > 0.2 && pt <= 1.0) * (pt*0.95) + \
          (abs(eta) > 2.8 && abs(eta) <= 4.0) * (pt > 1.0) * (0.95) + \
          (abs(eta) > 4.0) * (0.00)

  }
}


########################################
# Momentum resolution for charged tracks
########################################

module MomentumSmearing ChargedHadronMomentumSmearing {
  ## hadrons after having applied the tracking efficiency
  set InputArray  ChargedHadronTrackingEfficiency/chargedHadrons
  set OutputArray chargedHadrons
  # resolution formula for charged hadrons ,

  #
  # Automatically generated tracker resolution formula for layout: OT612IT4025
  #
  #  By Unknown author on: 2017-06-30.17:03:00
  #
  set ResolutionFormula {    (abs(eta) >= 0.0000 && abs(eta) < 0.2000) * (pt >= 0.0000 && pt < 1.0000) * (0.00457888) + \
     (abs(eta) >= 0.0000 && abs(eta) < 0.2000) * (pt >= 1.0000 && pt < 10.0000) * (0.004579 + (pt-1.000000)* 0.000045) + \
     (abs(eta) >= 0.0000 && abs(eta) < 0.2000) * (pt >= 10.0000 && pt < 100.0000) * (0.004983 + (pt-10.000000)* 0.000047) + \
     (abs(eta) >= 0.0000 && abs(eta) < 0.2000) * (pt >= 100.0000) * (0.009244*pt/100.000000) + \
     (abs(eta) >= 0.2000 && abs(eta) < 0.4000) * (pt >= 0.0000 && pt < 1.0000) * (0.00505011) + \
     (abs(eta) >= 0.2000 && abs(eta) < 0.4000) * (pt >= 1.0000 && pt < 10.0000) * (0.005050 + (pt-1.000000)* 0.000033) + \
     (abs(eta) >= 0.2000 && abs(eta) < 0.4000) * (pt >= 10.0000 && pt < 100.0000) * (0.005343 + (pt-10.000000)* 0.000043) + \
     (abs(eta) >= 0.2000 && abs(eta) < 0.4000) * (pt >= 100.0000) * (0.009172*pt/100.000000) + \
     (abs(eta) >= 0.4000 && abs(eta) < 0.6000) * (pt >= 0.0000 && pt < 1.0000) * (0.00510573) + \
     (abs(eta) >= 0.4000 && abs(eta) < 0.6000) * (pt >= 1.0000 && pt < 10.0000) * (0.005106 + (pt-1.000000)* 0.000023) + \
     (abs(eta) >= 0.4000 && abs(eta) < 0.6000) * (pt >= 10.0000 && pt < 100.0000) * (0.005317 + (pt-10.000000)* 0.000042) + \
     (abs(eta) >= 0.4000 && abs(eta) < 0.6000) * (pt >= 100.0000) * (0.009077*pt/100.000000) + \
     (abs(eta) >= 0.6000 && abs(eta) < 0.8000) * (pt >= 0.0000 && pt < 1.0000) * (0.00578020) + \
     (abs(eta) >= 0.6000 && abs(eta) < 0.8000) * (pt >= 1.0000 && pt < 10.0000) * (0.005780 + (pt-1.000000)* -0.000000) + \
     (abs(eta) >= 0.6000 && abs(eta) < 0.8000) * (pt >= 10.0000 && pt < 100.0000) * (0.005779 + (pt-10.000000)* 0.000038) + \
     (abs(eta) >= 0.6000 && abs(eta) < 0.8000) * (pt >= 100.0000) * (0.009177*pt/100.000000) + \
     (abs(eta) >= 0.8000 && abs(eta) < 1.0000) * (pt >= 0.0000 && pt < 1.0000) * (0.00728723) + \
     (abs(eta) >= 0.8000 && abs(eta) < 1.0000) * (pt >= 1.0000 && pt < 10.0000) * (0.007287 + (pt-1.000000)* -0.000031) + \
     (abs(eta) >= 0.8000 && abs(eta) < 1.0000) * (pt >= 10.0000 && pt < 100.0000) * (0.007011 + (pt-10.000000)* 0.000038) + \
     (abs(eta) >= 0.8000 && abs(eta) < 1.0000) * (pt >= 100.0000) * (0.010429*pt/100.000000) + \
     (abs(eta) >= 1.0000 && abs(eta) < 1.2000) * (pt >= 0.0000 && pt < 1.0000) * (0.01045117) + \
     (abs(eta) >= 1.0000 && abs(eta) < 1.2000) * (pt >= 1.0000 && pt < 10.0000) * (0.010451 + (pt-1.000000)* -0.000051) + \
     (abs(eta) >= 1.0000 && abs(eta) < 1.2000) * (pt >= 10.0000 && pt < 100.0000) * (0.009989 + (pt-10.000000)* 0.000043) + \
     (abs(eta) >= 1.0000 && abs(eta) < 1.2000) * (pt >= 100.0000) * (0.013867*pt/100.000000) + \
     (abs(eta) >= 1.2000 && abs(eta) < 1.4000) * (pt >= 0.0000 && pt < 1.0000) * (0.01477199) + \
     (abs(eta) >= 1.2000 && abs(eta) < 1.4000) * (pt >= 1.0000 && pt < 10.0000) * (0.014772 + (pt-1.000000)* -0.000128) + \
     (abs(eta) >= 1.2000 && abs(eta) < 1.4000) * (pt >= 10.0000 && pt < 100.0000) * (0.013616 + (pt-10.000000)* 0.000035) + \
     (abs(eta) >= 1.2000 && abs(eta) < 1.4000) * (pt >= 100.0000) * (0.016800*pt/100.000000) + \
     (abs(eta) >= 1.4000 && abs(eta) < 1.6000) * (pt >= 0.0000 && pt < 1.0000) * (0.01731474) + \
     (abs(eta) >= 1.4000 && abs(eta) < 1.6000) * (pt >= 1.0000 && pt < 10.0000) * (0.017315 + (pt-1.000000)* -0.000208) + \
     (abs(eta) >= 1.4000 && abs(eta) < 1.6000) * (pt >= 10.0000 && pt < 100.0000) * (0.015439 + (pt-10.000000)* 0.000030) + \
     (abs(eta) >= 1.4000 && abs(eta) < 1.6000) * (pt >= 100.0000) * (0.018161*pt/100.000000) + \
     (abs(eta) >= 1.6000 && abs(eta) < 1.8000) * (pt >= 0.0000 && pt < 1.0000) * (0.01942025) + \
     (abs(eta) >= 1.6000 && abs(eta) < 1.8000) * (pt >= 1.0000 && pt < 10.0000) * (0.019420 + (pt-1.000000)* -0.000417) + \
     (abs(eta) >= 1.6000 && abs(eta) < 1.8000) * (pt >= 10.0000 && pt < 100.0000) * (0.015669 + (pt-10.000000)* 0.000026) + \
     (abs(eta) >= 1.6000 && abs(eta) < 1.8000) * (pt >= 100.0000) * (0.018039*pt/100.000000) + \
     (abs(eta) >= 1.8000 && abs(eta) < 2.0000) * (pt >= 0.0000 && pt < 1.0000) * (0.02201432) + \
     (abs(eta) >= 1.8000 && abs(eta) < 2.0000) * (pt >= 1.0000 && pt < 10.0000) * (0.022014 + (pt-1.000000)* -0.000667) + \
     (abs(eta) >= 1.8000 && abs(eta) < 2.0000) * (pt >= 10.0000 && pt < 100.0000) * (0.016012 + (pt-10.000000)* 0.000045) + \
     (abs(eta) >= 1.8000 && abs(eta) < 2.0000) * (pt >= 100.0000) * (0.020098*pt/100.000000) + \
     (abs(eta) >= 2.0000 && abs(eta) < 2.2000) * (pt >= 0.0000 && pt < 1.0000) * (0.02574300) + \
     (abs(eta) >= 2.0000 && abs(eta) < 2.2000) * (pt >= 1.0000 && pt < 10.0000) * (0.025743 + (pt-1.000000)* -0.001118) + \
     (abs(eta) >= 2.0000 && abs(eta) < 2.2000) * (pt >= 10.0000 && pt < 100.0000) * (0.015681 + (pt-10.000000)* 0.000051) + \
     (abs(eta) >= 2.0000 && abs(eta) < 2.2000) * (pt >= 100.0000) * (0.020289*pt/100.000000) + \
     (abs(eta) >= 2.2000 && abs(eta) < 2.4000) * (pt >= 0.0000 && pt < 1.0000) * (0.02885821) + \
     (abs(eta) >= 2.2000 && abs(eta) < 2.4000) * (pt >= 1.0000 && pt < 10.0000) * (0.028858 + (pt-1.000000)* -0.001345) + \
     (abs(eta) >= 2.2000 && abs(eta) < 2.4000) * (pt >= 10.0000 && pt < 100.0000) * (0.016753 + (pt-10.000000)* 0.000053) + \
     (abs(eta) >= 2.2000 && abs(eta) < 2.4000) * (pt >= 100.0000) * (0.021524*pt/100.000000) + \
     (abs(eta) >= 2.4000 && abs(eta) < 2.6000) * (pt >= 0.0000 && pt < 1.0000) * (0.03204812) + \
     (abs(eta) >= 2.4000 && abs(eta) < 2.6000) * (pt >= 1.0000 && pt < 10.0000) * (0.032048 + (pt-1.000000)* -0.001212) + \
     (abs(eta) >= 2.4000 && abs(eta) < 2.6000) * (pt >= 10.0000 && pt < 100.0000) * (0.021138 + (pt-10.000000)* 0.000037) + \
     (abs(eta) >= 2.4000 && abs(eta) < 2.6000) * (pt >= 100.0000) * (0.024477*pt/100.000000) + \
     (abs(eta) >= 2.6000 && abs(eta) < 2.8000) * (pt >= 0.0000 && pt < 1.0000) * (0.03950405) + \
     (abs(eta) >= 2.6000 && abs(eta) < 2.8000) * (pt >= 1.0000 && pt < 10.0000) * (0.039504 + (pt-1.000000)* -0.001386) + \
     (abs(eta) >= 2.6000 && abs(eta) < 2.8000) * (pt >= 10.0000 && pt < 100.0000) * (0.027026 + (pt-10.000000)* 0.000037) + \
     (abs(eta) >= 2.6000 && abs(eta) < 2.8000) * (pt >= 100.0000) * (0.030392*pt/100.000000) + \
     (abs(eta) >= 2.8000 && abs(eta) < 3.0000) * (pt >= 0.0000 && pt < 1.0000) * (0.04084751) + \
     (abs(eta) >= 2.8000 && abs(eta) < 3.0000) * (pt >= 1.0000 && pt < 10.0000) * (0.040848 + (pt-1.000000)* -0.001780) + \
     (abs(eta) >= 2.8000 && abs(eta) < 3.0000) * (pt >= 10.0000 && pt < 100.0000) * (0.024824 + (pt-10.000000)* 0.000029) + \
     (abs(eta) >= 2.8000 && abs(eta) < 3.0000) * (pt >= 100.0000) * (0.027445*pt/100.000000) + \
     (abs(eta) >= 3.0000 && abs(eta) < 3.2000) * (pt >= 0.0000 && pt < 1.0000) * (0.04532425) + \
     (abs(eta) >= 3.0000 && abs(eta) < 3.2000) * (pt >= 1.0000 && pt < 10.0000) * (0.045324 + (pt-1.000000)* -0.002497) + \
     (abs(eta) >= 3.0000 && abs(eta) < 3.2000) * (pt >= 10.0000 && pt < 100.0000) * (0.022851 + (pt-10.000000)* 0.000024) + \
     (abs(eta) >= 3.0000 && abs(eta) < 3.2000) * (pt >= 100.0000) * (0.025053*pt/100.000000) + \
     (abs(eta) >= 3.2000 && abs(eta) < 3.4000) * (pt >= 0.0000 && pt < 1.0000) * (0.06418925) + \
     (abs(eta) >= 3.2000 && abs(eta) < 3.4000) * (pt >= 1.0000 && pt < 10.0000) * (0.064189 + (pt-1.000000)* -0.004055) + \
     (abs(eta) >= 3.2000 && abs(eta) < 3.4000) * (pt >= 10.0000 && pt < 100.0000) * (0.027691 + (pt-10.000000)* 0.000034) + \
     (abs(eta) >= 3.2000 && abs(eta) < 3.4000) * (pt >= 100.0000) * (0.030710*pt/100.000000) + \
     (abs(eta) >= 3.4000 && abs(eta) < 3.6000) * (pt >= 0.0000 && pt < 1.0000) * (0.07682500) + \
     (abs(eta) >= 3.4000 && abs(eta) < 3.6000) * (pt >= 1.0000 && pt < 10.0000) * (0.076825 + (pt-1.000000)* -0.004510) + \
     (abs(eta) >= 3.4000 && abs(eta) < 3.6000) * (pt >= 10.0000 && pt < 100.0000) * (0.036234 + (pt-10.000000)* 0.000049) + \
     (abs(eta) >= 3.4000 && abs(eta) < 3.6000) * (pt >= 100.0000) * (0.040629*pt/100.000000) + \
     (abs(eta) >= 3.6000 && abs(eta) < 3.8000) * (pt >= 0.0000 && pt < 1.0000) * (0.09796358) + \
     (abs(eta) >= 3.6000 && abs(eta) < 3.8000) * (pt >= 1.0000 && pt < 10.0000) * (0.097964 + (pt-1.000000)* -0.005758) + \
     (abs(eta) >= 3.6000 && abs(eta) < 3.8000) * (pt >= 10.0000 && pt < 100.0000) * (0.046145 + (pt-10.000000)* 0.000069) + \
     (abs(eta) >= 3.6000 && abs(eta) < 3.8000) * (pt >= 100.0000) * (0.052345*pt/100.000000) + \
     (abs(eta) >= 3.8000 && abs(eta) < 4.0000) * (pt >= 0.0000 && pt < 1.0000) * (0.13415929) + \
     (abs(eta) >= 3.8000 && abs(eta) < 4.0000) * (pt >= 1.0000 && pt < 10.0000) * (0.134159 + (pt-1.000000)* -0.008283) + \
     (abs(eta) >= 3.8000 && abs(eta) < 4.0000) * (pt >= 10.0000 && pt < 100.0000) * (0.059612 + (pt-10.000000)* 0.000111) + \
     (abs(eta) >= 3.8000 && abs(eta) < 4.0000) * (pt >= 100.0000) * (0.069617*pt/100.000000)
  }


}


#################################
# Energy resolution for electrons
#################################

module EnergySmearing ElectronEnergySmearing {
  set InputArray ElectronTrackingEfficiency/electrons
  set OutputArray electrons

  # set ResolutionFormula {resolution formula as a function of eta and energy}

  # resolution formula for electrons

  # taking something flat in energy for now, ECAL will take over at high energy anyway.
  # inferred from hep-ex/1306.2016 and 1502.02701
  set ResolutionFormula {

                        (abs(eta) <= 1.5)  * (energy*0.028) +
    (abs(eta) > 1.5  && abs(eta) <= 1.75)  * (energy*0.037) +
    (abs(eta) > 1.75  && abs(eta) <= 2.15) * (energy*0.038) +
    (abs(eta) > 2.15  && abs(eta) <= 3.00) * (energy*0.044) +
    (abs(eta) > 3.00  && abs(eta) <= 4.00) * (energy*0.10)}

}

###############################
# Momentum resolution for muons
###############################

module MomentumSmearing MuonMomentumSmearing {
  set InputArray MuonTrackingEfficiency/muons
  set OutputArray muons
  # resolution formula for muons

  # up to |eta| < 2.8 take measurement from tracking + muon chambers
  # for |eta| > 2.8 and pT < 5.0 take measurement from tracking alone taken from
  # http://mersi.web.cern.ch/mersi/layouts/.private/Baseline_tilted_200_Pixel_1_1_1/index.html
  source muonMomentumResolution.tcl
}



##############
# Track merger
##############

module Merger TrackMerger {
# add InputArray InputArray
  add InputArray ChargedHadronMomentumSmearing/chargedHadrons
  add InputArray ElectronEnergySmearing/electrons
  add InputArray MuonMomentumSmearing/muons
  set OutputArray tracks
}


#############
#   ECAL
#############

module SimpleCalorimeter ECal {
  set ParticleInputArray ParticlePropagator/stableParticles
  set TrackInputArray TrackMerger/tracks

  set TowerOutputArray ecalTowers
  set EFlowTrackOutputArray eflowTracks
  set EFlowTowerOutputArray eflowPhotons

  set IsEcal true

  set EnergyMin 0.5
  set EnergySignificanceMin 1.0

  set SmearTowerCenter true

  set pi [expr {acos(-1)}]

  # lists of the edges of each tower in eta and phi
  # each list starts with the lower edge of the first tower
  # the list ends with the higher edged of the last tower

  # assume 0.02 x 0.02 resolution in eta,phi in the barrel |eta| < 1.5

  set PhiBins {}
  for {set i -180} {$i <= 180} {incr i} {
    add PhiBins [expr {$i * $pi/180.0}]
  }

  # 0.02 unit in eta up to eta = 1.5 (barrel)
  for {set i -85} {$i <= 86} {incr i} {
    set eta [expr {$i * 0.0174}]
    add EtaPhiBins $eta $PhiBins
  }

  # assume 0.02 x 0.02 resolution in eta,phi in the endcaps 1.5 < |eta| < 3.0 (HGCAL- ECAL)

  set PhiBins {}
  for {set i -180} {$i <= 180} {incr i} {
    add PhiBins [expr {$i * $pi/180.0}]
  }

  # 0.02 unit in eta up to eta = 3
  for {set i 1} {$i <= 84} {incr i} {
    set eta [expr { -2.958 + $i * 0.0174}]
    add EtaPhiBins $eta $PhiBins
  }

  for {set i 1} {$i <= 84} {incr i} {
    set eta [expr { 1.4964 + $i * 0.0174}]
    add EtaPhiBins $eta $PhiBins
  }

  # take present CMS granularity for HF

  # 0.175 x (0.175 - 0.35) resolution in eta,phi in the HF 3.0 < |eta| < 5.0
  set PhiBins {}
  for {set i -18} {$i <= 18} {incr i} {
    add PhiBins [expr {$i * $pi/18.0}]
  }

  foreach eta {-5 -4.7 -4.525 -4.35 -4.175 -4 -3.825 -3.65 -3.475 -3.3 -3.125 -2.958 3.125 3.3 3.475 3.65 3.825 4 4.175 4.35 4.525 4.7 5} {
    add EtaPhiBins $eta $PhiBins
  }


  add EnergyFraction {0} {0.0}
  # energy fractions for e, gamma and pi0
  add EnergyFraction {11} {1.0}
  add EnergyFraction {22} {1.0}
  add EnergyFraction {111} {1.0}
  # energy fractions for muon, neutrinos and neutralinos
  add EnergyFraction {12} {0.0}
  add EnergyFraction {13} {0.0}
  add EnergyFraction {14} {0.0}
  add EnergyFraction {16} {0.0}
  add EnergyFraction {1000022} {0.0}
  add EnergyFraction {1000023} {0.0}
  add EnergyFraction {1000025} {0.0}
  add EnergyFraction {1000035} {0.0}
  add EnergyFraction {1000045} {0.0}
  # energy fractions for K0short and Lambda
  add EnergyFraction {310} {0.3}
  add EnergyFraction {3122} {0.3}

  # set ResolutionFormula {resolution formula as a function of eta and energy}

  # for the ECAL barrel (|eta| < 1.5), see hep-ex/1306.2016 and 1502.02701
  # for the endcaps (1.5 < |eta| < 3.0), we take HGCAL  see LHCC-P-008, Fig. 3.39, p.117

  set ResolutionFormula {  (abs(eta) <= 1.50)                    * sqrt(energy^2*0.009^2 + energy*0.12^2 + 0.45^2) +
                           (abs(eta) > 1.50 && abs(eta) <= 1.75) * sqrt(energy^2*0.006^2 + energy*0.20^2) + \
                           (abs(eta) > 1.75 && abs(eta) <= 2.15) * sqrt(energy^2*0.007^2 + energy*0.21^2) + \
                           (abs(eta) > 2.15 && abs(eta) <= 3.00) * sqrt(energy^2*0.008^2 + energy*0.24^2) + \
                           (abs(eta) >= 3.0 && abs(eta) <= 5.0)  * sqrt(energy^2*0.08^2 + energy*1.98^2)}

}

#############
#   HCAL
#############

module SimpleCalorimeter HCal {
  set ParticleInputArray ParticlePropagator/stableParticles
  set TrackInputArray ECal/eflowTracks

  set TowerOutputArray hcalTowers
  set EFlowTrackOutputArray eflowTracks
  set EFlowTowerOutputArray eflowNeutralHadrons

  set IsEcal false

  set EnergyMin 1.0
  set EnergySignificanceMin 1.0

  set SmearTowerCenter true

  set pi [expr {acos(-1)}]

  # lists of the edges of each tower in eta and phi
  # each list starts with the lower edge of the first tower
  # the list ends with the higher edged of the last tower

  # assume 0.087 x 0.087 resolution in eta,phi in the barrel |eta| < 1.5

  set PhiBins {}
  for {set i -36} {$i <= 36} {incr i} {
    add PhiBins [expr {$i * $pi/36.0}]
  }
  foreach eta {-1.566 -1.479 -1.392 -1.305 -1.218 -1.131 -1.044 -0.957 -0.87 -0.783 -0.696 -0.609 -0.522 -0.435 -0.348 -0.261 -0.174 -0.087 0 0.087 0.174 0.261 0.348 0.435 0.522 0.609 0.696 0.783 0.87 0.957 1.044 1.131 1.218 1.305 1.392 1.479 1.566 1.65} {
    add EtaPhiBins $eta $PhiBins
  }

  # assume 0.07 x 0.07 resolution in eta,phi in the endcaps 1.5 < |eta| < 3.0 (HGCAL- HCAL)

  set PhiBins {}
  for {set i -45} {$i <= 45} {incr i} {
    add PhiBins [expr {$i * $pi/45.0}]
  }

  # 0.07 unit in eta up to eta = 3
  for {set i 1} {$i <= 21} {incr i} {
    set eta [expr { -2.958 + $i * 0.0696}]
    add EtaPhiBins $eta $PhiBins
  }

  for {set i 1} {$i <= 21} {incr i} {
    set eta [expr { 1.4964 + $i * 0.0696}]
    add EtaPhiBins $eta $PhiBins
  }

  # take present CMS granularity for HF

  # 0.175 x (0.175 - 0.35) resolution in eta,phi in the HF 3.0 < |eta| < 5.0
  set PhiBins {}
  for {set i -18} {$i <= 18} {incr i} {
    add PhiBins [expr {$i * $pi/18.0}]
  }

  foreach eta {-5 -4.7 -4.525 -4.35 -4.175 -4 -3.825 -3.65 -3.475 -3.3 -3.125 -2.958 3.125 3.3 3.475 3.65 3.825 4 4.175 4.35 4.525 4.7 5} {
    add EtaPhiBins $eta $PhiBins
  }


  # default energy fractions {abs(PDG code)} {Fecal Fhcal}
  add EnergyFraction {0} {1.0}
  # energy fractions for e, gamma and pi0
  add EnergyFraction {11} {0.0}
  add EnergyFraction {22} {0.0}
  add EnergyFraction {111} {0.0}
  # energy fractions for muon, neutrinos and neutralinos
  add EnergyFraction {12} {0.0}
  add EnergyFraction {13} {0.0}
  add EnergyFraction {14} {0.0}
  add EnergyFraction {16} {0.0}
  add EnergyFraction {1000022} {0.0}
  add EnergyFraction {1000023} {0.0}
  add EnergyFraction {1000025} {0.0}
  add EnergyFraction {1000035} {0.0}
  add EnergyFraction {1000045} {0.0}
  # energy fractions for K0short and Lambda
  add EnergyFraction {310} {0.7}
  add EnergyFraction {3122} {0.7}

# set ResolutionFormula {resolution formula as a function of eta and energy}
  set ResolutionFormula {                    (abs(eta) <= 1.5) * sqrt(energy^2*0.05^2 + energy*1.00^2) + \
                                                   (abs(eta) > 1.5 && abs(eta) <= 3.0) * sqrt(energy^2*0.05^2 + energy*1.00^2) + \
                                                   (abs(eta) > 3.0 && abs(eta) <= 5.0) * sqrt(energy^2*0.11^2 + energy*2.80^2)}

}

#################################
# Energy resolution for electrons
#################################

module EnergySmearing PhotonEnergySmearing {
  set InputArray ECal/eflowPhotons
  set OutputArray eflowPhotons

  # adding 1% extra photon smearing
  set ResolutionFormula {energy*0.01}

}



#################
# Electron filter
#################

module PdgCodeFilter ElectronFilter {
  set InputArray HCal/eflowTracks
  set OutputArray electrons
  set Invert true
  add PdgCode {11}
  add PdgCode {-11}
}



##########################
# Track pile-up subtractor
##########################

module TrackPileUpSubtractor TrackPileUpSubtractor {
# add InputArray InputArray OutputArray
  add InputArray HCal/eflowTracks eflowTracks
  add InputArray ElectronFilter/electrons electrons
  add InputArray MuonMomentumSmearing/muons muons

  set VertexInputArray PileUpMerger/vertices
  # assume perfect pile-up subtraction for tracks with |z| > fZVertexResolution
  # Z vertex resolution in m (naive guess from tkLayout, assumed flat in pt for now)
  
  set ZVertexResolution {
  
     (pt < 10. ) * ( ( -0.8*log10(pt) + 1. ) * (10^(0.5*abs(eta) + 1.5)) * 1e-06 ) +
     (pt >= 10. ) * ( ( 0.2 ) * (10^(0.5*abs(eta) + 1.5)) * 1e-06 )
     
     }
 }

########################
# Reco PU filter
########################

module RecoPuFilter RecoPuFilter {
  set InputArray HCal/eflowTracks
  set OutputArray eflowTracks
}

###################################################
# Tower Merger (in case not using e-flow algorithm)
###################################################

module Merger TowerMerger {
# add InputArray InputArray
  add InputArray ECal/ecalTowers
  add InputArray HCal/hcalTowers
  set OutputArray towers
}

####################
# Neutral eflow erger
####################

module Merger NeutralEFlowMerger {
# add InputArray InputArray
  add InputArray PhotonEnergySmearing/eflowPhotons
  add InputArray HCal/eflowNeutralHadrons
  set OutputArray eflowTowers
}

#####################
# Energy flow merger
#####################

module Merger EFlowMerger {
# add InputArray InputArray
  add InputArray HCal/eflowTracks
  add InputArray PhotonEnergySmearing/eflowPhotons
  add InputArray HCal/eflowNeutralHadrons
  set OutputArray eflow
}

############################
# Energy flow merger no PU
############################

module Merger EFlowMergerCHS {
# add InputArray InputArray
  add InputArray RecoPuFilter/eflowTracks
  add InputArray PhotonEnergySmearing/eflowPhotons
  add InputArray HCal/eflowNeutralHadrons
  set OutputArray eflow
}

#########################################
### Run the puppi code (to be tuned) ###
#########################################

module PdgCodeFilter LeptonFilterNoLep {
  set InputArray HCal/eflowTracks
  set OutputArray eflowTracksNoLeptons
  set Invert false
  add PdgCode {13}
  add PdgCode {-13}
  add PdgCode {11}
  add PdgCode {-11}
}

module PdgCodeFilter LeptonFilterLep {
  set InputArray HCal/eflowTracks
  set OutputArray eflowTracksLeptons
  set Invert true
  add PdgCode {11}
  add PdgCode {-11}
  add PdgCode {13}
  add PdgCode {-13}
}

module RunPUPPI RunPUPPIBase {
  ## input information
  set TrackInputArray   LeptonFilterNoLep/eflowTracksNoLeptons
  set NeutralInputArray NeutralEFlowMerger/eflowTowers
  set PVInputArray      PileUpMerger/vertices
  set MinPuppiWeight    0.05
  set UseExp            false
  set UseNoLep          false

  ## define puppi algorithm parameters (more than one for the same eta region is possible)
  add EtaMinBin           0.0   1.5   4.0
  add EtaMaxBin           1.5   4.0   10.0
  add PtMinBin            0.0   0.0   0.0
  add ConeSizeBin         0.2   0.2   0.2
  add RMSPtMinBin         0.1   0.5   0.5
  add RMSScaleFactorBin   1.0   1.0   1.0
  add NeutralMinEBin      0.2   0.2   0.5
  add NeutralPtSlope      0.006 0.013 0.067
  add ApplyCHS            true  true  true
  add UseCharged          true  true  false
  add ApplyLowPUCorr      true  true  true
  add MetricId            5     5     5
  add CombId              0     0     0

  ## output name
  set OutputArray         PuppiParticles
  set OutputArrayTracks   puppiTracks
  set OutputArrayNeutrals puppiNeutrals
}

module Merger RunPUPPIMerger {
  add InputArray RunPUPPIBase/PuppiParticles
  add InputArray LeptonFilterLep/eflowTracksLeptons
  set OutputArray PuppiParticles
}

# need this because of leptons that were added back
module RecoPuFilter RunPUPPI {
  set InputArray RunPUPPIMerger/PuppiParticles
  set OutputArray PuppiParticles
}

######################
# EFlowFilterPuppi
######################

module PdgCodeFilter EFlowFilterPuppi {
  set InputArray RunPUPPI/PuppiParticles
  set OutputArray eflow

  add PdgCode {11}
  add PdgCode {-11}
  add PdgCode {13}
  add PdgCode {-13}
}

######################
# EFlowFilterCHS
######################

module PdgCodeFilter EFlowFilterCHS {
  set InputArray EFlowMergerCHS/eflow
  set OutputArray eflow

  add PdgCode {11}
  add PdgCode {-11}
  add PdgCode {13}
  add PdgCode {-13}
}


###################
# Missing ET merger
###################

module Merger MissingET {
# add InputArray InputArray
#  add InputArray RunPUPPI/PuppiParticles
  add InputArray EFlowMerger/eflow
  set MomentumOutputArray momentum
}

module Merger PuppiMissingET {
  #add InputArray InputArray
  add InputArray RunPUPPI/PuppiParticles
  #add InputArray EFlowMerger/eflow
  set MomentumOutputArray momentum
}

###################
# Ger PileUp Missing ET
###################

module Merger GenPileUpMissingET {
# add InputArray InputArray
#  add InputArray RunPUPPI/PuppiParticles
  add InputArray ParticlePropagator/stableParticles
  set MomentumOutputArray momentum
}

##################
# Scalar HT merger
##################

module Merger ScalarHT {
# add InputArray InputArray
  add InputArray RunPUPPI/PuppiParticles
  set EnergyOutputArray energy
}

#################
# Neutrino Filter
#################

module PdgCodeFilter NeutrinoFilter {

  set InputArray Delphes/stableParticles
  set OutputArray filteredParticles

  set PTMin 0.0

  add PdgCode {12}
  add PdgCode {14}
  add PdgCode {16}
  add PdgCode {-12}
  add PdgCode {-14}
  add PdgCode {-16}

}

#####################
# MC truth jet finder
#####################

module FastJetFinder GenJetFinder {
  set InputArray NeutrinoFilter/filteredParticles

  set OutputArray jets

  # algorithm: 1 CDFJetClu, 2 MidPoint, 3 SIScone, 4 kt, 5 Cambridge/Aachen, 6 antikt
  set JetAlgorithm 6
  set ParameterR 0.4

  set JetPTMin 15.0
}

module FastJetFinder GenJetFinderAK8 {
  set InputArray NeutrinoFilter/filteredParticles

  set OutputArray jetsAK8

  # algorithm: 1 CDFJetClu, 2 MidPoint, 3 SIScone, 4 kt, 5 Cambridge/Aachen, 6 antikt
  set JetAlgorithm 6
  set ParameterR 0.8

  set JetPTMin 200.0
}

#########################
# Gen Missing ET merger
########################

module Merger GenMissingET {

# add InputArray InputArray
  add InputArray NeutrinoFilter/filteredParticles
  set MomentumOutputArray momentum
}


#############
# Rho pile-up
#############

module FastJetGridMedianEstimator Rho {

  set InputArray EFlowMergerCHS/eflow
  set RhoOutputArray rho

  # add GridRange rapmin rapmax drap dphi
  # rapmin - the minimum rapidity extent of the grid
  # rapmax - the maximum rapidity extent of the grid
  # drap - the grid spacing in rapidity
  # dphi - the grid spacing in azimuth

  add GridRange -5.0 -4.0 1.0 1.0
  add GridRange -4.0 -1.5 1.0 1.0
  add GridRange -1.5 1.5 1.0 1.0
  add GridRange 1.5 4.0 1.0 1.0
  add GridRange 4.0 5.0 1.0 1.0

}


##############
# Jet finder
##############

module FastJetFinder FastJetFinder {
#  set InputArray TowerMerger/towers
  set InputArray EFlowMergerCHS/eflow

  set OutputArray jets

  set AreaAlgorithm 5

  # algorithm: 1 CDFJetClu, 2 MidPoint, 3 SIScone, 4 kt, 5 Cambridge/Aachen, 6 antikt
  set JetAlgorithm 6
  set ParameterR 0.4

  set JetPTMin 15.0
}

#module Class Name
module FastJetFinder FastJetFinderAK8 {
#  set InputArray TowerMerger/towers
  set InputArray EFlowMergerCHS/eflow

  set OutputArray jets

  set AreaAlgorithm 5

  # algorithm: 1 CDFJetClu, 2 MidPoint, 3 SIScone, 4 kt, 5 Cambridge/Aachen, 6 antikt
  set JetAlgorithm 6
  set ParameterR 0.8

  set ComputeNsubjettiness 1
  set Beta 1.0
  set AxisMode 4

  set ComputeTrimming 1
  set RTrim 0.2
  set PtFracTrim 0.05

  set ComputePruning 1
  set ZcutPrun 0.1
  set RcutPrun 0.5
  set RPrun 0.8

  set ComputeSoftDrop 1
  set BetaSoftDrop 0.0
  set SymmetryCutSoftDrop 0.1
  set R0SoftDrop 0.8

  set JetPTMin 200.0
}

###########################
# Jet Pile-Up Subtraction
###########################

module JetPileUpSubtractor JetPileUpSubtractor {
  set JetInputArray FastJetFinder/jets
  set RhoInputArray Rho/rho

  set OutputArray jets

  set JetPTMin 15.0
}

##############################
# Jet Pile-Up Subtraction AK8
##############################

module JetPileUpSubtractor JetPileUpSubtractorAK8 {
  set JetInputArray FastJetFinderAK8/jets
  set RhoInputArray Rho/rho

  set OutputArray jets

  set JetPTMin 15.0
}

module FastJetFinder FastJetFinderPUPPI {
#  set InputArray TowerMerger/towers
  set InputArray RunPUPPI/PuppiParticles

  set OutputArray jets

  # algorithm: 1 CDFJetClu, 2 MidPoint, 3 SIScone, 4 kt, 5 Cambridge/Aachen, 6 antikt
  set JetAlgorithm 6
  set ParameterR 0.4

  set JetPTMin 15.0
}


module FastJetFinder FastJetFinderPUPPIAK8 {
#  set InputArray TowerMerger/towers
  set InputArray RunPUPPI/PuppiParticles

  set OutputArray jets

  set JetAlgorithm 6
  set ParameterR 0.8

  set ComputeNsubjettiness 1
  set Beta 1.0
  set AxisMode 4

  set ComputeTrimming 1
  set RTrim 0.2
  set PtFracTrim 0.05

  set ComputePruning 1
  set ZcutPrun 0.1
  set RcutPrun 0.5
  set RPrun 0.8

  set ComputeSoftDrop 1
  set BetaSoftDrop 0.0
  set SymmetryCutSoftDrop 0.1
  set R0SoftDrop 0.8

  set JetPTMin 200.0
}

##################
# Jet Energy Scale
##################

module EnergyScale JetEnergyScale {
  set InputArray JetPileUpSubtractor/jets
  set OutputArray jets

 # scale formula for jets
  set ScaleFormula {1.00}
}

module EnergyScale JetEnergyScaleAK8 {
  set InputArray JetPileUpSubtractorAK8/jets
  set OutputArray jets

 # scale formula for jets
  set ScaleFormula {1.00}
}

module EnergyScale JetEnergyScalePUPPI {
  set InputArray FastJetFinderPUPPI/jets
  set OutputArray jets

 # scale formula for jets
  set ScaleFormula {1.00}
}

module EnergyScale JetEnergyScalePUPPIAK8 {
  set InputArray FastJetFinderPUPPIAK8/jets
  set OutputArray jets

 # scale formula for jets
  set ScaleFormula {1.00}
}

#################
# Photon filter
#################

module PdgCodeFilter PhotonFilter {
  set InputArray PhotonEnergySmearing/eflowPhotons
  set OutputArray photons
  set Invert true
  set PTMin 5.0
  add PdgCode {22}
}


####################
# Photon isolation #
####################

module Isolation PhotonIsolation {

  # particle for which calculate the isolation
  set CandidateInputArray PhotonFilter/photons

  # isolation collection
  set IsolationInputArray EFlowFilterPuppi/eflow

  # output array
  set OutputArray photons

  # veto isolation cand. based on proximity to input cand.
  set DeltaRMin 0.01
  set UseMiniCone true

  # isolation cone
  set DeltaRMax 0.3

  # minimum pT
  set PTMin     0.0

  # iso ratio to cut
  set PTRatioMax 9999.

}



#####################
# Photon Id Loose   #
#####################

module Efficiency PhotonLooseID {

  ## input particles
  set InputArray PhotonIsolation/photons
  ## output particles
  set OutputArray photons
  # set EfficiencyFormula {efficiency formula as a function of eta and pt}
  # efficiency formula for photons
  set EfficiencyFormula {                      (pt <= 10.0) * (0.00) + \
                           (abs(eta) <= 1.5) * (pt > 10.0)  * (1.0) + \
         (abs(eta) > 1.5 && abs(eta) <= 4.0) * (pt > 10.0)  * (1.0) + \
         (abs(eta) > 4.0)                                   * (0.00)}

}


#####################
# Photon Id Medium   #
#####################

module Efficiency PhotonMediumID {

  ## input particles
  set InputArray PhotonIsolation/photons
  ## output particles
  set OutputArray photons
  # set EfficiencyFormula {efficiency formula as a function of eta and pt}
  # efficiency formula for photons
  set EfficiencyFormula {                      (pt <= 10.0) * (0.00) + \
                           (abs(eta) <= 1.5) * (pt > 10.0)  * (1.0) + \
         (abs(eta) > 1.5 && abs(eta) <= 4.0) * (pt > 10.0)  * (1.0) + \
         (abs(eta) > 4.0)                                   * (0.00)}

}


#####################
# Photon Id Tight   #
#####################

module Efficiency PhotonTightID {

  ## input particles
  set InputArray PhotonIsolation/photons
  ## output particles
  set OutputArray photons
  # set EfficiencyFormula {efficiency formula as a function of eta and pt}
  # efficiency formula for photons
  set EfficiencyFormula {                      (pt <= 10.0) * (0.00) + \
                           (abs(eta) <= 1.5) * (pt > 10.0)  * (1.0) + \
         (abs(eta) > 1.5 && abs(eta) <= 4.0) * (pt > 10.0)  * (1.0) + \
         (abs(eta) > 4.0)                                   * (0.00)}

}


######################
# Electron isolation #
######################

module Isolation ElectronIsolation {

  set CandidateInputArray ElectronFilter/electrons

  # isolation collection
  set IsolationInputArray EFlowFilterPuppi/eflow

  set OutputArray electrons

  set DeltaRMax 0.3
  set PTMin 0.0
  set PTRatioMax 9999.

}



#######################
# Electron loose ID efficiency #
#######################

module Efficiency ElectronLooseEfficiency {

  set InputArray ElectronIsolation/electrons
  set OutputArray electrons

  source electronLooseId_200PU_VAL.tcl
}

#######################
# Electron medium ID efficiency #
#######################

##FIXME!!! sourcing LooseId tcl file because medium does not exists (yet ...)
module Efficiency ElectronMediumEfficiency {

  set InputArray ElectronIsolation/electrons
  set OutputArray electrons

  source electronLooseId_200PU_VAL.tcl
}

#######################
# Electron tight ID efficiency #
#######################

module Efficiency ElectronTightEfficiency {

  set InputArray ElectronIsolation/electrons
  set OutputArray electrons

  source electronTightId_200PU_VAL.tcl
}



##################
# Muon isolation #
##################

module Isolation MuonIsolation {
  set CandidateInputArray MuonMomentumSmearing/muons

  # isolation collection
  set IsolationInputArray EFlowFilterPuppi/eflow

  set OutputArray muons

  set DeltaRMax 0.3
  set PTMin 0.0
  set PTRatioMax 9999.

}


##################
# Muon Loose Id  #
##################

module Efficiency MuonLooseIdEfficiency {
    set InputArray MuonIsolation/muons
    set OutputArray muons
    # TightID(fullsim) * TightIso(fullsim)/TightIso(Delphes) efficiency formula for muons
    source muonLooseId_200PU_VAL.tcl
}

##################
# Muon Medium Id  #
##################

##FIXME!!! sourcing LooseId tcl file because medium does not exists (yet ...)
module Efficiency MuonMediumIdEfficiency {
    set InputArray MuonIsolation/muons
    set OutputArray muons
    # TightID(fullsim) * TightIso(fullsim)/TightIso(Delphes) efficiency formula for muons
    source muonLooseId_200PU_VAL.tcl
}

##################
# Muon Tight Id  #
##################

module Efficiency MuonTightIdEfficiency {
    set InputArray MuonIsolation/muons
    set OutputArray muons
    # TightID(fullsim) * TightIso(fullsim)/TightIso(Delphes) efficiency formula for muons
    source muonTightId_200PU_VAL.tcl
}


########################
# Jet Flavor Association
########################

module JetFlavorAssociation JetFlavorAssociation {

  set PartonInputArray Delphes/partons
  set ParticleInputArray Delphes/allParticles
  set ParticleLHEFInputArray Delphes/allParticlesLHEF
  set JetInputArray JetEnergyScale/jets

  set DeltaR 0.5
  set PartonPTMin 10.0
  set PartonEtaMax 4.0

}

module JetFlavorAssociation JetFlavorAssociationAK8 {

  set PartonInputArray Delphes/partons
  set ParticleInputArray Delphes/allParticles
  set ParticleLHEFInputArray Delphes/allParticlesLHEF
  set JetInputArray JetEnergyScaleAK8/jets

  set DeltaR 0.8
  set PartonPTMin 100.0
  set PartonEtaMax 4.0

}

module JetFlavorAssociation JetFlavorAssociationPUPPI {

  set PartonInputArray Delphes/partons
  set ParticleInputArray Delphes/allParticles
  set ParticleLHEFInputArray Delphes/allParticlesLHEF
  set JetInputArray JetEnergyScalePUPPI/jets

  set DeltaR 0.5
  set PartonPTMin 10.0
  set PartonEtaMax 4.0

}

module JetFlavorAssociation JetFlavorAssociationPUPPIAK8 {

  set PartonInputArray Delphes/partons
  set ParticleInputArray Delphes/allParticles
  set ParticleLHEFInputArray Delphes/allParticlesLHEF
  set JetInputArray JetEnergyScalePUPPIAK8/jets

  set DeltaR 0.8
  set PartonPTMin 100.0
  set PartonEtaMax 4.0

}


#############
# b-tagging #
#############
module BTagging BTagging {

  set JetInputArray JetEnergyScale/jets
  set BitNumber 0

  add EfficiencyFormula {0}      {0.001}

  add EfficiencyFormula {5}      {
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 20.00 && pt <= 30.00) * (0.63) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 30.00 && pt <= 40.00) * (0.70) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 40.00 && pt <= 50.00) * (0.74) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 50.00 && pt <= 60.00) * (0.74) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 60.00 && pt <= 70.00) * (0.75) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 70.00 && pt <= 80.00) * (0.75) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 80.00 && pt <= 90.00) * (0.75) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 90.00 && pt <= 100.00) * (0.74) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 100.00 && pt <= 120.00) * (0.73) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 120.00 && pt <= 140.00) * (0.73) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 140.00 && pt <= 160.00) * (0.72) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 160.00 && pt <= 180.00) * (0.69) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 180.00 && pt <= 200.00) * (0.68) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 200.00 && pt <= 250.00) * (0.66) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 250.00 && pt <= 300.00) * (0.64) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 300.00 && pt <= 350.00) * (0.59) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 350.00 && pt <= 400.00) * (0.56) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 400.00 && pt <= 500.00) * (0.50) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 500.00 && pt <= 600.00) * (0.44) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 600.00 && pt <= 700.00) * (0.40) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 700.00 && pt <= 800.00) * (0.32) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 800.00 && pt <= 1000.00) * (0.26) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1000.00 && pt <= 1400.00) * (0.21) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1400.00 && pt <= 2000.00) * (0.11) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 2000.00 && pt <= 3000.00) * (0.17) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.00 && pt <= 30.00) * (0.43) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.00 && pt <= 40.00) * (0.53) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.00 && pt <= 50.00) * (0.56) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.00 && pt <= 60.00) * (0.59) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.00 && pt <= 70.00) * (0.60) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.00 && pt <= 80.00) * (0.61) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.00 && pt <= 90.00) * (0.60) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.00 && pt <= 100.00) * (0.59) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.00 && pt <= 120.00) * (0.59) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.00 && pt <= 140.00) * (0.60) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.00 && pt <= 160.00) * (0.58) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.00 && pt <= 180.00) * (0.56) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.00 && pt <= 200.00) * (0.55) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.00 && pt <= 250.00) * (0.53) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.00 && pt <= 300.00) * (0.49) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.00 && pt <= 350.00) * (0.45) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.00 && pt <= 400.00) * (0.42) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.00 && pt <= 500.00) * (0.38) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.00 && pt <= 600.00) * (0.32) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.00 && pt <= 700.00) * (0.36) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.00 && pt <= 800.00) * (0.34) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.00 && pt <= 1000.00) * (0.29) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1000.00 && pt <= 1400.00) * (0.20) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.00 && pt <= 30.00) * (0.25) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.00 && pt <= 40.00) * (0.33) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.00 && pt <= 50.00) * (0.37) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.00 && pt <= 60.00) * (0.39) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.00 && pt <= 70.00) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.00 && pt <= 80.00) * (0.43) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.00 && pt <= 90.00) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.00 && pt <= 100.00) * (0.44) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.00 && pt <= 120.00) * (0.44) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.00 && pt <= 140.00) * (0.42) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.00 && pt <= 160.00) * (0.40) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.00 && pt <= 180.00) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.00 && pt <= 200.00) * (0.39) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.00 && pt <= 250.00) * (0.34) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.00 && pt <= 300.00) * (0.30) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.00 && pt <= 350.00) * (0.23) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.00 && pt <= 400.00) * (0.33) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.00 && pt <= 500.00) * (0.14) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.00 && pt <= 600.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 600.00 && pt <= 700.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 700.00 && pt <= 800.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 800.00 && pt <= 1000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1000.00 && pt <= 1400.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 3000.00) * (0.00)
                                 }

  add EfficiencyFormula {4}      {
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 20.00 && pt <= 30.00) * (0.17) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 30.00 && pt <= 40.00) * (0.19) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 40.00 && pt <= 50.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 50.00 && pt <= 60.00) * (0.21) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 60.00 && pt <= 70.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 70.00 && pt <= 80.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 80.00 && pt <= 90.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 90.00 && pt <= 100.00) * (0.19) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 100.00 && pt <= 120.00) * (0.18) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 120.00 && pt <= 140.00) * (0.18) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 140.00 && pt <= 160.00) * (0.17) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 160.00 && pt <= 180.00) * (0.16) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 180.00 && pt <= 200.00) * (0.16) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 200.00 && pt <= 250.00) * (0.15) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 250.00 && pt <= 300.00) * (0.12) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 300.00 && pt <= 350.00) * (0.12) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 350.00 && pt <= 400.00) * (0.10) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 400.00 && pt <= 500.00) * (0.08) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 500.00 && pt <= 600.00) * (0.07) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 600.00 && pt <= 700.00) * (0.06) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 700.00 && pt <= 800.00) * (0.05) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 800.00 && pt <= 1000.00) * (0.04) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1000.00 && pt <= 1400.00) * (0.03) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1400.00 && pt <= 2000.00) * (0.02) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 2000.00 && pt <= 3000.00) * (0.02) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.00 && pt <= 30.00) * (0.08) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.00 && pt <= 40.00) * (0.10) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.00 && pt <= 50.00) * (0.10) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.00 && pt <= 60.00) * (0.12) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.00 && pt <= 70.00) * (0.12) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.00 && pt <= 80.00) * (0.13) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.00 && pt <= 90.00) * (0.13) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.00 && pt <= 100.00) * (0.14) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.00 && pt <= 120.00) * (0.14) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.00 && pt <= 140.00) * (0.14) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.00 && pt <= 160.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.00 && pt <= 180.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.00 && pt <= 200.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.00 && pt <= 250.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.00 && pt <= 300.00) * (0.13) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.00 && pt <= 350.00) * (0.12) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.00 && pt <= 400.00) * (0.11) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.00 && pt <= 500.00) * (0.09) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.00 && pt <= 600.00) * (0.07) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.00 && pt <= 700.00) * (0.07) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.00 && pt <= 800.00) * (0.06) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.00 && pt <= 1000.00) * (0.03) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1000.00 && pt <= 1400.00) * (0.03) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.00 && pt <= 30.00) * (0.06) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.00 && pt <= 40.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.00 && pt <= 50.00) * (0.08) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.00 && pt <= 60.00) * (0.08) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.00 && pt <= 70.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.00 && pt <= 80.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.00 && pt <= 90.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.00 && pt <= 100.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.00 && pt <= 120.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.00 && pt <= 140.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.00 && pt <= 160.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.00 && pt <= 180.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.00 && pt <= 200.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.00 && pt <= 250.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.00 && pt <= 300.00) * (0.08) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.00 && pt <= 350.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.00 && pt <= 400.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.00 && pt <= 500.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.00 && pt <= 600.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 600.00 && pt <= 700.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 700.00 && pt <= 800.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 800.00 && pt <= 1000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1000.00 && pt <= 1400.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 3000.00) * (0.00)
                                 }



}

module BTagging BTaggingAK8 {

  set JetInputArray JetEnergyScaleAK8/jets
  set BitNumber 0
  add EfficiencyFormula {0}      {0.001}

  add EfficiencyFormula {5}      {
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 20.00 && pt <= 30.00) * (0.63) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 30.00 && pt <= 40.00) * (0.70) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 40.00 && pt <= 50.00) * (0.74) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 50.00 && pt <= 60.00) * (0.74) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 60.00 && pt <= 70.00) * (0.75) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 70.00 && pt <= 80.00) * (0.75) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 80.00 && pt <= 90.00) * (0.75) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 90.00 && pt <= 100.00) * (0.74) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 100.00 && pt <= 120.00) * (0.73) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 120.00 && pt <= 140.00) * (0.73) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 140.00 && pt <= 160.00) * (0.72) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 160.00 && pt <= 180.00) * (0.69) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 180.00 && pt <= 200.00) * (0.68) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 200.00 && pt <= 250.00) * (0.66) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 250.00 && pt <= 300.00) * (0.64) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 300.00 && pt <= 350.00) * (0.59) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 350.00 && pt <= 400.00) * (0.56) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 400.00 && pt <= 500.00) * (0.50) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 500.00 && pt <= 600.00) * (0.44) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 600.00 && pt <= 700.00) * (0.40) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 700.00 && pt <= 800.00) * (0.32) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 800.00 && pt <= 1000.00) * (0.26) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1000.00 && pt <= 1400.00) * (0.21) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1400.00 && pt <= 2000.00) * (0.11) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 2000.00 && pt <= 3000.00) * (0.17) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.00 && pt <= 30.00) * (0.43) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.00 && pt <= 40.00) * (0.53) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.00 && pt <= 50.00) * (0.56) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.00 && pt <= 60.00) * (0.59) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.00 && pt <= 70.00) * (0.60) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.00 && pt <= 80.00) * (0.61) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.00 && pt <= 90.00) * (0.60) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.00 && pt <= 100.00) * (0.59) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.00 && pt <= 120.00) * (0.59) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.00 && pt <= 140.00) * (0.60) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.00 && pt <= 160.00) * (0.58) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.00 && pt <= 180.00) * (0.56) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.00 && pt <= 200.00) * (0.55) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.00 && pt <= 250.00) * (0.53) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.00 && pt <= 300.00) * (0.49) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.00 && pt <= 350.00) * (0.45) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.00 && pt <= 400.00) * (0.42) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.00 && pt <= 500.00) * (0.38) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.00 && pt <= 600.00) * (0.32) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.00 && pt <= 700.00) * (0.36) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.00 && pt <= 800.00) * (0.34) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.00 && pt <= 1000.00) * (0.29) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1000.00 && pt <= 1400.00) * (0.20) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.00 && pt <= 30.00) * (0.25) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.00 && pt <= 40.00) * (0.33) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.00 && pt <= 50.00) * (0.37) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.00 && pt <= 60.00) * (0.39) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.00 && pt <= 70.00) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.00 && pt <= 80.00) * (0.43) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.00 && pt <= 90.00) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.00 && pt <= 100.00) * (0.44) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.00 && pt <= 120.00) * (0.44) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.00 && pt <= 140.00) * (0.42) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.00 && pt <= 160.00) * (0.40) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.00 && pt <= 180.00) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.00 && pt <= 200.00) * (0.39) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.00 && pt <= 250.00) * (0.34) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.00 && pt <= 300.00) * (0.30) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.00 && pt <= 350.00) * (0.23) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.00 && pt <= 400.00) * (0.33) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.00 && pt <= 500.00) * (0.14) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.00 && pt <= 600.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 600.00 && pt <= 700.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 700.00 && pt <= 800.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 800.00 && pt <= 1000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1000.00 && pt <= 1400.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 3000.00) * (0.00)
                                 }

  add EfficiencyFormula {4}      {
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 20.00 && pt <= 30.00) * (0.17) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 30.00 && pt <= 40.00) * (0.19) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 40.00 && pt <= 50.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 50.00 && pt <= 60.00) * (0.21) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 60.00 && pt <= 70.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 70.00 && pt <= 80.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 80.00 && pt <= 90.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 90.00 && pt <= 100.00) * (0.19) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 100.00 && pt <= 120.00) * (0.18) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 120.00 && pt <= 140.00) * (0.18) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 140.00 && pt <= 160.00) * (0.17) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 160.00 && pt <= 180.00) * (0.16) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 180.00 && pt <= 200.00) * (0.16) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 200.00 && pt <= 250.00) * (0.15) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 250.00 && pt <= 300.00) * (0.12) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 300.00 && pt <= 350.00) * (0.12) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 350.00 && pt <= 400.00) * (0.10) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 400.00 && pt <= 500.00) * (0.08) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 500.00 && pt <= 600.00) * (0.07) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 600.00 && pt <= 700.00) * (0.06) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 700.00 && pt <= 800.00) * (0.05) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 800.00 && pt <= 1000.00) * (0.04) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1000.00 && pt <= 1400.00) * (0.03) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1400.00 && pt <= 2000.00) * (0.02) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 2000.00 && pt <= 3000.00) * (0.02) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.00 && pt <= 30.00) * (0.08) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.00 && pt <= 40.00) * (0.10) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.00 && pt <= 50.00) * (0.10) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.00 && pt <= 60.00) * (0.12) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.00 && pt <= 70.00) * (0.12) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.00 && pt <= 80.00) * (0.13) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.00 && pt <= 90.00) * (0.13) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.00 && pt <= 100.00) * (0.14) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.00 && pt <= 120.00) * (0.14) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.00 && pt <= 140.00) * (0.14) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.00 && pt <= 160.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.00 && pt <= 180.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.00 && pt <= 200.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.00 && pt <= 250.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.00 && pt <= 300.00) * (0.13) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.00 && pt <= 350.00) * (0.12) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.00 && pt <= 400.00) * (0.11) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.00 && pt <= 500.00) * (0.09) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.00 && pt <= 600.00) * (0.07) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.00 && pt <= 700.00) * (0.07) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.00 && pt <= 800.00) * (0.06) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.00 && pt <= 1000.00) * (0.03) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1000.00 && pt <= 1400.00) * (0.03) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.00 && pt <= 30.00) * (0.06) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.00 && pt <= 40.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.00 && pt <= 50.00) * (0.08) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.00 && pt <= 60.00) * (0.08) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.00 && pt <= 70.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.00 && pt <= 80.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.00 && pt <= 90.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.00 && pt <= 100.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.00 && pt <= 120.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.00 && pt <= 140.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.00 && pt <= 160.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.00 && pt <= 180.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.00 && pt <= 200.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.00 && pt <= 250.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.00 && pt <= 300.00) * (0.08) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.00 && pt <= 350.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.00 && pt <= 400.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.00 && pt <= 500.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.00 && pt <= 600.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 600.00 && pt <= 700.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 700.00 && pt <= 800.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 800.00 && pt <= 1000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1000.00 && pt <= 1400.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 3000.00) * (0.00)
                                 }


}



module BTagging BTaggingPUPPIAK8 {

  set JetInputArray JetEnergyScalePUPPIAK8/jets
  set BitNumber 0
  add EfficiencyFormula {0}      {0.001}

  add EfficiencyFormula {5}      {
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 20.00 && pt <= 30.00) * (0.63) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 30.00 && pt <= 40.00) * (0.70) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 40.00 && pt <= 50.00) * (0.74) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 50.00 && pt <= 60.00) * (0.74) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 60.00 && pt <= 70.00) * (0.75) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 70.00 && pt <= 80.00) * (0.75) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 80.00 && pt <= 90.00) * (0.75) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 90.00 && pt <= 100.00) * (0.74) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 100.00 && pt <= 120.00) * (0.73) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 120.00 && pt <= 140.00) * (0.73) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 140.00 && pt <= 160.00) * (0.72) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 160.00 && pt <= 180.00) * (0.69) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 180.00 && pt <= 200.00) * (0.68) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 200.00 && pt <= 250.00) * (0.66) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 250.00 && pt <= 300.00) * (0.64) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 300.00 && pt <= 350.00) * (0.59) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 350.00 && pt <= 400.00) * (0.56) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 400.00 && pt <= 500.00) * (0.50) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 500.00 && pt <= 600.00) * (0.44) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 600.00 && pt <= 700.00) * (0.40) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 700.00 && pt <= 800.00) * (0.32) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 800.00 && pt <= 1000.00) * (0.26) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1000.00 && pt <= 1400.00) * (0.21) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1400.00 && pt <= 2000.00) * (0.11) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 2000.00 && pt <= 3000.00) * (0.17) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.00 && pt <= 30.00) * (0.43) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.00 && pt <= 40.00) * (0.53) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.00 && pt <= 50.00) * (0.56) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.00 && pt <= 60.00) * (0.59) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.00 && pt <= 70.00) * (0.60) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.00 && pt <= 80.00) * (0.61) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.00 && pt <= 90.00) * (0.60) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.00 && pt <= 100.00) * (0.59) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.00 && pt <= 120.00) * (0.59) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.00 && pt <= 140.00) * (0.60) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.00 && pt <= 160.00) * (0.58) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.00 && pt <= 180.00) * (0.56) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.00 && pt <= 200.00) * (0.55) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.00 && pt <= 250.00) * (0.53) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.00 && pt <= 300.00) * (0.49) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.00 && pt <= 350.00) * (0.45) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.00 && pt <= 400.00) * (0.42) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.00 && pt <= 500.00) * (0.38) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.00 && pt <= 600.00) * (0.32) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.00 && pt <= 700.00) * (0.36) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.00 && pt <= 800.00) * (0.34) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.00 && pt <= 1000.00) * (0.29) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1000.00 && pt <= 1400.00) * (0.20) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.00 && pt <= 30.00) * (0.25) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.00 && pt <= 40.00) * (0.33) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.00 && pt <= 50.00) * (0.37) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.00 && pt <= 60.00) * (0.39) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.00 && pt <= 70.00) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.00 && pt <= 80.00) * (0.43) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.00 && pt <= 90.00) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.00 && pt <= 100.00) * (0.44) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.00 && pt <= 120.00) * (0.44) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.00 && pt <= 140.00) * (0.42) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.00 && pt <= 160.00) * (0.40) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.00 && pt <= 180.00) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.00 && pt <= 200.00) * (0.39) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.00 && pt <= 250.00) * (0.34) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.00 && pt <= 300.00) * (0.30) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.00 && pt <= 350.00) * (0.23) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.00 && pt <= 400.00) * (0.33) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.00 && pt <= 500.00) * (0.14) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.00 && pt <= 600.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 600.00 && pt <= 700.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 700.00 && pt <= 800.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 800.00 && pt <= 1000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1000.00 && pt <= 1400.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 3000.00) * (0.00)
                                 }

  add EfficiencyFormula {4}      {
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 20.00 && pt <= 30.00) * (0.17) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 30.00 && pt <= 40.00) * (0.19) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 40.00 && pt <= 50.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 50.00 && pt <= 60.00) * (0.21) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 60.00 && pt <= 70.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 70.00 && pt <= 80.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 80.00 && pt <= 90.00) * (0.20) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 90.00 && pt <= 100.00) * (0.19) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 100.00 && pt <= 120.00) * (0.18) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 120.00 && pt <= 140.00) * (0.18) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 140.00 && pt <= 160.00) * (0.17) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 160.00 && pt <= 180.00) * (0.16) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 180.00 && pt <= 200.00) * (0.16) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 200.00 && pt <= 250.00) * (0.15) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 250.00 && pt <= 300.00) * (0.12) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 300.00 && pt <= 350.00) * (0.12) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 350.00 && pt <= 400.00) * (0.10) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 400.00 && pt <= 500.00) * (0.08) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 500.00 && pt <= 600.00) * (0.07) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 600.00 && pt <= 700.00) * (0.06) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 700.00 && pt <= 800.00) * (0.05) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 800.00 && pt <= 1000.00) * (0.04) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1000.00 && pt <= 1400.00) * (0.03) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 1400.00 && pt <= 2000.00) * (0.02) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 2000.00 && pt <= 3000.00) * (0.02) +
                                  (abs(eta) > 0.00 && abs(eta) <= 1.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.00 && pt <= 30.00) * (0.08) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.00 && pt <= 40.00) * (0.10) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.00 && pt <= 50.00) * (0.10) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.00 && pt <= 60.00) * (0.12) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.00 && pt <= 70.00) * (0.12) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.00 && pt <= 80.00) * (0.13) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.00 && pt <= 90.00) * (0.13) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.00 && pt <= 100.00) * (0.14) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.00 && pt <= 120.00) * (0.14) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.00 && pt <= 140.00) * (0.14) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.00 && pt <= 160.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.00 && pt <= 180.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.00 && pt <= 200.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.00 && pt <= 250.00) * (0.15) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.00 && pt <= 300.00) * (0.13) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.00 && pt <= 350.00) * (0.12) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.00 && pt <= 400.00) * (0.11) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.00 && pt <= 500.00) * (0.09) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.00 && pt <= 600.00) * (0.07) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.00 && pt <= 700.00) * (0.07) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.00 && pt <= 800.00) * (0.06) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.00 && pt <= 1000.00) * (0.03) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1000.00 && pt <= 1400.00) * (0.03) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.00 && pt <= 30.00) * (0.06) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.00 && pt <= 40.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.00 && pt <= 50.00) * (0.08) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.00 && pt <= 60.00) * (0.08) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.00 && pt <= 70.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.00 && pt <= 80.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.00 && pt <= 90.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.00 && pt <= 100.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.00 && pt <= 120.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.00 && pt <= 140.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.00 && pt <= 160.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.00 && pt <= 180.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.00 && pt <= 200.00) * (0.09) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.00 && pt <= 250.00) * (0.10) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.00 && pt <= 300.00) * (0.08) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.00 && pt <= 350.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.00 && pt <= 400.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.00 && pt <= 500.00) * (0.07) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.00 && pt <= 600.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 600.00 && pt <= 700.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 700.00 && pt <= 800.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 800.00 && pt <= 1000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1000.00 && pt <= 1400.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 1400.00 && pt <= 2000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 2000.00 && pt <= 3000.00) * (0.00) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 3000.00) * (0.00)
                                 }


}

module BTagging BTaggingPUPPILoose {

  set JetInputArray JetEnergyScalePUPPI/jets

  set BitNumber 0

  add EfficiencyFormula {0}      {0.1}

  add EfficiencyFormula {5}      {
                                  (abs(eta) <= 1.50) * (pt > 20.0 && pt <= 30.0) * (0.879) +
                                  (abs(eta) <= 1.50) * (pt > 30.0 && pt <= 40.0) * (0.905) +
                                  (abs(eta) <= 1.50) * (pt > 40.0 && pt <= 50.0) * (0.913) +
                                  (abs(eta) <= 1.50) * (pt > 50.0 && pt <= 60.0) * (0.922) +
                                  (abs(eta) <= 1.50) * (pt > 60.0 && pt <= 70.0) * (0.926) +
                                  (abs(eta) <= 1.50) * (pt > 70.0 && pt <= 80.0) * (0.930) +
                                  (abs(eta) <= 1.50) * (pt > 80.0 && pt <= 90.0) * (0.934) +
                                  (abs(eta) <= 1.50) * (pt > 90.0 && pt <= 100.0) * (0.931) +
                                  (abs(eta) <= 1.50) * (pt > 100.0 && pt <= 120.0) * (0.932) +
                                  (abs(eta) <= 1.50) * (pt > 120.0 && pt <= 140.0) * (0.934) +
                                  (abs(eta) <= 1.50) * (pt > 140.0 && pt <= 160.0) * (0.932) +
                                  (abs(eta) <= 1.50) * (pt > 160.0 && pt <= 180.0) * (0.934) +
                                  (abs(eta) <= 1.50) * (pt > 180.0 && pt <= 200.0) * (0.932) +
                                  (abs(eta) <= 1.50) * (pt > 200.0 && pt <= 250.0) * (0.930) +
                                  (abs(eta) <= 1.50) * (pt > 250.0 && pt <= 300.0) * (0.927) +
                                  (abs(eta) <= 1.50) * (pt > 300.0 && pt <= 350.0) * (0.927) +
                                  (abs(eta) <= 1.50) * (pt > 350.0 && pt <= 400.0) * (0.921) +
                                  (abs(eta) <= 1.50) * (pt > 400.0 && pt <= 500.0) * (0.918) +
                                  (abs(eta) <= 1.50) * (pt > 500.0 && pt <= 600.0) * (0.910) +
                                  (abs(eta) <= 1.50) * (pt > 600.0 && pt <= 700.0) * (0.897) +
                                  (abs(eta) <= 1.50) * (pt > 700.0 && pt <= 800.0) * (0.882) +
                                  (abs(eta) <= 1.50) * (pt > 800.0 && pt <= 1000.0) * (0.862) +
                                  (abs(eta) <= 1.50) * (pt > 1000.0 && pt <= 1400.0) * (0.821) +
                                  (abs(eta) <= 1.50) * (pt > 1400.0 && pt <= 2000.0) * (0.777) +
                                  (abs(eta) <= 1.50) * (pt > 2000.0 && pt <= 3000.0) * (0.741) +
                                  (abs(eta) <= 1.50) * (pt > 3000.0) * (0.71) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.0 && pt <= 30.0) * (0.809) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.0 && pt <= 40.0) * (0.847) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.0 && pt <= 50.0) * (0.867) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.0 && pt <= 60.0) * (0.879) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.0 && pt <= 70.0) * (0.893) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.0 && pt <= 80.0) * (0.892) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.0 && pt <= 90.0) * (0.893) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.0 && pt <= 100.0) * (0.899) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.0 && pt <= 120.0) * (0.901) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.0 && pt <= 140.0) * (0.897) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.0 && pt <= 160.0) * (0.899) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.0 && pt <= 180.0) * (0.890) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.0 && pt <= 200.0) * (0.898) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.0 && pt <= 250.0) * (0.891) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.0 && pt <= 300.0) * (0.879) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.0 && pt <= 350.0) * (0.873) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.0 && pt <= 400.0) * (0.870) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.0 && pt <= 500.0) * (0.861) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.0 && pt <= 600.0) * (0.835) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.0 && pt <= 700.0) * (0.816) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.0 && pt <= 800.0) * (0.811) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.0 && pt <= 1000.0) * (0.780) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1000.0 && pt <= 1400.0) * (0.75) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1400.0 && pt <= 2000.0) * (0.72) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 2000.0 && pt <= 3000.0) * (0.69) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 3000.0) * (0.66) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.0 && pt <= 30.0) * (0.675) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.0 && pt <= 40.0) * (0.735) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.0 && pt <= 50.0) * (0.779) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.0 && pt <= 60.0) * (0.797) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.0 && pt <= 70.0) * (0.799) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.0 && pt <= 80.0) * (0.802) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.0 && pt <= 90.0) * (0.821) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.0 && pt <= 100.0) * (0.820) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.0 && pt <= 120.0) * (0.815) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.0 && pt <= 140.0) * (0.811) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.0 && pt <= 160.0) * (0.798) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.0 && pt <= 180.0) * (0.778) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.0 && pt <= 200.0) * (0.775) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.0 && pt <= 250.0) * (0.784) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.0 && pt <= 300.0) * (0.762) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.0 && pt <= 350.0) * (0.716) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.0 && pt <= 400.0) * (0.675) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.0 && pt <= 500.0) * (0.64) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.0 && pt <= 600.0) * (0.60) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 600.0 && pt <= 700.0) * (0.56) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 700.0 && pt <= 800.0) * (0.53) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 800.0 && pt <=1000.0) * (0.50) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >1000.0 && pt <=1400.0) * (0.47) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >1400.0 && pt <=2000.0) * (0.44) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >2000.0 && pt <=3000.0) * (0.41) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >3000.0) * (0.39) 
                                 }

  add EfficiencyFormula {4}      {
                                  (abs(eta) <= 1.50) * (pt > 20.0 && pt <= 30.0) * (0.520) +
                                  (abs(eta) <= 1.50) * (pt > 30.0 && pt <= 40.0) * (0.530) +
                                  (abs(eta) <= 1.50) * (pt > 40.0 && pt <= 50.0) * (0.535) +
                                  (abs(eta) <= 1.50) * (pt > 50.0 && pt <= 60.0) * (0.537) +
                                  (abs(eta) <= 1.50) * (pt > 60.0 && pt <= 70.0) * (0.549) +
                                  (abs(eta) <= 1.50) * (pt > 70.0 && pt <= 80.0) * (0.548) +
                                  (abs(eta) <= 1.50) * (pt > 80.0 && pt <= 90.0) * (0.554) +
                                  (abs(eta) <= 1.50) * (pt > 90.0 && pt <= 100.0) * (0.558) +
                                  (abs(eta) <= 1.50) * (pt > 100.0 && pt <= 120.0) * (0.570) +
                                  (abs(eta) <= 1.50) * (pt > 120.0 && pt <= 140.0) * (0.569) +
                                  (abs(eta) <= 1.50) * (pt > 140.0 && pt <= 160.0) * (0.575) +
                                  (abs(eta) <= 1.50) * (pt > 160.0 && pt <= 180.0) * (0.576) +
                                  (abs(eta) <= 1.50) * (pt > 180.0 && pt <= 200.0) * (0.576) +
                                  (abs(eta) <= 1.50) * (pt > 200.0 && pt <= 250.0) * (0.576) +
                                  (abs(eta) <= 1.50) * (pt > 250.0 && pt <= 300.0) * (0.573) +
                                  (abs(eta) <= 1.50) * (pt > 300.0 && pt <= 350.0) * (0.573) +
                                  (abs(eta) <= 1.50) * (pt > 350.0 && pt <= 400.0) * (0.558) +
                                  (abs(eta) <= 1.50) * (pt > 400.0 && pt <= 500.0) * (0.549) +
                                  (abs(eta) <= 1.50) * (pt > 500.0 && pt <= 600.0) * (0.527) +
                                  (abs(eta) <= 1.50) * (pt > 600.0 && pt <= 700.0) * (0.509) +
                                  (abs(eta) <= 1.50) * (pt > 700.0 && pt <= 800.0) * (0.490) +
                                  (abs(eta) <= 1.50) * (pt > 800.0 && pt <= 1000.0) * (0.459) +
                                  (abs(eta) <= 1.50) * (pt > 1000.0 && pt <= 1400.0) * (0.411) +
                                  (abs(eta) <= 1.50) * (pt > 1400.0 && pt <= 2000.0) * (0.378) +
                                  (abs(eta) <= 1.50) * (pt > 2000.0) * (0.381) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.0 && pt <= 30.0) * (0.425) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.0 && pt <= 40.0) * (0.435) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.0 && pt <= 50.0) * (0.448) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.0 && pt <= 60.0) * (0.457) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.0 && pt <= 70.0) * (0.464) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.0 && pt <= 80.0) * (0.471) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.0 && pt <= 90.0) * (0.473) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.0 && pt <= 100.0) * (0.484) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.0 && pt <= 120.0) * (0.485) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.0 && pt <= 140.0) * (0.495) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.0 && pt <= 160.0) * (0.498) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.0 && pt <= 180.0) * (0.490) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.0 && pt <= 200.0) * (0.499) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.0 && pt <= 250.0) * (0.495) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.0 && pt <= 300.0) * (0.484) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.0 && pt <= 350.0) * (0.474) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.0 && pt <= 400.0) * (0.475) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.0 && pt <= 500.0) * (0.446) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.0 && pt <= 600.0) * (0.435) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.0 && pt <= 700.0) * (0.408) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.0 && pt <= 800.0) * (0.416) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.0) * (0.416) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.0 && pt <= 30.0) * (0.341) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.0 && pt <= 40.0) * (0.366) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.0 && pt <= 50.0) * (0.376) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.0 && pt <= 60.0) * (0.387) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.0 && pt <= 70.0) * (0.393) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.0 && pt <= 80.0) * (0.396) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.0 && pt <= 90.0) * (0.409) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.0 && pt <= 100.0) * (0.395) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.0 && pt <= 120.0) * (0.388) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.0 && pt <= 140.0) * (0.406) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.0 && pt <= 160.0) * (0.398) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.0 && pt <= 180.0) * (0.377) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.0 && pt <= 200.0) * (0.397) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.0 && pt <= 250.0) * (0.391) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.0) * (0.391) 
                                 }
}

module BTagging BTaggingPUPPIMedium {

  set JetInputArray JetEnergyScalePUPPI/jets

  set BitNumber 1

  add EfficiencyFormula {0}      {0.01}

  add EfficiencyFormula {5}      {
                                  (abs(eta) <= 1.50) * (pt > 20.0 && pt <= 30.0) * (0.745) +
                                  (abs(eta) <= 1.50) * (pt > 30.0 && pt <= 40.0) * (0.793) +
                                  (abs(eta) <= 1.50) * (pt > 40.0 && pt <= 50.0) * (0.807) +
                                  (abs(eta) <= 1.50) * (pt > 50.0 && pt <= 60.0) * (0.822) +
                                  (abs(eta) <= 1.50) * (pt > 60.0 && pt <= 70.0) * (0.831) +
                                  (abs(eta) <= 1.50) * (pt > 70.0 && pt <= 80.0) * (0.838) +
                                  (abs(eta) <= 1.50) * (pt > 80.0 && pt <= 90.0) * (0.842) +
                                  (abs(eta) <= 1.50) * (pt > 90.0 && pt <= 100.0) * (0.842) +
                                  (abs(eta) <= 1.50) * (pt > 100.0 && pt <= 120.0) * (0.84) +
                                  (abs(eta) <= 1.50) * (pt > 120.0 && pt <= 140.0) * (0.848) +
                                  (abs(eta) <= 1.50) * (pt > 140.0 && pt <= 160.0) * (0.846) +
                                  (abs(eta) <= 1.50) * (pt > 160.0 && pt <= 180.0) * (0.847) +
                                  (abs(eta) <= 1.50) * (pt > 180.0 && pt <= 200.0) * (0.843) +
                                  (abs(eta) <= 1.50) * (pt > 200.0 && pt <= 250.0) * (0.84) +
                                  (abs(eta) <= 1.50) * (pt > 250.0 && pt <= 300.0) * (0.825) +
                                  (abs(eta) <= 1.50) * (pt > 300.0 && pt <= 350.0) * (0.821) +
                                  (abs(eta) <= 1.50) * (pt > 350.0 && pt <= 400.0) * (0.804) +
                                  (abs(eta) <= 1.50) * (pt > 400.0 && pt <= 500.0) * (0.783) +
                                  (abs(eta) <= 1.50) * (pt > 500.0 && pt <= 600.0) * (0.76) +
                                  (abs(eta) <= 1.50) * (pt > 600.0 && pt <= 700.0) * (0.72) +
                                  (abs(eta) <= 1.50) * (pt > 700.0 && pt <= 800.0) * (0.63) +
                                  (abs(eta) <= 1.50) * (pt > 800.0 && pt <= 1000.0) * (0.59) +
                                  (abs(eta) <= 1.50) * (pt > 1000.0 && pt <= 1400.0) * (0.56) +
                                  (abs(eta) <= 1.50) * (pt > 1400.0 && pt <= 2000.0) * (0.53) +
                                  (abs(eta) <= 1.50) * (pt > 2000.0 && pt <= 3000.0) * (0.50) +
                                  (abs(eta) <= 1.50) * (pt > 3000.0) * (0.47) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.0 && pt <= 30.0) * (0.617) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.0 && pt <= 40.0) * (0.685) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.0 && pt <= 50.0) * (0.709) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.0 && pt <= 60.0) * (0.737) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.0 && pt <= 70.0) * (0.749) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.0 && pt <= 80.0) * (0.759) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.0 && pt <= 90.0) * (0.762) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.0 && pt <= 100.0) * (0.771) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.0 && pt <= 120.0) * (0.777) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.0 && pt <= 140.0) * (0.767) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.0 && pt <= 160.0) * (0.765) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.0 && pt <= 180.0) * (0.756) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.0 && pt <= 200.0) * (0.758) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.0 && pt <= 250.0) * (0.755) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.0 && pt <= 300.0) * (0.739) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.0 && pt <= 350.0) * (0.730) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.0 && pt <= 400.0) * (0.725) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.0 && pt <= 500.0) * (0.692) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.0 && pt <= 600.0) * (0.645) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.0 && pt <= 700.0) * (0.639) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.0 && pt <= 800.0) * (0.587) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.0 && pt <= 1000.0) * (0.585) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1000.0 && pt <= 1400.0) * (0.53) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1400.0 && pt <= 2000.0) * (0.48) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 2000.0 && pt <= 3000.0) * (0.44) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 3000.0) * (0.40) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.0 && pt <= 30.0) * (0.439) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.0 && pt <= 40.0) * (0.524) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.0 && pt <= 50.0) * (0.565) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.0 && pt <= 60.0) * (0.588) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.0 && pt <= 70.0) * (0.608) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.0 && pt <= 80.0) * (0.595) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.0 && pt <= 90.0) * (0.631) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.0 && pt <= 100.0) * (0.615) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.0 && pt <= 120.0) * (0.620) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.0 && pt <= 140.0) * (0.621) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.0 && pt <= 160.0) * (0.613) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.0 && pt <= 180.0) * (0.584) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.0 && pt <= 200.0) * (0.594) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.0 && pt <= 250.0) * (0.607) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.0 && pt <= 300.0) * (0.555) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.0 && pt <= 350.0) * (0.510) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.0 && pt <= 400.0) * (0.486) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.0 && pt <= 500.0) * (0.46) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.0 && pt <= 600.0) * (0.44) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 600.0 && pt <= 700.0) * (0.42) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 700.0 && pt <= 800.0) * (0.40) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 800.0 && pt <=1000.0) * (0.38) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >1000.0 && pt <=1400.0) * (0.36) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >1400.0 && pt <=2000.0) * (0.34) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >2000.0 && pt <=3000.0) * (0.32) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >3000.0) * (0.31) 
                                 }

  add EfficiencyFormula {4}      {
                                  (abs(eta) <= 1.50) * (pt > 20.0 && pt <= 30.0) * (0.206) +
                                  (abs(eta) <= 1.50) * (pt > 30.0 && pt <= 40.0) * (0.202) +
                                  (abs(eta) <= 1.50) * (pt > 40.0 && pt <= 50.0) * (0.200) +
                                  (abs(eta) <= 1.50) * (pt > 50.0 && pt <= 60.0) * (0.205) +
                                  (abs(eta) <= 1.50) * (pt > 60.0 && pt <= 70.0) * (0.214) +
                                  (abs(eta) <= 1.50) * (pt > 70.0 && pt <= 80.0) * (0.219) +
                                  (abs(eta) <= 1.50) * (pt > 80.0 && pt <= 90.0) * (0.224) +
                                  (abs(eta) <= 1.50) * (pt > 90.0 && pt <= 100.0) * (0.224) +
                                  (abs(eta) <= 1.50) * (pt > 100.0 && pt <= 120.0) * (0.234) +
                                  (abs(eta) <= 1.50) * (pt > 120.0 && pt <= 140.0) * (0.240) +
                                  (abs(eta) <= 1.50) * (pt > 140.0 && pt <= 160.0) * (0.251) +
                                  (abs(eta) <= 1.50) * (pt > 160.0 && pt <= 180.0) * (0.249) +
                                  (abs(eta) <= 1.50) * (pt > 180.0 && pt <= 200.0) * (0.255) +
                                  (abs(eta) <= 1.50) * (pt > 200.0 && pt <= 250.0) * (0.255) +
                                  (abs(eta) <= 1.50) * (pt > 250.0 && pt <= 300.0) * (0.247) +
                                  (abs(eta) <= 1.50) * (pt > 300.0 && pt <= 350.0) * (0.243) +
                                  (abs(eta) <= 1.50) * (pt > 350.0 && pt <= 400.0) * (0.228) +
                                  (abs(eta) <= 1.50) * (pt > 400.0 && pt <= 500.0) * (0.209) +
                                  (abs(eta) <= 1.50) * (pt > 500.0 && pt <= 600.0) * (0.189) +
                                  (abs(eta) <= 1.50) * (pt > 600.0 && pt <= 700.0) * (0.178) +
                                  (abs(eta) <= 1.50) * (pt > 700.0 && pt <= 800.0) * (0.169) +
                                  (abs(eta) <= 1.50) * (pt > 800.0 && pt <= 1000.0) * (0.153) +
                                  (abs(eta) <= 1.50) * (pt > 1000.0 && pt <= 1400.0) * (0.145) +
                                  (abs(eta) <= 1.50) * (pt > 1400.0 && pt <= 2000.0) * (0.147) +
                                  (abs(eta) <= 1.50) * (pt > 2000.0) * (0.155) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.0 && pt <= 30.0) * (0.154) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.0 && pt <= 40.0) * (0.146) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.0 && pt <= 50.0) * (0.150) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.0 && pt <= 60.0) * (0.157) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.0 && pt <= 70.0) * (0.156) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.0 && pt <= 80.0) * (0.161) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.0 && pt <= 90.0) * (0.165) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.0 && pt <= 100.0) * (0.172) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.0 && pt <= 120.0) * (0.174) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.0 && pt <= 140.0) * (0.185) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.0 && pt <= 160.0) * (0.190) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.0 && pt <= 180.0) * (0.187) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.0 && pt <= 200.0) * (0.189) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.0 && pt <= 250.0) * (0.192) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.0 && pt <= 300.0) * (0.194) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.0 && pt <= 350.0) * (0.188) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.0 && pt <= 400.0) * (0.195) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.0 && pt <= 500.0) * (0.174) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.0 && pt <= 600.0) * (0.159) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.0 && pt <= 700.0) * (0.143) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.0 && pt <= 800.0) * (0.146) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.0) * (0.154) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.0 && pt <= 30.0) * (0.121) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.0 && pt <= 40.0) * (0.130) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.0 && pt <= 50.0) * (0.127) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.0 && pt <= 60.0) * (0.130) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.0 && pt <= 70.0) * (0.135) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.0 && pt <= 80.0) * (0.137) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.0 && pt <= 90.0) * (0.146) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.0 && pt <= 100.0) * (0.138) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.0 && pt <= 120.0) * (0.144) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.0 && pt <= 140.0) * (0.149) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.0 && pt <= 160.0) * (0.149) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.0 && pt <= 180.0) * (0.144) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.0 && pt <= 200.0) * (0.151) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.0 && pt <= 250.0) * (0.152) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.0 && pt <= 300.0) * (0.137) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.0 && pt <= 350.0) * (0.157) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.0 && pt <= 400.0) * (0.137) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.0 && pt <= 500.0) * (0.162) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.0) * (0.178) 
                                 }
}

module BTagging BTaggingPUPPITight {

  set JetInputArray JetEnergyScalePUPPI/jets

  set BitNumber 2

  add EfficiencyFormula {0}      {0.001}

  add EfficiencyFormula {5}      {
                                  (abs(eta) <= 1.50) * (pt > 20.0 && pt <= 30.0) * (0.553) +
                                  (abs(eta) <= 1.50) * (pt > 30.0 && pt <= 40.0) * (0.628) +
                                  (abs(eta) <= 1.50) * (pt > 40.0 && pt <= 50.0) * (0.660) +
                                  (abs(eta) <= 1.50) * (pt > 50.0 && pt <= 60.0) * (0.678) +
                                  (abs(eta) <= 1.50) * (pt > 60.0 && pt <= 70.0) * (0.692) +
                                  (abs(eta) <= 1.50) * (pt > 70.0 && pt <= 80.0) * (0.704) +
                                  (abs(eta) <= 1.50) * (pt > 80.0 && pt <= 90.0) * (0.711) +
                                  (abs(eta) <= 1.50) * (pt > 90.0 && pt <= 100.0) * (0.706) +
                                  (abs(eta) <= 1.50) * (pt > 100.0 && pt <= 120.0) * (0.704) +
                                  (abs(eta) <= 1.50) * (pt > 120.0 && pt <= 140.0) * (0.711) +
                                  (abs(eta) <= 1.50) * (pt > 140.0 && pt <= 160.0) * (0.704) +
                                  (abs(eta) <= 1.50) * (pt > 160.0 && pt <= 180.0) * (0.704) +
                                  (abs(eta) <= 1.50) * (pt > 180.0 && pt <= 200.0) * (0.697) +
                                  (abs(eta) <= 1.50) * (pt > 200.0 && pt <= 250.0) * (0.683) +
                                  (abs(eta) <= 1.50) * (pt > 250.0 && pt <= 300.0) * (0.665) +
                                  (abs(eta) <= 1.50) * (pt > 300.0 && pt <= 350.0) * (0.653) +
                                  (abs(eta) <= 1.50) * (pt > 350.0 && pt <= 400.0) * (0.59) +
                                  (abs(eta) <= 1.50) * (pt > 400.0 && pt <= 500.0) * (0.55) +
                                  (abs(eta) <= 1.50) * (pt > 500.0 && pt <= 600.0) * (0.50) +
                                  (abs(eta) <= 1.50) * (pt > 600.0 && pt <= 700.0) * (0.46) +
                                  (abs(eta) <= 1.50) * (pt > 700.0 && pt <= 800.0) * (0.39) +
                                  (abs(eta) <= 1.50) * (pt > 800.0 && pt <= 1000.0) * (0.35) +
                                  (abs(eta) <= 1.50) * (pt > 1000.0 && pt <= 1400.0) * (0.31) +
                                  (abs(eta) <= 1.50) * (pt > 1400.0 && pt <= 2000.0) * (0.29) +
                                  (abs(eta) <= 1.50) * (pt > 2000.0 && pt <= 3000.0) * (0.27) +
                                  (abs(eta) <= 1.50) * (pt > 3000.0) * (0.25) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.0 && pt <= 30.0) * (0.403) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.0 && pt <= 40.0) * (0.492) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.0 && pt <= 50.0) * (0.533) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.0 && pt <= 60.0) * (0.565) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.0 && pt <= 70.0) * (0.586) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.0 && pt <= 80.0) * (0.585) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.0 && pt <= 90.0) * (0.589) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.0 && pt <= 100.0) * (0.602) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.0 && pt <= 120.0) * (0.599) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.0 && pt <= 140.0) * (0.594) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.0 && pt <= 160.0) * (0.583) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.0 && pt <= 180.0) * (0.573) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.0 && pt <= 200.0) * (0.575) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.0 && pt <= 250.0) * (0.565) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.0 && pt <= 300.0) * (0.553) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.0 && pt <= 350.0) * (0.51) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.0 && pt <= 400.0) * (0.43) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.0 && pt <= 500.0) * (0.43) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.0 && pt <= 600.0) * (0.38) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.0 && pt <= 700.0) * (0.37) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.0 && pt <= 800.0) * (0.32) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.0 && pt <= 1000.0) * (0.32) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1000.0 && pt <= 1400.0) * (0.29) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 1400.0 && pt <= 2000.0) * (0.26) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 2000.0 && pt <= 3000.0) * (0.23) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 3000.0) * (0.22) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.0 && pt <= 30.0) * (0.244) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.0 && pt <= 40.0) * (0.317) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.0 && pt <= 50.0) * (0.366) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.0 && pt <= 60.0) * (0.394) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.0 && pt <= 70.0) * (0.408) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.0 && pt <= 80.0) * (0.391) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.0 && pt <= 90.0) * (0.431) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.0 && pt <= 100.0) * (0.430) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.0 && pt <= 120.0) * (0.410) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.0 && pt <= 140.0) * (0.424) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.0 && pt <= 160.0) * (0.412) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.0 && pt <= 180.0) * (0.393) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.0 && pt <= 200.0) * (0.410) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.0 && pt <= 250.0) * (0.400) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.0 && pt <= 300.0) * (0.367) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 300.0 && pt <= 350.0) * (0.333) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 350.0 && pt <= 400.0) * (0.307) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 400.0 && pt <= 500.0) * (0.28) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 500.0 && pt <= 600.0) * (0.26) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 600.0 && pt <= 700.0) * (0.24) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 700.0 && pt <= 800.0) * (0.22) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 800.0 && pt <=1000.0) * (0.20) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >1000.0 && pt <=1400.0) * (0.19) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >1400.0 && pt <=2000.0) * (0.17) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >2000.0 && pt <=3000.0) * (0.16) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt >3000.0) * (0.14) 
                                 }

  add EfficiencyFormula {4}      {
                                  (abs(eta) <= 1.50) * (pt > 20.0 && pt <= 30.0) * (0.047) +
                                  (abs(eta) <= 1.50) * (pt > 30.0 && pt <= 40.0) * (0.048) +
                                  (abs(eta) <= 1.50) * (pt > 40.0 && pt <= 50.0) * (0.051) +
                                  (abs(eta) <= 1.50) * (pt > 50.0 && pt <= 60.0) * (0.053) +
                                  (abs(eta) <= 1.50) * (pt > 60.0 && pt <= 70.0) * (0.057) +
                                  (abs(eta) <= 1.50) * (pt > 70.0 && pt <= 80.0) * (0.060) +
                                  (abs(eta) <= 1.50) * (pt > 80.0 && pt <= 90.0) * (0.063) +
                                  (abs(eta) <= 1.50) * (pt > 90.0 && pt <= 100.0) * (0.061) +
                                  (abs(eta) <= 1.50) * (pt > 100.0 && pt <= 120.0) * (0.063) +
                                  (abs(eta) <= 1.50) * (pt > 120.0 && pt <= 140.0) * (0.064) +
                                  (abs(eta) <= 1.50) * (pt > 140.0 && pt <= 160.0) * (0.068) +
                                  (abs(eta) <= 1.50) * (pt > 160.0 && pt <= 180.0) * (0.067) +
                                  (abs(eta) <= 1.50) * (pt > 180.0 && pt <= 200.0) * (0.070) +
                                  (abs(eta) <= 1.50) * (pt > 200.0 && pt <= 250.0) * (0.066) +
                                  (abs(eta) <= 1.50) * (pt > 250.0 && pt <= 300.0) * (0.067) +
                                  (abs(eta) <= 1.50) * (pt > 300.0 && pt <= 350.0) * (0.062) +
                                  (abs(eta) <= 1.50) * (pt > 350.0 && pt <= 400.0) * (0.056) +
                                  (abs(eta) <= 1.50) * (pt > 400.0 && pt <= 500.0) * (0.047) +
                                  (abs(eta) <= 1.50) * (pt > 500.0 && pt <= 600.0) * (0.043) +
                                  (abs(eta) <= 1.50) * (pt > 600.0 && pt <= 700.0) * (0.039) +
                                  (abs(eta) <= 1.50) * (pt > 700.0 && pt <= 800.0) * (0.035) +
                                  (abs(eta) <= 1.50) * (pt > 800.0 && pt <= 1000.0) * (0.028) +
                                  (abs(eta) <= 1.50) * (pt > 1000.0 && pt <= 1400.0) * (0.028) +
                                  (abs(eta) <= 1.50) * (pt > 1400.0 && pt <= 2000.0) * (0.027) +
                                  (abs(eta) <= 1.50) * (pt > 2000.0) * (0.027) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 20.0 && pt <= 30.0) * (0.033) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 30.0 && pt <= 40.0) * (0.033) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 40.0 && pt <= 50.0) * (0.034) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 50.0 && pt <= 60.0) * (0.039) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 60.0 && pt <= 70.0) * (0.043) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 70.0 && pt <= 80.0) * (0.041) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 80.0 && pt <= 90.0) * (0.038) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 90.0 && pt <= 100.0) * (0.042) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 100.0 && pt <= 120.0) * (0.045) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 120.0 && pt <= 140.0) * (0.047) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 140.0 && pt <= 160.0) * (0.042) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 160.0 && pt <= 180.0) * (0.047) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 180.0 && pt <= 200.0) * (0.044) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 200.0 && pt <= 250.0) * (0.045) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 250.0 && pt <= 300.0) * (0.044) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 300.0 && pt <= 350.0) * (0.050) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 350.0 && pt <= 400.0) * (0.043) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 400.0 && pt <= 500.0) * (0.030) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 500.0 && pt <= 600.0) * (0.028) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 600.0 && pt <= 700.0) * (0.028) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 700.0 && pt <= 800.0) * (0.028) +
                                  (abs(eta) > 1.50 && abs(eta) <= 2.50) * (pt > 800.0) * (0.028) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 20.0 && pt <= 30.0) * (0.030) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 30.0 && pt <= 40.0) * (0.029) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 40.0 && pt <= 50.0) * (0.031) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 50.0 && pt <= 60.0) * (0.030) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 60.0 && pt <= 70.0) * (0.036) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 70.0 && pt <= 80.0) * (0.032) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 80.0 && pt <= 90.0) * (0.039) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 90.0 && pt <= 100.0) * (0.041) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 100.0 && pt <= 120.0) * (0.034) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 120.0 && pt <= 140.0) * (0.033) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 140.0 && pt <= 160.0) * (0.036) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 160.0 && pt <= 180.0) * (0.034) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 180.0 && pt <= 200.0) * (0.038) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 200.0 && pt <= 250.0) * (0.040) +
                                  (abs(eta) > 2.50 && abs(eta) <= 3.50) * (pt > 250.0) * (0.03) 
                                 }
}



#############
# tau-tagging
#############


module TauTagging TauTaggingCutBased {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScale/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 2.3

  set BitNumber 0

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}

  add EfficiencyFormula {0}  { (abs(eta) < 2.3) * ((( -0.00621816+0.00130097*pt-2.19642e-5*pt^2+1.49393e-7*pt^3-4.58972e-10*pt^4+5.27983e-13*pt^5 )) * (pt<250) + 0.0032*(pt>250)) + \
                               (abs(eta) > 2.3) * (0.000)
                             }
  add EfficiencyFormula {15} { (abs(eta) < 2.3) * 0.97*0.77*( (0.32 + 0.01*pt - 0.000054*pt*pt )*(pt<100)+0.78*(pt>100) ) + \
                               (abs(eta) > 2.3) * (0.000)
                             }
}


module TauTagging TauTaggingDNNMedium {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScale/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 3.0

  set BitNumber 1

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}

  add EfficiencyFormula {0} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.005) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.023) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.015) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.011) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.007) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.004) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.005) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.021) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.023) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.015) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.010) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.006) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.004) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.026) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.018) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.012) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.008) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.004) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.028) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.020) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.014) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.009) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.005) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)                 * (0.005) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.031) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.025) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.018) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.013) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.009) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.009)
                                 
                             }

  add EfficiencyFormula {15} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.643) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.800) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.846) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.877) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.928) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.940) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.953) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.953) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.634) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.795) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.837) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.876) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.910) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.929) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.973) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.973) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.625) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.777) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.821) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.857) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.869) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.864) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.838) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.838) + 
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.653) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.793) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.829) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.871) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.876) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.869) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.856) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)  	        * (0.856) + 
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.638) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.754) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.791) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.846) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.860) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.850) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.778) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.778)
                           }
}

module TauTagging TauTaggingDNNTight {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScale/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 3.0

  set BitNumber 2

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}
  add EfficiencyFormula {0} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.003) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.001) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.001) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.001) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.001) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.002) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)                 * (0.001) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.001) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.002) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.002)
                             }

  add EfficiencyFormula {15} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.402) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.560) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.646) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.711) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.761) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.775) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.860) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.860) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.379) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.518) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.606) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.693) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.728) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.770) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.818) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.818) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.339) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.409) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.493) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.610) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.659) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.678) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.631) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.631) + 
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.396) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.450) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.510) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.627) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.681) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.705) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.644) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)  	        * (0.644) + 
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.364) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.392) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.445) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.579) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.621) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.627) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.622) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.622)
                           }
}


module TauTagging TauTaggingAK8CutBased {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScaleAK8/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 2.3

  set BitNumber 0

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}

  add EfficiencyFormula {0}  { (abs(eta) < 2.3) * ((( -0.00621816+0.00130097*pt-2.19642e-5*pt^2+1.49393e-7*pt^3-4.58972e-10*pt^4+5.27983e-13*pt^5 )) * (pt<250) + 0.0032*(pt>250)) + \
                               (abs(eta) > 2.3) * (0.000)
                             }
  add EfficiencyFormula {15} { (abs(eta) < 2.3) * 0.97*0.77*( (0.32 + 0.01*pt - 0.000054*pt*pt )*(pt<100)+0.78*(pt>100) ) + \
                               (abs(eta) > 2.3) * (0.000)
                             }
}


module TauTagging TauTaggingAK8DNNMedium {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScaleAK8/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 3.0

  set BitNumber 1

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}
  add EfficiencyFormula {0} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.005) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.023) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.015) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.011) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.007) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.004) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.005) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.021) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.023) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.015) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.010) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.006) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.004) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.026) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.018) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.012) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.008) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.004) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.028) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.020) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.014) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.009) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.005) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)                 * (0.005) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.031) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.025) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.018) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.013) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.009) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.009)
                                 
                             }

  add EfficiencyFormula {15} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.643) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.800) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.846) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.877) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.928) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.940) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.953) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.953) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.634) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.795) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.837) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.876) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.910) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.929) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.973) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.973) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.625) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.777) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.821) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.857) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.869) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.864) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.838) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.838) + 
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.653) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.793) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.829) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.871) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.876) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.869) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.856) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)  	        * (0.856) + 
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.638) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.754) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.791) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.846) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.860) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.850) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.778) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.778)
                           }



}

module TauTagging TauTaggingAK8DNNTight {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScaleAK8/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 3.0

  set BitNumber 2

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}
  add EfficiencyFormula {0} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.003) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.001) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.001) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.001) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.001) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.002) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)                 * (0.001) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.001) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.002) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.002)
                             }

  add EfficiencyFormula {15} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.402) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.560) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.646) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.711) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.761) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.775) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.860) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.860) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.379) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.518) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.606) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.693) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.728) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.770) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.818) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.818) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.339) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.409) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.493) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.610) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.659) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.678) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.631) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.631) + 
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.396) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.450) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.510) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.627) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.681) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.705) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.644) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)  	        * (0.644) + 
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.364) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.392) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.445) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.579) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.621) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.627) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.622) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.622)
                           }
}




##############################################################
module TauTagging TauTaggingPUPPICutBased {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPI/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 2.3

  set BitNumber 0

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}

  add EfficiencyFormula {0}  { (abs(eta) < 2.3) * ((( -0.00621816+0.00130097*pt-2.19642e-5*pt^2+1.49393e-7*pt^3-4.58972e-10*pt^4+5.27983e-13*pt^5 )) * (pt<250) + 0.0032*(pt>250)) + \
                               (abs(eta) > 2.3) * (0.000)
                             }
  add EfficiencyFormula {15} { (abs(eta) < 2.3) * 0.97*0.77*( (0.32 + 0.01*pt - 0.000054*pt*pt )*(pt<=100)+0.78*(pt>100) ) + \
                               (abs(eta) > 2.3) * (0.000)
                             }
}

#############################################################
module TauTagging TauTaggingPUPPICutBasedLoose {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPI/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 2.4

  set BitNumber 0

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}

  add EfficiencyFormula {0}  { (abs(eta) < 2.4) * ((( -0.00621816+0.00130097*pt-2.19642e-5*pt^2+1.49393e-7*pt^3-4.58972e-10*pt^4+5.27983e-13*pt^5 )) * (pt<250) + 0.0032*(pt>250)) + \
                               (abs(eta) > 2.4) * (0.000)
                             }
  add EfficiencyFormula {15} { (abs(eta) < 2.4) * (0.60) + \
                               (abs(eta) > 2.4) * (0.000)
                             }
}

#############################################################
module TauTagging TauTaggingPUPPICutBasedMedium {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPI/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 2.4

  set BitNumber 1

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}

  add EfficiencyFormula {0}  { (abs(eta) < 2.4) * 0.7*((( -0.00621816+0.00130097*pt-2.19642e-5*pt^2+1.49393e-7*pt^3-4.58972e-10*pt^4+5.27983e-13*pt^5 )) * (pt<250) + 0.0032*(pt>250)) + \
                               (abs(eta) > 2.4) * (0.000)
                             }
  add EfficiencyFormula {15} { (abs(eta) < 2.4) * (0.55) + \
                               (abs(eta) > 2.4) * (0.000)
                             }
}


#############################################################
module TauTagging TauTaggingPUPPICutBasedTight {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPI/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 2.4

  set BitNumber 2

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}

  add EfficiencyFormula {0}  { (abs(eta) < 2.4) * 0.25*((( -0.00621816+0.00130097*pt-2.19642e-5*pt^2+1.49393e-7*pt^3-4.58972e-10*pt^4+5.27983e-13*pt^5 )) * (pt<250) + 0.0032*(pt>250)) + \
                               (abs(eta) > 2.4) * (0.000)
                             }
  add EfficiencyFormula {15} { (abs(eta) < 2.4) * (0.55) + \
                               (abs(eta) > 2.4) * (0.000)
                             }
}


#############################################################
module TauTagging TauTaggingPUPPICutBasedVeryTight {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPI/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 2.4

  set BitNumber 3

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}

  add EfficiencyFormula {0}  { (abs(eta) < 2.4) * 0.15*((( -0.00621816+0.00130097*pt-2.19642e-5*pt^2+1.49393e-7*pt^3-4.58972e-10*pt^4+5.27983e-13*pt^5 )) * (pt<250) + 0.0032*(pt>250)) + \
                               (abs(eta) > 2.4) * (0.000)
                             }
  add EfficiencyFormula {15} { (abs(eta) < 2.4) * (0.55) + \
                               (abs(eta) > 2.4) * (0.000)
                             }
}

module TauTagging TauTaggingPUPPIDNNMedium {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPI/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 3.0

  set BitNumber 4

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}
  add EfficiencyFormula {0} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.005) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.023) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.015) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.011) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.007) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.004) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.005) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.021) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.023) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.015) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.010) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.006) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.004) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.026) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.018) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.012) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.008) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.004) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.028) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.020) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.014) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.009) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.005) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)                 * (0.005) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.031) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.025) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.018) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.013) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.009) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.009)
                                 
                             }

  add EfficiencyFormula {15} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.643) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.800) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.846) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.877) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.928) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.940) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.953) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.953) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.634) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.795) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.837) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.876) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.910) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.929) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.973) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.973) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.625) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.777) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.821) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.857) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.869) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.864) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.838) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.838) + 
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.653) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.793) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.829) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.871) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.876) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.869) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.856) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)  	        * (0.856) + 
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.638) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.754) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.791) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.846) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.860) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.850) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.778) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.778)
                           }

}



module TauTagging TauTaggingPUPPIDNNTight {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPI/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 3.0

  set BitNumber 5
  
  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}
  add EfficiencyFormula {0} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.003) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.001) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.001) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.001) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.001) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.002) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)                 * (0.001) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.001) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.002) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.002)
                             }

  add EfficiencyFormula {15} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.402) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.560) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.646) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.711) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.761) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.775) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.860) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.860) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.379) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.518) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.606) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.693) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.728) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.770) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.818) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.818) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.339) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.409) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.493) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.610) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.659) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.678) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.631) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.631) + 
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.396) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.450) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.510) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.627) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.681) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.705) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.644) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)  	        * (0.644) + 
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.364) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.392) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.445) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.579) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.621) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.627) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.622) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.622)
                           }

}



module TauTagging TauTaggingPUPPIAK8CutBased {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPIAK8/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 2.3

  set BitNumber 0

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}


}

module TauTagging TauTaggingPUPPIAK8DNNMedium {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPIAK8/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 3.0

  set BitNumber 1

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}
  add EfficiencyFormula {0} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.005) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.023) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.015) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.011) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.007) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.004) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.005) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.021) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.023) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.015) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.010) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.006) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.004) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.026) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.018) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.012) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.008) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.004) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.004) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.028) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.020) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.014) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.009) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.005) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)                 * (0.005) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.006) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.022) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.031) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.025) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.018) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.013) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.009) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.009)
                                 
                             }

  add EfficiencyFormula {15} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.643) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.800) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.846) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.877) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.928) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.940) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.953) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.953) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.634) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.795) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.837) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.876) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.910) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.929) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.973) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.973) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.625) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.777) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.821) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.857) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.869) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.864) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.838) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.838) + 
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.653) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.793) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.829) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.871) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.876) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.869) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.856) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)  	        * (0.856) + 
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.638) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.754) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.791) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.846) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.860) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.850) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.778) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.778)
                           }


}

module TauTagging TauTaggingPUPPIAK8DNNTight {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScalePUPPIAK8/jets

  set DeltaR 0.5

  set TauPTMin 20.0

  set TauEtaMax 3.0

  set BitNumber 2

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}
  add EfficiencyFormula {0} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.003) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.001) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.001) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.002) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.001) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.002) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.001) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.001) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.002) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.003) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.002) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)                 * (0.001) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.0005) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.001) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.002) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.003) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.002)
                             }

  add EfficiencyFormula {15} { 
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  20.00 && pt <=  30.00) * (0.402) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  30.00 && pt <=  40.00) * (0.560) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  40.00 && pt <=  60.00) * (0.646) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  60.00 && pt <=  80.00) * (0.711) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt >  80.00 && pt <= 100.00) * (0.761) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 100.00 && pt <= 150.00) * (0.775) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 150.00 && pt <= 200.00) * (0.860) +
                                  (abs(eta) > 0.00 && abs(eta) <= 0.50) * (pt > 200.00)                 * (0.860) + 
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  20.00 && pt <=  30.00) * (0.379) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  30.00 && pt <=  40.00) * (0.518) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  40.00 && pt <=  60.00) * (0.606) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  60.00 && pt <=  80.00) * (0.693) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt >  80.00 && pt <= 100.00) * (0.728) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 100.00 && pt <= 150.00) * (0.770) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 150.00 && pt <= 200.00) * (0.818) +
                                  (abs(eta) > 0.50 && abs(eta) <= 1.00) * (pt > 200.00)                 * (0.818) + 
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  20.00 && pt <=  30.00) * (0.339) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  30.00 && pt <=  40.00) * (0.409) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  40.00 && pt <=  60.00) * (0.493) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  60.00 && pt <=  80.00) * (0.610) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt >  80.00 && pt <= 100.00) * (0.659) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 100.00 && pt <= 150.00) * (0.678) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 150.00 && pt <= 200.00) * (0.631) +
                                  (abs(eta) > 1.00 && abs(eta) <= 1.60) * (pt > 200.00)                 * (0.631) + 
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  20.00 && pt <=  30.00) * (0.396) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  30.00 && pt <=  40.00) * (0.450) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  40.00 && pt <=  60.00) * (0.510) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  60.00 && pt <=  80.00) * (0.627) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt >  80.00 && pt <= 100.00) * (0.681) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 100.00 && pt <= 150.00) * (0.705) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 150.00 && pt <= 200.00) * (0.644) +
                                  (abs(eta) > 1.60 && abs(eta) <= 2.10) * (pt > 200.00)  	        * (0.644) + 
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  20.00 && pt <=  30.00) * (0.364) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  30.00 && pt <=  40.00) * (0.392) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  40.00 && pt <=  60.00) * (0.445) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  60.00 && pt <=  80.00) * (0.579) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt >  80.00 && pt <= 100.00) * (0.621) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 100.00 && pt <= 150.00) * (0.627) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 150.00 && pt <= 200.00) * (0.622) +
                                  (abs(eta) > 2.10 && abs(eta) <= 3.00) * (pt > 200.00)                 * (0.622)
                           }

}




#################################
# Jet Fake Particle Maker Loose #
#################################

module JetFakeParticle JetFakeMakerLoose {

  set InputArray JetEnergyScalePUPPI/jets
  set PhotonOutputArray photons
  set MuonOutputArray muons
  set ElectronOutputArray electrons
  set JetOutputArray jets

  set EfficiencyFormula {
      11 0.02
      13 0.02
      22 0.10 }

}


#################################
# Jet Fake Particle Maker Medium #
#################################

module JetFakeParticle JetFakeMakerMedium {

  set InputArray JetEnergyScalePUPPI/jets
  set PhotonOutputArray photons
  set MuonOutputArray muons
  set ElectronOutputArray electrons
  set JetOutputArray jets

  set EfficiencyFormula {
      11 0.01
      13 0.01
      22 0.05 }

}

#################################
# Jet Fake Particle Maker Tight #
#################################

module JetFakeParticle JetFakeMakerTight {

  set InputArray JetEnergyScalePUPPI/jets
  set PhotonOutputArray photons
  set MuonOutputArray muons
  set ElectronOutputArray electrons
  set JetOutputArray jets

  set EfficiencyFormula {
      11 0.005
      13 0.005
      22 0.025 }

}


############################
# Photon fake merger loose
############################

module Merger PhotonFakeMergerLoose {
# add InputArray InputArray
  add InputArray PhotonLooseID/photons
  add InputArray JetFakeMakerLoose/photons
  set OutputArray photons
}

############################
# Photon fake merger medium
############################

module Merger PhotonFakeMergerMedium {
# add InputArray InputArray
  add InputArray PhotonMediumID/photons
  add InputArray JetFakeMakerMedium/photons
  set OutputArray photons
}

############################
# Photon fake merger tight
############################

module Merger PhotonFakeMergerTight {
# add InputArray InputArray
  add InputArray PhotonTightID/photons
  add InputArray JetFakeMakerTight/photons
  set OutputArray photons
}

############################
# Electron fake merger loose
############################

module Merger ElectronFakeMergerLoose {
# add InputArray InputArray
  add InputArray ElectronLooseEfficiency/electrons
  add InputArray JetFakeMakerLoose/electrons
  set OutputArray electrons
}

############################
# Electron fake merger medium
############################

module Merger ElectronFakeMergerMedium {
# add InputArray InputArray
  add InputArray ElectronMediumEfficiency/electrons
  add InputArray JetFakeMakerMedium/electrons
  set OutputArray electrons
}

############################
# Electron fake merger tight
############################

module Merger ElectronFakeMergerTight {
# add InputArray InputArray
  add InputArray ElectronTightEfficiency/electrons
  add InputArray JetFakeMakerTight/electrons
  set OutputArray electrons
}


############################
# Muon fake merger loose
############################

module Merger MuonFakeMergerLoose {
# add InputArray InputArray
  add InputArray MuonLooseIdEfficiency/muons
  add InputArray JetFakeMakerLoose/muons
  set OutputArray muons
}

############################
# Muon fake merger medium
############################

module Merger MuonFakeMergerMedium {
# add InputArray InputArray
  add InputArray MuonMediumIdEfficiency/muons
  add InputArray JetFakeMakerMedium/muons
  set OutputArray muons
}

############################
# Muon fake merger tight
############################

module Merger MuonFakeMergerTight {
# add InputArray InputArray
  add InputArray MuonMediumIdEfficiency/muons
  add InputArray JetFakeMakerTight/muons
  set OutputArray muons
}




###############################################################################################################
# StatusPidFilter: this module removes all generated particles except electrons, muons, taus, and status == 3 #
###############################################################################################################

module StatusPidFilter GenParticleFilter {

    set InputArray Delphes/allParticles
    set OutputArray filteredParticles
    set PTMin 0.0

}


####################
# ROOT tree writer
####################

module TreeWriter TreeWriter {

# add Branch InputArray BranchName BranchClass
  #add Branch GenParticleFilter/filteredParticles Particle GenParticle
  add Branch Delphes/allParticles Particle GenParticle
  add Branch PileUpMerger/vertices Vertex Vertex

  add Branch GenJetFinder/jets GenJet Jet
  add Branch GenJetFinderAK8/jetsAK8 GenJetAK8 Jet
  add Branch GenMissingET/momentum GenMissingET MissingET

#  add Branch HCal/eflowTracks EFlowTrack Track
#  add Branch ECal/eflowPhotons EFlowPhoton Tower
#  add Branch HCal/eflowNeutralHadrons EFlowNeutralHadron Tower

  add Branch RunPUPPI/PuppiParticles ParticleFlowCandidate ParticleFlowCandidate
  add Branch EFlowMergerCHS/eflow ParticleFlowCandidateCHS ParticleFlowCandidate

  add Branch PhotonIsolation/photons Photon Photon
  add Branch PhotonFakeMergerLoose/photons PhotonLoose Photon
  add Branch PhotonFakeMergerMedium/photons PhotonMedium Photon
  add Branch PhotonFakeMergerTight/photons PhotonTight Photon

  add Branch ElectronIsolation/electrons Electron Electron
  add Branch ElectronFakeMergerLoose/electrons ElectronLoose Electron
  add Branch ElectronFakeMergerMedium/electrons ElectronMedium Electron
  add Branch ElectronFakeMergerTight/electrons ElectronTight Electron

  add Branch MuonIsolation/muons Muon Muon
  add Branch MuonFakeMergerLoose/muons MuonLoose Muon
  add Branch MuonFakeMergerMedium/muons MuonMedium Muon
  add Branch MuonFakeMergerTight/muons MuonTight Muon

  add Branch JetEnergyScale/jets Jet Jet
  add Branch JetEnergyScalePUPPI/jets JetPUPPI Jet
  add Branch JetEnergyScaleAK8/jets JetAK8 Jet
  add Branch JetEnergyScalePUPPIAK8/jets JetPUPPIAK8 Jet

  add Branch Rho/rho Rho Rho

  add Branch MissingET/momentum MissingET MissingET
  add Branch PuppiMissingET/momentum PuppiMissingET MissingET
  add Branch GenPileUpMissingET/momentum GenPileUpMissingET MissingET
  add Branch ScalarHT/energy ScalarHT ScalarHT

}