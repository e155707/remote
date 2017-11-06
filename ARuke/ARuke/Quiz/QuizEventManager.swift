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
    
    func answerInitialization(){
        redAnswer = false
        blueAnswer = false
        greenAnswer = false
        
        defaults.set(redAnswer, forKey: "redKey")
        defaults.set(redAnswer, forKey: "blueKey")
        defaults.set(redAnswer, forKey: "greenKey")
    }
    
    func setAnswerRed(_ answerColorRed:Bool){
        redAnswer = defaults.bool(forKey: "redKey")
        redAnswer = answerColorRed
        defaults.set(redAnswer, forKey: "redKey")
    }
    
    func setAnswerBlue(_ answerColorBlue:Bool){
        blueAnswer = defaults.bool(forKey: "blueKey")
        blueAnswer = answerColorBlue
        defaults.set(blueAnswer, forKey: "blueKey")
    }
    
    func setAnswerGreen(_ answerColorGreen:Bool){
        greenAnswer = defaults.bool(forKey: "greenKey")
        greenAnswer = answerColorGreen
        defaults.set(greenAnswer, forKey: "greenKey")
    }
    
    
    
    func getAnswerRed() -> Bool{
        redAnswer = defaults.bool(forKey: "redKey")
        
        return redAnswer
    }
    
    func getAnswerBlue() -> Bool{
        blueAnswer = defaults.bool(forKey: "blueKey")
        
        return blueAnswer
    }
    
    func getAnswerGreen() -> Bool{
        greenAnswer = defaults.bool(forKey: "greenKey")
        
        return greenAnswer
    }
    
}
