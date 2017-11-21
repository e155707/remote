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
    var level:Int = Int()
    var experiencePoint:Int = Int()
    var maxExperiencePoint:Int = Int()
    var HP:Int = Int()
    
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
    
    func getCharacterLevel() -> Int{
        level = defaults.integer(forKey: "level")
        return level
    }
    
    func setCharacterLevel(_ setLevel:Int){
        level = defaults.integer(forKey: "level")
        level = setLevel
        defaults.set(level, forKey: "level")
    }
    
    
    func getCharacterExperiencePoint() -> Int{
        experiencePoint = defaults.integer(forKey: "experiencePoint")
        return experiencePoint
    }
    
    func setCharacterExperiencePoint(_ setExperiencePoint:Int){
        experiencePoint = defaults.integer(forKey: "experiencePoint")
        experiencePoint = setExperiencePoint
        defaults.set(setExperiencePoint, forKey:"experiencePoint")
    }
    
    
    func getCharacterMaxExperiencePoint() -> Int{
        maxExperiencePoint = defaults.integer(forKey: "maxExperiencePoint")
        return maxExperiencePoint
    }
    
    func setCharacterMaxExperiencePoint(_ setMaxExperiencePoint:Int){
        maxExperiencePoint = defaults.integer(forKey: "maxExperiencePoint")
        maxExperiencePoint = setMaxExperiencePoint
        defaults.set(maxExperiencePoint, forKey:"maxExperiencePoint")
    }
    
    func getCharacterHP() -> Int{
        HP = defaults.integer(forKey: "HP")
        return HP
    }
    
    func setCharacterHp(_ setHP:Int){
        HP = defaults.integer(forKey:"HP")
        HP = setHP
        defaults.set(HP, forKey:"HP")
    }
}

