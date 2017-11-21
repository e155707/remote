//
//  JudgeController.swift
//  ARuke
//
//  Created by e155707 on 2017/11/20.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class JudgeController: UIViewController, ARSCNViewDelegate{
    @IBOutlet weak var JudgeDescriptionLabel: UILabel!
    @IBOutlet weak var enemyCharacterDisplay: SCNView!
    
    let characterEnemy:ManageEnemyCharacter = ManageEnemyCharacter()
    var characterEnemyScene:SCNScene = SCNScene()
    
    var errorDistance: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        characterEnemyScene = characterEnemy.managerCamera()
        
        characterEnemy.initEnemy()
        
        characterEnemy.managerEnemyCharacter(characterEnemyScene)
        enemyCharacterDisplay.scene = characterEnemyScene
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.fromJudgeToMap))
        
        JudgeDescriptionLabel.isUserInteractionEnabled = true
        JudgeDescriptionLabel.addGestureRecognizer(gesture)
        
        JudgeDescriptionLabel.text = "チェックポイント　との　ごさ　\(String(format:"%.1f", errorDistance))m...\n\nタローマルは　こうげきは　クリティカルヒット　5820ダメージを　あたえた！！"
        JudgeDescriptionLabel.numberOfLines = 0
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
