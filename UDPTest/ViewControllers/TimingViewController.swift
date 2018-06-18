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
    var timer = Timer()
    let refreshRate:Double = 1.000 // time in seconds. Must be of Double type.
    
    @IBOutlet weak var timingTableView: UITableView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UDPManager.shared.delegate = self
        scheduledTimerWithTimeInterval()
    }
    
    //Different table logic for sessions
    //Practice, Qualifying(Q1, Q2, Q3), Race
    
    func didReceivePacket(packet: UDPPacket) {
        cars = packet.m_car_data;
       // self.timingTableView.reloadData()
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
        
        guard let selectedCar = cars?[indexPath.row] else {return UITableViewCell()}
        
            if let sector1Time = selectedCar.m_sector1Time, let sector2Time = selectedCar.m_sector2Time, let lastLap = selectedCar.m_lastLapTime {
                
                //TODO: NEED TO STORE S1 AND S2 TIMES SOMEWHERE
                let sector3Time = lastLap - sector1Time - sector2Time // when lap time is set, sector 1 and 2 times are erased.
            
                
                
                if sector1Time <= 0 {
                    cell.sectorOneTimeLabel.text = " "
                } else {
                    cell.sectorOneTimeLabel.text = "\(sector1Time.description)"
                }
                
                if sector2Time <= 0 {
                    cell.sectorTwoTimeLabel.text = " "
                } else {
                    cell.sectorTwoTimeLabel.text = "\(sector2Time.description)"
                }
                
                if sector3Time <= 0 {
                    cell.sectorThreeTimeLabel.text = " "
                } else {
                    cell.sectorThreeTimeLabel.text = "\(sector3Time.description)"
                }
                
                cell.positionLabel.text = "P" + "\(selectedCar.m_carPosition!)"
                
                cell.driverNameLabel.text = "\(CarUDPData.modernNames[selectedCar.m_driverId!]!)"
                cell.tyreCompoundLabel.text = "\(CarUDPData.tyreCompounds[selectedCar.m_tyreCompound!]!)"
                cell.lapTimeLabel.text = "\(selectedCar.m_bestLapTime!.description)"
                cell.gapTimeLabel.text = "gap"
            
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
    
    @IBAction func TimingSwipeGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
        
        let swipeGesture = sender
        
        switch swipeGesture.direction {
        case .left:
            self.performSegue(withIdentifier: "timingsToCockpitViewSegue", sender: self)
        default:
            break
        }
    }
    
    
}
