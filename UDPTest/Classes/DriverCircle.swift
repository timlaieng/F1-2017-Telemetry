//
//  driverCircle.swift
//  UDPTest
//
//  Created by Tim Lai on 14/06/2018.
//  Copyright © 2018 DigitalFactor. All rights reserved.
//

import Foundation
import UIKit

struct CarWorldPosition {
    var worldX: Float?
    var worldY: Float?
    var worldZ: Float?
}

class DriverCircle:UIView
{
    override func draw(_ rect: CGRect)
    {
        
        drawRingFittingInsideView()

    }
    
    internal func drawRingFittingInsideView()->()
    {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1    // your desired value
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.green as! CGColor
        shapeLayer.strokeColor = UIColor.red as! CGColor
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    }
}
