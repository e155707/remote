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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        if(planeFlag == 0){
        
            planeFlag = 1
            
            // 平面を生成
            let plane = Plane(anchor: planeAnchor)
        
            planeNode = node
            planeVector = SCNVector3(planeAnchor.center)
        
            // ノードを追加
            planeNode.addChildNode(plane)
        
            //宝箱
            let object:ObjectManager = ObjectManager()
            object.managerObjectTresure(planeVector,planeNode)
        }
        // 管理用配列に追加
        //planes.append(plane)
        
    }
}
