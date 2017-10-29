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

extension SCNNode {
    
    //アニメーションの実行，停止をboolで指定できるように
    func ctrlAnimation(forKey: String, play:Bool){
        if let anim = animationPlayer(forKey: forKey) {
            if (play){
                anim.play()
            }else{
                anim.stop(withBlendOutDuration: 1.0)
            }
        }
    }
    
    //自分と子ノードのすべてのアニメーションをコントロールするコンビニエンス関数
    func ctrlAnimationOfAllChildren(do_play:Bool, anim_id:String = "")
    {
        for child in childNodes {
            child.ctrlAnimationOfAllChildren(do_play:do_play, anim_id:anim_id)
        }
        
        //anim_idが空文字列の場合，nodeの最初のアニメーションidを取得する
        if anim_id == "" && animationKeys.count > 0 {
            for key in animationKeys {
                ctrlAnimation(forKey: key, play:do_play)
            }
        }else {
            ctrlAnimation(forKey: anim_id, play: do_play)
        }
        
        
    }
}
