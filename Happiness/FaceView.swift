//
//  FaceView.swift
//  Happiness
//
//  Created by Saurabh Sikka on 02/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class {  // protocol only works with classes, not enums or structs
    func smilinessForFaceView(sender: FaceView) -> Double?
}

@IBDesignable // to render it in storyboard

class FaceView: UIView {
    
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() }}
    var color = UIColor.blackColor() { didSet { setNeedsDisplay() }}
    var faceFillColor = UIColor.yellowColor() { didSet { setNeedsDisplay() }}
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() }}
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    
    weak var dataSource: FaceViewDataSource?
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left:
            eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right:
            eyeCenter.x += eyeHorizontalSeparation / 2
        }
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForMouth(fractionOfMaxSmile: Double) -> UIBezierPath {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Draw the face
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        faceFillColor.setFill() // fill the face with yellow color
        facePath.fill()
        
        // Draw the eyes
        let leftEyePath = bezierPathForEye(.Left)
        let rightEyePath = bezierPathForEye(.Right)
        
        color.setFill() // set the eye color
        leftEyePath.stroke()
        rightEyePath.stroke()
        // make the eyes black
        leftEyePath.fill()        
        rightEyePath.fill()
        
        // Draw the smile
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForMouth(smiliness)
        smilePath.stroke()
        
    }
    

}
