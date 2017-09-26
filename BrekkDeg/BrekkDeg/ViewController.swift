//
//  ViewController.swift
//  BrekkDeg
//
//  Created by Kristoffer  Gjerde on 15.09.2017.
//  Copyright © 2017 Kristoffer Gjerde. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var head: UIImageView!
    var animator: UIDynamicAnimator?
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Initialiser animator
        animator = UIDynamicAnimator(referenceView: self.view)
        
        //Add gravity
        let gravity = UIGravityBehavior(items:[head!])
        let direction = CGVector.init(dx: 0.0, dy: 1.0)
        gravity.gravityDirection = direction
        
        //Colliison
        let boundries = UICollisionBehavior(items: [head])
        boundries.translatesReferenceBoundsIntoBoundary = true
        
        //Elasticity
        let bounce = UIDynamicItemBehavior(items: [head])
        bounce.elasticity = 1
        
        //Make head spin
        let spin = UIDynamicItemBehavior(items: [head])
        spin.allowsRotation = true
        
        
        //animator?.addBehavior(spin)
        //animator?.addBehavior(bounce)
        //animator?.addBehavior(boundries)
        //animator?.addBehavior(gravity)
        
        
    }
    
    
    
    func addGravity(image:UIImageView){
        //Initialiser animator
        animator = UIDynamicAnimator(referenceView: self.view)
        
        //Add gravity
        let gravity = UIGravityBehavior(items:[image])
        
        let x = Double(arc4random_uniform(5)+1)
        let y = Double(arc4random_uniform(5)+1)
        
        let direction = CGVector(dx: sin(x),dy: cos(y))
        
        gravity.gravityDirection = direction
        
        animator?.addBehavior(gravity)
        
    }
    
    
    //BrekkDeg
    var player: AVAudioPlayer?
    @IBAction func brekkDeg(_ sender: UIButton) {
        guard let sound = NSDataAsset(name: "play_cut") else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            
            player!.play()
            
            let imageview = UIImageView(image: UIImage(named:"Puke"))
            imageview.frame = CGRect(x: 27, y:70, width: 320, height: 320)
            view.addSubview(imageview)
            addGravity(image: imageview)
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }


}

