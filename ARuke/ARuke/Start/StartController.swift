//
//  Start.swift
//  ARuke
//
//  Created by e155707 on 2017/11/20.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class StartController: UIViewController, ARSCNViewDelegate{
    @IBOutlet weak var startDescriptionLabel: UILabel!
    @IBOutlet weak var enemyCharacterDisplay: SCNView!
    @IBOutlet weak var enemyHPProgress: UIProgressView!
    @IBOutlet weak var HPProgress: UIProgressView!
    
    let characterEnemy:ManageEnemyCharacter = ManageEnemyCharacter()
    var characterEnemyScene:SCNScene = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        characterEnemyScene = characterEnemy.managerCamera()
        
        characterEnemy.initEnemy()
        
        characterEnemy.managerEnemyCharacter(characterEnemyScene)
        enemyCharacterDisplay.scene = characterEnemyScene
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.fromStartToMap))
        
        startDescriptionLabel.isUserInteractionEnabled = true
        startDescriptionLabel.addGestureRecognizer(gesture)
        
        enemyHPProgress.progress = 1.0
        HPProgress.progress = 1.0
        
        startDescriptionLabel.text = "ドラゴン　が　あらわれたやで！！\nチェックポイントで　こうげきできるやで！！"
        startDescriptionLabel.numberOfLines = 0
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


