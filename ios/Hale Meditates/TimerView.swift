//
//  TimerView.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/28/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.opaque = false;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.opaque = false;
    }
    
    
    var circleCenter: CGPoint {
        return convertPoint(center, fromView: superview);
    }
    
    var circleRadius: CGFloat {
        return (min(bounds.size.width, bounds.size.height) / 2) - lineWidth / 2.0 - 1
    }
    
    var lineWidth: CGFloat = 14.0
    var outerColor: UIColor = UIColor.whiteColor()
    var innerColor: UIColor = UIUtil.secondaryColor;
    var progress: Float = 0.0 {
        didSet {
            setNeedsDisplay();
        }
    }; // number between 0 and 1
    
    var progressInRadians: Float {
        return self.progress * Float(M_PI) * 2 - Float(M_PI_2)
    }

    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        let outerCirclePath : UIBezierPath = UIBezierPath(arcCenter: self.circleCenter, radius:
            circleRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        outerColor.setStroke();
        outerCirclePath.lineWidth = lineWidth;
        outerCirclePath.stroke()
        
        if (progress > 0) {
            let innerCirclePath : UIBezierPath = UIBezierPath(arcCenter: self.circleCenter, radius:
                circleRadius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(progressInRadians), clockwise: true)
            
            innerColor.setStroke();
            innerCirclePath.lineWidth = lineWidth;
            innerCirclePath.stroke()
        }
        
    }

}
