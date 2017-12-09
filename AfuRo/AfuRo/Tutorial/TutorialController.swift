//
//  TutorialController.swift
//  AfuRo
//
//  Created by e155707 on 2017/11/27.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit

class TutorialController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }
    
    func getFirst() -> FirstTutorialController {
        let storyboard: UIStoryboard = UIStoryboard(name:"FirstTutorial",bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FirstTutorialController") as! FirstTutorialController
    }
    
    func getSecond() -> SecondTutorialController {
        let storyboard: UIStoryboard = UIStoryboard(name:"SecondTutorial",bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SecondTutorialController") as! SecondTutorialController
    }
    
    func getThird() -> ThreeTutorialController {
        let storyboard: UIStoryboard = UIStoryboard(name:"ThreeTutorial",bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ThreeTutorialController") as! ThreeTutorialController
    }
    
    func getFourth() -> FourTutorialController {
        let storyboard: UIStoryboard = UIStoryboard(name:"FourTutorial",bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FourTutorialController") as! FourTutorialController
    }
    
    func getMain() -> MainController{
        let storyboard: UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "Main") as! MainController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension TutorialController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of:FourTutorialController.self) {
            return getThird()
        } else if viewController.isKind(of:ThreeTutorialController.self) {
            return getSecond()
        } else if viewController.isKind(of:SecondTutorialController.self) {
            return getFirst()
        } else if viewController.isKind(of:MainController.self) {
            return nil
        } else {
            return nil
        }
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of:FirstTutorialController.self) {
            return getSecond()
        } else if viewController.isKind(of:SecondTutorialController.self) {
            return getThird()
        } else if viewController.isKind(of:ThreeTutorialController.self) {
            return getFourth()
        } else if viewController.isKind(of:MainController.self) {
            return nil
        } else {
            return nil
        }
        
    }
}
