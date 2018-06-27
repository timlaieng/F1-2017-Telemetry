//
//  TimingViewController.swift
//  UDPTest
//
//  Created by Tim Lai on 17/06/2018.
//  Copyright © 2018 DigitalFactor. All rights reserved.
//

import Foundation
import UIKit

class TimingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UDPManagerDelegate {

    var cars: [CarUDPData]?
    var carsLogger: [[CarUDPData]?]?
    var indexOfPacket: Int = 0
    var timer = Timer()
    let refreshRate:Double = 0.250 // time in seconds. Must be of Double type.
    
    @IBOutlet weak var timingTableView: UITableView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UDPManager.shared.delegate = self
        scheduledTimerWithTimeInterval()
    }
    
    //Different table logic for sessions
    //Practice, Qualifying(Q1, Q2, Q3), Race
    
    func didReceivePacket(packet: UDPPacket) {
        cars = packet.m_car_data
        carsLogger?.append(cars); indexOfPacket += 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let number = cars?.count {
            return number
        } else {return 1}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "driverTimingCell") as! TimingTableViewCell
        
        guard let carsInSession = cars else {return UITableViewCell()}
 
            let sortedCars = carsInSession.sorted{$0.m_carPosition! < $1.m_carPosition!}
            let selectedCar = sortedCars[indexPath.row]
        
            if indexPath.row != 0 {
                let previousCar = sortedCars[indexPath.row - 1]
                    if selectedCar.m_carPosition == 1 {
                        cell.gapTimeLabel.text = "---"
                    } else {
                        let gap = previousCar.m_currentLapTime! - selectedCar.m_currentLapTime!
                        cell.gapTimeLabel.text = "\(String(format:"%.3f", gap))"}
                }
        
            if let sector1Time = selectedCar.m_sector1Time, let sector2Time = selectedCar.m_sector2Time, let lastLap = selectedCar.m_lastLapTime {
                
                //TODO: NEED TO STORE S1 AND S2 TIMES SOMEWHERE
                let sector3Time = lastLap - sector1Time - sector2Time // when lap time is set, sector 1 and 2 times are erased.

                if sector1Time <= 0 {
                    cell.sectorOneTimeLabel.text = " "
                } else {
                    cell.sectorOneTimeLabel.text = "\(String(format:"%.3f",sector1Time))"
                }
                
                if sector2Time <= 0 {
                    cell.sectorTwoTimeLabel.text = " "
                } else {
                    cell.sectorTwoTimeLabel.text = "\(String(format:"%.3f",sector2Time))"
                }
                
                if sector3Time <= 0 {
                    cell.sectorThreeTimeLabel.text = " "
                } else {
                    cell.sectorThreeTimeLabel.text = "\(String(format:"%.3f",sector3Time))"
                }
                
                cell.positionLabel.text = "P" + "\(selectedCar.m_carPosition!)"
                
                cell.driverNameLabel.text = "\(CarUDPData.modernLastNames[selectedCar.m_driverId!]!)"
                cell.tyreCompoundLabel.text = "\(CarUDPData.tyreCompounds[selectedCar.m_tyreCompound!]!)"
                cell.lapTimeLabel.text = "\(String(format:"%.3f",selectedCar.m_bestLapTime!))"
                
            
            } else {
                cell.sectorOneTimeLabel.text = "-:--.---"
                cell.sectorTwoTimeLabel.text = "-:--.---"
                cell.sectorThreeTimeLabel.text = "-:--.---"
                
                cell.positionLabel.text = "P?"
                cell.driverNameLabel.text = "LastName"
                cell.tyreCompoundLabel.text = "tyre"
                cell.lapTimeLabel.text =  "-:--.---"
                cell.gapTimeLabel.text = "gap"
            }
        

        return cell
    }
    
    override func viewDidLoad() {
        self.timingTableView.dataSource = self
        self.timingTableView.delegate = self
    }
    
    @objc func updateTable(){
        self.timingTableView.reloadData()
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: refreshRate, target: self, selector: #selector(updateTable), userInfo: nil, repeats: true)
    }
    
    
    
    
}
