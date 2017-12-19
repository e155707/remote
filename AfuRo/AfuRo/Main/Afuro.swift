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
    
    // Afuroの増える大きさを調整する係数.
    // 今の計算式 アフロの大きさ = afuroScale + 歩数(totalStepsData) * afuroScaleCoeff
    let afuroScaleCoeff:Float = 0.01
    var afuroScale:Float = 1
    let changeBirdAfuroSteps = 100
    
    init(steps:Int) {
        super.init()
        var afuroScene:SCNScene!
        var _steps = steps
        if changeBirdAfuroSteps < steps{
            
            afuroScene = SCNScene(named: "art.scnassets/daefile/afuro_bird.scn")
            _steps = steps-changeBirdAfuroSteps
        }else{
            
            afuroScene = SCNScene(named: "art.scnassets/daefile/afuro.scn")
            
        }
        afuroNode = afuroScene.rootNode.childNode(withName:"afuro" , recursively: true)
        addScale(steps: _steps)
        // アフロの回転
        afuroNode.eulerAngles = SCNVector3(-90,0,0)
        // 大きさの変更
        afuroNode.scale = SCNVector3Make(afuroScale, afuroScale, afuroScale)
        // アフロの位置
        afuroNode.position = SCNVector3(0,0,-2-afuroNode.scale.z/2)
        addChildNode(afuroNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addScale(steps:Int){
        afuroScale += Float(steps) * afuroScaleCoeff
        // 大きさの変更
        afuroNode.scale = SCNVector3Make(afuroScale, afuroScale, afuroScale)
    }
    
    
}
