//
//  Afuro.swift
//  AfuRo
//
//  Created by 赤堀　貴一 on 2017/12/17.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class Afuro: SCNNode {
    
    var afuroNode: SCNNode!
    
    let anglex = -89.6
    
    // Afuroの増える大きさを調整する係数.
    // 今の計算式 アフロの大きさ = afuroInitScale + 歩数(totalStepsData) * afuroScaleCoeff
    let afuroScaleCoeff:Float = 0.01
    
    let afuroInitScale:Float = 1
    let changeBirdAfuroSteps = 100
    var _steps = 0
    
    init(steps:Int) {
        super.init()
        
        afuroNode = SCNScene(named: "art.scnassets/daefile/afuro.scn")?.rootNode.childNode(withName:"afuro" , recursively: true)
        
        self.addScale(steps: steps)
        
        // アフロの回転
        self.afuroNode.eulerAngles = SCNVector3(anglex,0,0)

        self.addChildNode(afuroNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addScale(steps:Int){
        // アフロの大きさ
        _steps += steps
        let afuroScale = afuroInitScale + Float(_steps) * afuroScaleCoeff
        self.afuroNode.scale = SCNVector3(afuroScale, afuroScale, afuroScale)
        // 位置の変更
        self.afuroNode.position = SCNVector3(0,0, -2 + -1*afuroScale)
        self.changeAfuroGeometory()

    }
    
    func changeAfuroGeometory(){
        var afuroScene:SCNScene!
        
        if changeBirdAfuroSteps < _steps {
            
            afuroScene = SCNScene(named: "art.scnassets/daefile/afuro_bird.scn")
            print("afuro bird")
        }else{
            
            afuroScene = SCNScene(named: "art.scnassets/daefile/afuro.scn")
            print("afuro normal")
            
        }
        afuroNode.geometry = afuroScene.rootNode.childNode(withName:"afuro" , recursively: true)?.geometry

    }
    
    
}
