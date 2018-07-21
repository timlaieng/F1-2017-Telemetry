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
    var displayedTrackNumber: Float? = nil
    var receivedTrackNumber: Float? = nil
    //var trackIsSet = false
    
    func didReceivePacket(packet: UDPPacket) {
        
        receivedTrackNumber = packet.m_track_number
        
        if let url = UDPPacket.trackFileNames[receivedTrackNumber!] {
            
            if displayedTrackNumber != receivedTrackNumber! {
                trackMapImageView.image =  UIImage(named:url)
                trackMapImageView.contentMode = .scaleAspectFit
                displayedTrackNumber = receivedTrackNumber!}
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UDPManager.shared.delegate = self

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
