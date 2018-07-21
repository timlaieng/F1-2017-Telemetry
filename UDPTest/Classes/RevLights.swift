//
//  RevLights.swift
//  UDPTest
//
//  Created by Tim Lai on 15/06/2018.
//  Copyright © 2018 DigitalFactor. All rights reserved.
//

import Foundation
import UIKit
//import CoreGraphics

class LED: UIView {

    let onColor:UIColor
    let offColor:UIColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    var isActivated:Bool = false
    
        init(frame: CGRect, lineWidth:CGFloat, color: UIColor) {
            self.onColor = color
            super.init(frame: frame)
            self.drawCircle(radius: frame.size.height/2, lineWidth: lineWidth)
            self.backgroundColor = self.offColor
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
    
    func drawCircle(radius: CGFloat, lineWidth: CGFloat) {
            let center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0);
            
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.beginPath()
            
            context.setLineWidth(lineWidth)
            
            let x:CGFloat = center.x
            let y:CGFloat = center.y
            let endAngle: CGFloat = CGFloat(2 * Double.pi)
            
            context.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
            context.strokePath()
        }
    
    func switchOnLED(){
        if self.isActivated == false {
            self.backgroundColor = self.onColor
            self.isActivated = true
        }
    }
    
    func switchOffLED(){
        if self.isActivated == true {
            self.backgroundColor = self.offColor
            self.isActivated = false
        }
    }
    
}






class RevLights: UIStackView {
    let ledsize = CGRect(x: 0.0, y: 0.0, width: 6.0, height: 6.0)
    var numberOfLightsOn: Int = 15
    
    
    //TODO: switch percentage of LEDS based on RPMs
    
    let ledLimits:[Float] = [0.790,  //1
                     0.795,  //2
                     0.800,  //3
                     0.805,  //4
                     0.810,  //5
                     0.815,  //6
                     0.820,  //7
                     0.825,  //8
                     0.830,  //9
                     0.835,  //10
                     0.840,  //11
                     0.845,  //12
                     0.850,  //13
                     0.855,  //14
                     0.860]  //15
    
    
    func ledsOnFromRPM(percentageOfMaxRPM rpm:Float){
    // read percentage of rpm to its max
        let totalLights = self.arrangedSubviews.count
        switch rpm {
            
            case ledLimits[0] ..< ledLimits[1] : self.numberOfLightsOn = 1     //1 green
            case ledLimits[1] ..< ledLimits[2] : self.numberOfLightsOn = 2     //2 green
            case ledLimits[2] ..< ledLimits[3] : self.numberOfLightsOn = 3     //3 green
            case ledLimits[3] ..< ledLimits[4] : self.numberOfLightsOn = 4     //4 green
            case ledLimits[4] ..< ledLimits[5] : self.numberOfLightsOn = 5     //5 green
            case ledLimits[5] ..< ledLimits[6] : self.numberOfLightsOn = 6     //6 red
            case ledLimits[6] ..< ledLimits[7] : self.numberOfLightsOn = 7     //7 red
            case ledLimits[7] ..< ledLimits[8] : self.numberOfLightsOn = 8     //8 red
            case ledLimits[8] ..< ledLimits[9] : self.numberOfLightsOn = 9     //9 red
            case ledLimits[9] ..< ledLimits[10] : self.numberOfLightsOn = 10     //10 red
            case ledLimits[10] ..< ledLimits[11] : self.numberOfLightsOn = 11    //11 blue
            case ledLimits[11] ..< ledLimits[12] : self.numberOfLightsOn = 12   //12 blue
            case ledLimits[12] ..< ledLimits[13] : self.numberOfLightsOn = 13  //13 blue
            case ledLimits[13] ..< ledLimits[14] : self.numberOfLightsOn = 14     //14 blue
            case ledLimits[14] ..< 10 : self.numberOfLightsOn = 15     //15 blue
            default: self.numberOfLightsOn = 0
        }
        
        
        
        
        for num in 0..<self.numberOfLightsOn {
            let led = self.arrangedSubviews[num] as! LED
            led.switchOnLED()
        }
        
        for num in numberOfLightsOn..<totalLights{
            let led = self.arrangedSubviews[num] as! LED
            led.switchOffLED()
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var leds:[LED] = []
        
        for led in 0..<15 {
            switch led {
            case 0..<5:
                leds.append(LED(frame: self.ledsize, lineWidth: 6.0, color: .green))
            case 5..<10:
                leds.append(LED(frame: self.ledsize, lineWidth: 6.0, color: .red))
            case 10..<15:
                leds.append(LED(frame: self.ledsize, lineWidth: 6.0, color: UIColor(red: 0.6, green: 0.6, blue: 1.0, alpha: 1.0)))
            default:
                leds.append(LED(frame: self.ledsize, lineWidth: 6.0, color: .green))
            }
        }
        
        leds.forEach{led in
            
            self.addArrangedSubview(led)
            led.switchOnLED()
        }
        
        self.axis = .horizontal
        self.spacing = 1.0
        self.distribution = .fillEqually
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    

}

