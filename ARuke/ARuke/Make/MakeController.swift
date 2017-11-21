//
//  MakeController.swift
//  ARuke
//
//  Created by e155707 on 2017/11/14.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MakeController: UIViewController, ARSCNViewDelegate, UITextFieldDelegate{
    @IBOutlet weak var characterMakeSceneView: SCNView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var colorSelectSegmentedControl: UISegmentedControl!
    @IBOutlet weak var genderSelectSegmentedControl: UISegmentedControl!
    
    let Object:ManageCharacterObject = ManageCharacterObject()
    let characterInformation:ManageCharacterInformation = ManageCharacterInformation()
    var characterMakeScene:SCNScene = SCNScene()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //カメラのオブジェクトを生成
        characterMakeScene = Object.managerCamera()
        
        //赤い宝箱を表示
        let Node = Object.initObeject()
        characterMakeScene.rootNode.addChildNode(Node)
        
        characterMakeSceneView.scene = characterMakeScene
        
        nameText.delegate = self
        
        let font:UIFont! = UIFont(name:"yurumoji",size:75)
        colorSelectSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],for: .normal)
        genderSelectSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        characterInformation.setName(textField.text!)
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func selectColor(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            Object.managerObjectRedTresure(characterMakeScene)
        case 1:
            Object.managerObjectGreenTresure(characterMakeScene)
        default:
            print("")
            print(characterMakeScene)
        }
        
        characterMakeSceneView.scene = characterMakeScene
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
