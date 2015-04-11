//
//  MenuControl.swift
//  iOSChallenge
//
//  Created by Ziyang Tan on 4/10/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)

@IBDesignable class MenuControl: UIControl {
    
    @IBInspectable var optionText: NSString = ""
    @IBInspectable var optionTextColor: UIColor = UIColor.whiteColor()
    @IBInspectable var circleColor: UIColor = UIColor.colorWithRGBHex(0xB9A4A0, alpha: 0.5)
    @IBInspectable var unselectedArcColor: UIColor = UIColor.colorWithRGBHex(0x70001F, alpha: 1.0)
    @IBInspectable var selectedArcColor: UIColor = UIColor.colorWithRGBHex(0xFF003F, alpha: 1.0)
    @IBInspectable var spaceBetweenCircleAndArc: CGFloat = 5.0
    @IBInspectable var spaceBetweenArcs: CGFloat = 10.0
    var menuChoices = [String]()
    var selectedIndex = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        controlSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        controlSetup()
    }
    
    func controlSetup() {
        self.addTarget(self, action: "menuPressed:", forControlEvents: .TouchUpInside)
    }
    
    func menuPressed(sender: AnyObject) {
        selectedIndex = (selectedIndex == (menuChoices.count - 1)) ? 0 : selectedIndex + 1
        setNeedsDisplay()
    }
    
    func randomizeChoices() {
        selectedIndex = Int(arc4random_uniform(UInt32(menuChoices.count)))
        setNeedsDisplay()        
    }
    
    override func drawRect(rect: CGRect) {

        let circleRect = CGRectInset(rect, spaceBetweenCircleAndArc, spaceBetweenCircleAndArc)
        
        removeSublayers()
        
        drawCircle(circleRect)
        
        drawText(circleRect)
        
        drawArcs(bounds)
        
        drawSelectedArc(bounds)
    }
    
    func removeSublayers() {
        if layer.sublayers != nil {
            for subLayer in layer.sublayers {
                subLayer.removeFromSuperlayer()
            }
        }
    }
    
    func drawSelectedArc(contextRect: CGRect) {
        
        let degreeDiff: CGFloat = 2 * π / 360 * (spaceBetweenArcs / 2)
        let arcLength: CGFloat = 2 * π / CGFloat(menuChoices.count)
        
        let center = CGPoint(x: contextRect.width/2, y: contextRect.height/2)
        let arcWidth: CGFloat = 1
        
        let path = UIBezierPath(arcCenter: center,
            radius: contextRect.width/2 - arcWidth/2,
            startAngle: ((arcLength * CGFloat(selectedIndex) + degreeDiff) + π / 2),
            endAngle: ((arcLength * CGFloat(selectedIndex + 1) - degreeDiff) + π / 2),
            clockwise: true)
        
        let progressLine = CAShapeLayer()
        progressLine.name = "selected"
        progressLine.path = path.CGPath
        progressLine.strokeColor = selectedArcColor.CGColor
        progressLine.fillColor = UIColor.clearColor().CGColor
        progressLine.lineWidth = arcWidth
        layer.addSublayer(progressLine)
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 1.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        animateStrokeEnd.removedOnCompletion = true
        
        progressLine.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
    }
    
    func drawArcs(contextRect: CGRect) {
        let degreeDiff: CGFloat = 2 * π / 360 * (spaceBetweenArcs / 2)
        let arcLength: CGFloat = 2 * π / CGFloat(menuChoices.count)
        
        let center = CGPoint(x: contextRect.width/2, y: contextRect.height/2)
        let arcWidth: CGFloat = 1
        
        for index in 0..<menuChoices.count {
            let path = UIBezierPath(arcCenter: center,
                radius: contextRect.width/2 - arcWidth/2,
                startAngle: ((arcLength * CGFloat(index) + degreeDiff) + π / 2),
                endAngle: ((arcLength * CGFloat(index + 1) - degreeDiff) + π / 2),
                clockwise: true)
            
            let arcLine = CAShapeLayer()
            arcLine.name = "arc\(index)"
            arcLine.path = path.CGPath
            arcLine.strokeColor = unselectedArcColor.CGColor
            arcLine.fillColor = UIColor.clearColor().CGColor
            arcLine.lineWidth = arcWidth
            layer.addSublayer(arcLine)
        }
    }
    
    func drawCircle(contextRect: CGRect) {
        let path = UIBezierPath(ovalInRect: contextRect)
        
        let circle = CAShapeLayer()
        circle.name = "circle"
        circle.path = path.CGPath
        circle.strokeColor = UIColor.clearColor().CGColor
        circle.fillColor = circleColor.CGColor
        layer.addSublayer(circle)
        
        let animateFillColor = CABasicAnimation(keyPath: "fillColor")
        animateFillColor.duration = 1.0
        animateFillColor.fromValue = UIColor.grayColor().CGColor
        animateFillColor.toValue = circleColor.CGColor
        animateFillColor.removedOnCompletion = true
        
        circle.addAnimation(animateFillColor, forKey: "circle end animation")

    }
    
    func drawText(contextRect: CGRect) {
        optionText = menuChoices[selectedIndex]
        let fontSize:CGFloat = 14
        let font = UIFont(name: "HelveticaNeue", size: fontSize)!
        let textRect = CGRectMake(contextRect.origin.x,
            contextRect.origin.y + CGFloat(floorf(Float((contextRect.height - fontSize) / 2))),
            contextRect.width,
            contextRect.height)
        
        let textLayer = CATextLayer()
        textLayer.frame = textRect
        textLayer.name = "text"
        textLayer.string = optionText
        textLayer.font = font
        textLayer.fontSize = fontSize
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.truncationMode = kCATruncationEnd
        textLayer.foregroundColor = optionTextColor.CGColor
        layer.addSublayer(textLayer)
    }
}
