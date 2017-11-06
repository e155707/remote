//
//  LocateEvent.swift
//  ARuke
//
//  Created by e155707 on 2017/10/30.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

/*
import UIKit
import SceneKit
import ARKit

extension EventController{
    @objc func update(tm: Timer) {
        
        let range:Float = 0.1
        
        if(answer.getAnswerBlue() && (fabsf((sceneView.pointOfView?.position.x)! - planeVector.x) <= range) && (fabsf((sceneView.pointOfView?.position.z)! - planeVector.z) <= range) ){
            
            print("x" , fabsf((sceneView.pointOfView?.position.x)! - planeVector.x))
            print("y" , fabsf((sceneView.pointOfView?.position.y)! - planeVector.y))
            print("z" , fabsf((sceneView.pointOfView?.position.z)! - planeVector.z))
            
            planeNode.childNode(withName: "hit", recursively: false)?.runAction(SCNAction.removeFromParentNode())
            
            let score:ScoreManager = ScoreManager()
            score.getTimesEffect(2.0)
            
            let object:ObjectManager = ObjectManager()
            object.managerObjectItem(planeVector,planeNode)
            
        }else if(answer.getAnswerRed() && (sceneView.pointOfView?.position.x)! <= range && (sceneView.pointOfView?.position.x)! <= range){
            
            //print(answer.getAnswerRed())
            planeNode.childNode(withName: "miss1", recursively: false)?.runAction(SCNAction.removeFromParentNode())
            
            let storyboard: UIStoryboard = UIStoryboard(name:"Map",bundle: nil)
            let next = storyboard.instantiateViewController(withIdentifier: "Map") as! MapConroller
            present(next as UIViewController, animated: true,completion: nil)
            print("Map")
            
        }
                
        
        
    }
}
*/
