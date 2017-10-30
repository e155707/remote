//
//  PlaneEvent.swift
//  ARuke
//
//  Created by e155707 on 2017/10/28.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//
import UIKit
import SceneKit
import ARKit

extension EventController{
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let view = self.sceneView else { //scnViewが存在することを保証(同時にアンラップ)
            return
        }
        
        if sender.state == .ended { //タップし終えたか？
            
            //タップ位置を取得
            let loc = sender.location(in: self.sceneView)
            
            //３Dオブジェクトに対するヒットテスト（どのgeometryをタップしたか？）
            let results = view.hitTest(loc)
            
            //結果は配列で返る．一つ以上ヒットしており，かつヒットしたgeometryのノードに名前があれば実行する
            if let res = results.first, let name = res.node.name {
                print(name)
                if(name == "hit" && answer.getAnswerBlue() == true){
                    
                    print(answer.getAnswerBlue())
                    planeNode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
                    
                    let score:ScoreManager = ScoreManager()
                    score.getTimesEffect(2.0)
                    
                    let object:ObjectManager = ObjectManager()
                    object.managerObjectItem(planeVector,planeNode)
                    
                    
                }else if(name == "miss1" && answer.getAnswerRed() == true){
                    
                    print(answer.getAnswerRed())
                    planeNode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
                    
                    let storyboard: UIStoryboard = UIStoryboard(name:"Map",bundle: nil)
                    let next = storyboard.instantiateViewController(withIdentifier: "Map") as! MapConroller
                    present(next as UIViewController, animated: true,completion: nil)
                    print("Map")
                
                }else if(name == "miss2" && answer.getAnswerGreen() == true){
                    
                    print(answer.getAnswerGreen())
                    planeNode.childNode(withName: name, recursively: false)?.runAction(SCNAction.removeFromParentNode())
                    
                    let storyboard: UIStoryboard = UIStoryboard(name:"Map",bundle: nil)
                    let next = storyboard.instantiateViewController(withIdentifier: "Map") as! MapConroller
                    present(next as UIViewController, animated: true,completion: nil)
                    print("Map")
                    
                }else if(name == "x2"){
                    
                    let storyboard: UIStoryboard = UIStoryboard(name:"Map",bundle: nil)
                    let next = storyboard.instantiateViewController(withIdentifier: "Map") as! MapConroller
                    present(next as UIViewController, animated: true,completion: nil)
                    print("Map")
                    
                }else{}
            }
        }
    }
}
