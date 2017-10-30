//
//  QuizEventManager.swift
//  ARuke
//
//  Created by e155707 on 2017/10/30.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//
import Foundation

class QuizEventManager{
    var redAnswer:Bool = false
    var greenAnswer:Bool = false
    var blueAnswer:Bool = false
    
    let defaults = UserDefaults.standard
    
    func setAnswerColor(_ answerColor:Bool){
        
        redAnswer = defaults.bool(forKey: "redKey")
        blueAnswer = defaults.bool(forKey: "blueKey")
        greenAnswer = defaults.bool(forKey: "greenKey")
        
        defaults.set(redAnswer, forKey: "redKey")
        defaults.set(blueAnswer, forKey: "redKey")
        defaults.set(greenAnswer, forKey: "redKey")
    }
    
    func getAnswerColor() -> Bool{
        redAnswer = defaults.bool(forKey: "redKey")
        blueAnswer = defaults.bool(forKey: "blueKey")
        greenAnswer = defaults.bool(forKey: "greenKey")
        
        return redAnswer
    }
}
