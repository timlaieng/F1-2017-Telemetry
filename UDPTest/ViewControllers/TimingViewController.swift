//
//  TimingViewController.swift
//  UDPTest
//
//  Created by Tim Lai on 17/06/2018.
//  Copyright © 2018 DigitalFactor. All rights reserved.
//

import Foundation
import UIKit

class TimingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var timingTableView: UITableView!
    
    
    //Different table logic for sessions
    //Practice, Qualifying(Q1, Q2, Q3), Race
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "driverTimingCell") as! TimingTableViewCell
        
        cell.positionLabel.text = "P" + "1"
        cell.carNumberLabel.text = "44"
        cell.driverNameLabel.text = "Tim Lai"
        cell.tyreCompoundLabel.text = "SS"
        cell.lapTimeLabel.text = "1:18.123"
        cell.gapTimeLabel.text = "6.4"
        cell.sectorOneTimeLabel.text = "24.657"
        cell.sectorTwoTimeLabel.text = "30.456"
        cell.sectorThreeTimeLabel.text = "32.567"
        
        return cell
    }
    
    override func viewDidLoad() {
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
