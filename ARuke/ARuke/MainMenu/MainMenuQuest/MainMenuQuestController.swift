//
//  MainMenuQuestController.swift
//  ARuke
//
//  Created by e155707 on 2017/11/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainMenuQuestController: UIViewController, ARSCNViewDelegate{
    @IBOutlet weak var characterLevelLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var userGoldLabel: UILabel!
    @IBOutlet weak var userFatLabel: UILabel!
    @IBOutlet weak var questDescriptionLabel: UILabel!
    
    let character:ManageCharacter = ManageCharacter()
    let user:ManageUserInformation = ManageUserInformation()
    var characterScene:SCNScene = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterLevelLabel.text = "Lv." + String(character.getCharacterLevel())
        characterNameLabel.text = character.getCharacterName()
        userGoldLabel.text = "所　持　金" + String(user.getUserGold()) + "G"
        userFatLabel.text = "シボウリツ" + String(user.getUserFat()) + "%"
        
        questDescriptionLabel.text = "レベルを　選ぶやで！！\nしんちょうに　選ぶやで！！"
        questDescriptionLabel.numberOfLines = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
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

