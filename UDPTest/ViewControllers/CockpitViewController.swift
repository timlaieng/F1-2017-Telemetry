//
//  ViewController.swift
//  UDPTest
//
//  Created by Danny Grob on 08/07/2017.
//  Copyright © 2017 DigitalFactor. All rights reserved.
//

import UIKit
import SwiftSocket
import CocoaAsyncSocket

class CockpitViewController: UIViewController, GCDAsyncUdpSocketDelegate {
    @IBOutlet weak var gearLabel: UILabel!
    @IBOutlet weak var rpmLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var drsLabel: UILabel!
    @IBOutlet weak var invalidLapLabel: UILabel!
    @IBOutlet weak var lapTimeLabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!

   
    
    
    var revlights: RevLights! = nil
    var carWorldPosition: CarWorldPosition?
    
    
    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        revlights = RevLights(frame: CGRect(x: 0.0, y: 10.0, width:self.view.frame.width, height: self.view.frame.width/20))
        self.view.addSubview(revlights!)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .top, relatedBy: .equal, toItem: revlights, attribute: .top, multiplier: 1.0, constant: 20.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: revlights, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: revlights, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.updateViewConstraints()
        
        
        if let ipAddress = self.getWiFiAddress() {
            print("IP address:\(ipAddress)")
        }
        
        
        let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
    
        do {
            try socket.bind(toPort: 20777)
            try socket.enableBroadcast(true)
            try socket.beginReceiving()
            
        } catch _ as NSError { print("Issue with setting up listener") }
    
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
//        // …or old style through pointers:
        let packet = UDPPacket.init(data: data)
        
        
            self.hmsFrom(seconds: Int(packet.m_time!)) { (h, m, s) in
                
                let gear = Int(packet.m_gear!)
                switch gear {
                case 0:
                    self.gearLabel.text = "R"
                    break;
                case 1:
                    self.gearLabel.text = "N"
                    break;
                default:
                    self.gearLabel.text = "\(gear - 1)"
                    break;
                }
                
                self.rpmLabel.text = String(format: "%.f", packet.m_engineRate!)
                self.speedLabel.text = "\(floorf(packet.m_speed! * 3.6))"
                
                
                let revs = packet.m_engineRate! / packet.m_max_rpm!

                self.revlights.ledsOnFromRPM(percentageOfMaxRPM: revs)
                
                //print(packet.m_rev_lights_percent!.description)
//                self.carWorldPosition?.worldX = packet.m_x
//                self.carWorldPosition?.worldY = packet.m_y
//                self.carWorldPosition?.worldZ = packet.m_z
                
                
                self.testLabel.text = """
                Sector: \(packet.m_sector!.description)
                Sector 1: \(packet.m_sector1_time!.description)
                Sector 2:\(packet.m_sector2_time!.description)
                """
                
                if var time = packet.m_last_lap_time, let position = packet.m_car_position {
                    time -= 60
                    if time < 0 {
                            self.lapTimeLabel.text = "Lap: --.---, P\(position.description) "
                    } else{
                        self.lapTimeLabel.text = "Lap: \(String(format: "%.3f", time)), P\(String(format:"%.f",position))"
                    }
                }
               
                
                self.checkInvalidLap(lap: packet.m_currentLapInvalid!)
                
            if let drs = packet.m_drs {
                if (drs == 1) {
                    self.drsLabel.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
                } else if (packet.m_drsAllowed == 1){
                //self.drsLabel.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
                    self.drsLabel.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
                } else {
                    self.drsLabel.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
                }
            }
        }
        //print(data)
    }
    

    @IBAction func cockpitViewSwipeGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
    
        let swipeGesture = sender
        
        switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.performSegue(withIdentifier: "cockpitToTimingsSegue", sender: self)
            default:
                break
            }
        

    
    
    }
    
    
    
    
    func checkInvalidLap(lap:UInt8){
        let label = self.invalidLapLabel!
        label.isHidden = true
        
        if (lap == 1) {
            label.isHidden = false
        }
    }
    

    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
