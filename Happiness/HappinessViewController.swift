//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Saurabh Sikka on 02/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {

    
    private struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
           // faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "changeHappiness:"))
            // WE'RE GOING TO DO THIS IN THE STORYBOARD!!
        }
    }
    
    
    // Model for Happiness
    var happiness: Int = 70 {
        // 0 is depressed, 100 is ecstatic
        didSet {
            happiness = min(max(happiness, 0), 100)
            // print("Happiness = \(happiness)")
            updateUI()
        }
    }
    
    func updateUI() {
        faceView.setNeedsDisplay()
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
}
