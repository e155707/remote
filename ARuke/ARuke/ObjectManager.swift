//
//  ObjectManager.swift
//  ARuke
//
//  Created by e155707 on 2017/10/28.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//
import UIKit
import SceneKit
import ARKit

class ObjectManager{
    
    func managerObjectTresure(_ planeVector:SCNVector3,_ planeNode:SCNNode){
        
        let scene = SCNScene(named: "art.scnassets/tresure/treasureboxRED.dae")!
        let scene2 = SCNScene(named: "art.scnassets/tresure/treasureboxBLUE.dae")!
        let scene3 = SCNScene(named: "art.scnassets/tresure/treasureboxGREEN.dae")!
        
        guard
            let Node = scene.rootNode.childNode(withName: "treasureboxRED", recursively: true),
            let Node2 = scene2.rootNode.childNode(withName: "treasureboxBLUE", recursively: true),
            let Node3 = scene3.rootNode.childNode(withName: "treasureboxGREEN", recursively: true)
            else{return}
        
        //let Node2 = Node.clone()
        //let Node3 = Node.clone()
        
        Node.scale = SCNVector3(0.005, 0.005, 0.005)
        Node2.scale = SCNVector3(0.005, 0.005, 0.005)
        Node3.scale = SCNVector3(0.005, 0.005, 0.005)
    
        Node.name = "miss"
        Node2.name = "hit"
        Node3.name = "miss"
        
        Node.position  = planeVector
        Node.position.x = Node.position.x - 0.5
        Node.position.y = 0
        
        Node2.position  = planeVector
        Node2.position.y = 0
        
        Node3.position  = planeVector
        Node3.position.x = Node3.position.x + 0.5
        Node3.position.y = 0
        
        
        planeNode.addChildNode(Node)
        planeNode.addChildNode(Node2)
        planeNode.addChildNode(Node3)
    }
    
    
    func managerObjectItem(_ planeVector:SCNVector3,_ planeNode:SCNNode){
        
        let scene4 = SCNScene(named: "art.scnassets/item_x2.dae")!
        
        guard
            let Node4 = scene4.rootNode.childNode(withName: "Text", recursively: true)
            else{return}
        
        Node4.scale = SCNVector3(0.1, 0.1, 0.1)
        
        Node4.name = "x2"
        
        Node4.position  = planeVector
        Node4.position.y = 0
        
        planeNode.addChildNode(Node4)
        
        planeNode.ctrlAnimationOfAllChildren(do_play: false)
    }
    
}
