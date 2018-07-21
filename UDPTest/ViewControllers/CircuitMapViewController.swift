//
//  CircuitMapViewController.swift
//  UDPTest
//
//  Created by Tim Lai on 21/07/2018.
//  Copyright © 2018 DigitalFactor. All rights reserved.
//

import UIKit

class CircuitMapViewController: UIViewController, UDPManagerDelegate {
    
    @IBOutlet weak var trackMapImageView: UIImageView!
    var trackIsSet = false
    
    
    
    
    func didReceivePacket(packet: UDPPacket) {
        
        if !trackIsSet, let track = packet.m_track_number, let url = UDPPacket.trackFileNames[track] {
            trackMapImageView.image =  UIImage(named:url)
        trackIsSet = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UDPManager.shared.delegate = self
        //trackMapImageView.image =

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
