//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Saurabh Sikka on 02/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
        }
    }
    
    
    // Model for Happiness
    var happiness: Int = 70 {
        // 0 is depressed, 100 is ecstatic
        didSet {
            happiness = min(max(happiness, 0), 100)
            print("Happiness = \(happiness)")
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
