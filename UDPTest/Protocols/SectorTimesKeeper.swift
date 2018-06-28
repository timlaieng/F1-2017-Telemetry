//
//  SectorTimesKeeper.swift
//  UDPTest
//
//  Created by Tim Lai on 29/06/2018.
//  Copyright © 2018 DigitalFactor. All rights reserved.
//

protocol SectorTimesKeeper: class{
    
    var driverFastestSectorOneTimes:[Float] {get set}
    var driverFastestSectorTwoTimes:[Float] {get set}
    var driverFastestSectorThreeTimes:[Float] {get set}
    var sessionFastestSectorOneTime:Float {get set}
    var sessionFastestSectorTwoTime:Float {get set}
    var sessionFastestSectorThreeTime:Float {get set}
    
    func updateFastestSectors()
    func resetFastestSectors()
}
