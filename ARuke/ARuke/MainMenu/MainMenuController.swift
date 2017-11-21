//
//  MainMenuController.swift
//  ARuke
//
//  Created by e155707 on 2017/11/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainMenuController: UIViewController, ARSCNViewDelegate{
    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var QuestView: UIView!
    var containers: Array<UIView> = []
 
    @IBOutlet weak var mainMenuSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containers = [HomeView,QuestView]
        mainMenuView.bringSubview(toFront: HomeView)
        
        let font:UIFont! = UIFont(name:"yurumoji",size:60)
        mainMenuSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func selectMainMen(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            mainMenuView.bringSubview(toFront: HomeView)
        case 1:
            mainMenuView.bringSubview(toFront: QuestView)
        case 2:
            print("ショップ")
        case 3:
            print("カスタム")
        default:
            print("")
        }
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


