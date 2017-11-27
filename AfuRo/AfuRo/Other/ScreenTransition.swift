//
//  ScreenTransition.swift
//  AfuRo
//
//  Created by e155707 on 2017/11/27.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit

extension TitleController{
    func fromTitleToMain(){
        let storyboard: UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "Main") as! MainController
        present(next as UIViewController, animated: true,completion: nil)
        print("Main")
    }
    
    func fromTitleToTutorial(){
        let storyboard: UIStoryboard = UIStoryboard(name:"Tutorial",bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "Tutorial") as! TutorialController
        present(next as UIViewController, animated: true,completion: nil)
        print("Tutorial")
    }
}
