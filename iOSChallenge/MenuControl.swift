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
        
        drawCircle(circleRect)
        
        drawText(circleRect)
        
        drawArcs(bounds)
        
        drawSelectedArc(bounds)
    }
    
    func drawSelectedArc(contextRect: CGRect) {
        layer.sublayers = nil
        
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
            
            path.lineWidth = arcWidth
            unselectedArcColor.setStroke()
            path.stroke()
        }
    }
    
    func drawCircle(contextRect: CGRect) {
        let path = UIBezierPath(ovalInRect: contextRect)
        circleColor.setFill()
        path.fill()
    }
    
    func drawText(contextRect: CGRect) {
        optionText = menuChoices[selectedIndex]
        let font = UIFont(name: "HelveticaNeue", size: 14)!
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.Center
        textStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        let textFontAttributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: textStyle, NSForegroundColorAttributeName: optionTextColor]
        
        let size = optionText.sizeWithAttributes(textFontAttributes)
        let textRect = CGRectMake(contextRect.origin.x,
            contextRect.origin.y + CGFloat(floorf(Float((contextRect.height - size.height) / 2))),
            contextRect.width,
            size.height)
        
        optionText.drawInRect(textRect, withAttributes: textFontAttributes)
    }
}
