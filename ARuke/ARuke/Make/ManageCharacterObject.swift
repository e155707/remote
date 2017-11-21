//
//  CharacterObjectManager.swift
//  ARuke
//
//  Created by e155707 on 2017/11/14.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//
import UIKit
import SceneKit
import ARKit

class ManageCharacterObject{
    
    let characterInformation:ManageCharacterInformation = ManageCharacterInformation()
    let characterMakeScene:SCNScene = SCNScene()
    var nowObjectNode:SCNNode = SCNNode()
    
    func managerCamera() -> SCNScene{
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        
        cameraNode.position = SCNVector3(x:0, y:1, z:5)
        characterMakeScene.rootNode.addChildNode(cameraNode)
        
        return characterMakeScene
    }
    
    func initObeject() -> SCNNode{
        characterInformation.initCharacterInformation()
        
        let scene = SCNScene(named: "art.scnassets/tresure/treasureboxRED.dae")!
        
        nowObjectNode = scene.rootNode.childNode(withName: "treasureboxRED", recursively: true)!
        
        nowObjectNode.scale = SCNVector3(0.1, 0.1, 0.1)
        nowObjectNode.name = "treasureboxRED"
        
        return nowObjectNode
    }
    
    func managerObjectRedTresure(_ characterMakeScene:SCNScene){
        
        let scene = SCNScene(named: "art.scnassets/tresure/treasureboxRED.dae")!
        
        guard
            let Node = scene.rootNode.childNode(withName: "treasureboxRED", recursively: true)
            else{return}
        
        Node.scale = SCNVector3(0.1, 0.1, 0.1)
        Node.name = "treasureboxRED"
        characterMakeScene.rootNode.replaceChildNode(nowObjectNode, with: Node)
        nowObjectNode = Node
        
        //赤い宝箱の登録
        characterInformation.setObejectName(Node.name!)
    }
    
    func managerObjectGreenTresure(_ characterMakeScene:SCNScene){
        
        let scene = SCNScene(named: "art.scnassets/tresure/treasureboxGREEN.dae")!
        
        guard
            let Node = scene.rootNode.childNode(withName: "treasureboxGREEN", recursively: true)
            else{return}
        
        Node.scale = SCNVector3(0.1, 0.1, 0.1)
        Node.name = "treasureboxGREEN"
        characterMakeScene.rootNode.replaceChildNode(nowObjectNode, with: Node)
        nowObjectNode = Node
        
        characterInformation.setObejectName(Node.name!)
    }
    
    func deleteObject(_ name:String,_ characterMakeScene:SCNScene){
        characterMakeScene.rootNode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
    }
}
