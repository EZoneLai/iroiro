//
//  Line.swift
//  iroiro
//
//  Created by EZoneLai Lai on 2017/7/29.
//  Copyright © 2017年 EZoneLai Lai. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    var fill_or_not:Bool = false
    var drawArea:CGRect!
    var lineColor:UIColor!
    
    init(drawArea: CGRect, frame: CGRect, lineColor:UIColor, fill_or_not:Bool = false) {
        super.init(frame: frame)
        self.drawArea = drawArea
        self.lineColor = lineColor
        self.fill_or_not = fill_or_not
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.move(to: drawArea.origin)
        
        aPath.addLine(to: CGPoint(x:drawArea.origin.x + drawArea.size.width,
                                  y:drawArea.origin.y))
        
        aPath.addLine(to: CGPoint(x:drawArea.origin.x + drawArea.size.width,
                                  y:drawArea.origin.y + drawArea.size.height))
        
        aPath.addLine(to: CGPoint(x:drawArea.origin.x,
                                  y:drawArea.origin.y + drawArea.size.height))
        
        aPath.addLine(to: CGPoint(x:drawArea.origin.x,
                                  y:drawArea.origin.y))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        
        //If you want to stroke it with a  color
        //self.layer.borderColor = (self.lineColor as! CGColor)
        //UIColor.red.set()
        self.lineColor.set()
        
        aPath.stroke()
        //If you want to fill it as well
        if self.fill_or_not{
            aPath.fill()
        }
        
    }
}
