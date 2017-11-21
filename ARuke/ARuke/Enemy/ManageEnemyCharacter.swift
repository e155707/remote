//
//  ManageEnemyCharacter.swift
//  ARuke
//
//  Created by e155707 on 2017/11/20.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ManageEnemyCharacter{
    let defaults = UserDefaults.standard
    
    var enemyGender:String = String()
    var enemyColor:String = String()
    var enemyName:String = String()
    var enemyObejectName:String = String()
    var enemyLevel:Int = Int()
    var enemyHP:Int = Int()
    
    let characterEnemyScene:SCNScene = SCNScene()
    
    func managerCamera() -> SCNScene{
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        
        cameraNode.position = SCNVector3(x:0, y:1, z:5)
        characterEnemyScene.rootNode.addChildNode(cameraNode)
        
        return characterEnemyScene
    }
    
    func initEnemy(){
        enemyGender = "♂"
        enemyColor = "brown"
        enemyName = "宝箱"
        enemyObejectName = "takarabako"
        enemyHP = 10000
        
        defaults.set(enemyGender,forKey:"enemyGender")
        defaults.set(enemyColor,forKey:"enemyColor")
        defaults.set(enemyName,forKey:"enemyName")
        defaults.set(enemyObejectName,forKey:"enemyObejectName")
        defaults.set(enemyHP,forKey:"enemyHP")
    }
    
    
    func managerEnemyCharacter(_ characterEnemyScene:SCNScene){
        enemyGender = defaults.string(forKey: "enemyGender")!
        enemyColor = defaults.string(forKey: "enemyColor")!
        enemyName = defaults.string(forKey: "enemyName")!
        enemyObejectName = defaults.string(forKey: "enemyObejectName")!
        
        let scene = SCNScene(named: "art.scnassets/tresure/"+enemyObejectName+".dae")!
        
        guard
            let Node = scene.rootNode.childNode(withName: enemyObejectName, recursively: true)
            else{return}
        
        Node.scale = SCNVector3(0.08, 0.08, 0.08)
        Node.name = enemyObejectName
        characterEnemyScene.rootNode.addChildNode(Node)
        print(Node)
    }
    
    func getCharacterName() -> String{
        enemyName = defaults.string(forKey: "enemyName")!
        return enemyName
    }
    
    func getEnemyCharacterHP() -> Int{
        enemyHP = defaults.integer(forKey: "enemyHP")
        return enemyHP
    }
}


