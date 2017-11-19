//
//  ManageCharacter.swift
//  ARuke
//
//  Created by e155707 on 2017/11/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ManageCharacter{
    
    let defaults = UserDefaults.standard
    
    var gender:String = String()
    var color:String = String()
    var name:String = String()
    var obejectName:String = String()
    
    let characterScene:SCNScene = SCNScene()
    
    func managerCamera() -> SCNScene{
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        
        cameraNode.position = SCNVector3(x:0, y:1, z:5)
        characterScene.rootNode.addChildNode(cameraNode)
        
        return characterScene
    }
    
    
    func managerCharacter(_ characterScene:SCNScene){
        gender = defaults.string(forKey: "gender")!
        color = defaults.string(forKey: "color")!
        name = defaults.string(forKey: "name")!
        obejectName = defaults.string(forKey: "ObjectName")!
        
        let scene = SCNScene(named: "art.scnassets/tresure/"+obejectName+".dae")!
        
        guard
            let Node = scene.rootNode.childNode(withName: obejectName, recursively: true)
            else{return}
        
        Node.scale = SCNVector3(0.08, 0.08, 0.08)
        Node.name = obejectName
        characterScene.rootNode.addChildNode(Node)
        print(Node)
    }
    
    func getCharacterName() -> String{
        name = defaults.string(forKey: "name")!
        
        return name
    }
}

