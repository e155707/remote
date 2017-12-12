//
//  MapErrorController.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/10/29.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit

class ErrorController: UIViewController{

    func notCameraAccess(){
        self.alertMessage("アクセス拒否", "カメラへのアクセスができません.")
    }
    
    func notGetLocation(){
        self.alertMessage("注意", "位置情報にアクセスできません.\n 設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい")
        
    }
    func notGetImage(){
        self.alertMessage("写真が撮れません", "写真を撮ることができなかったです.")
    }
    
    func imageSaveFailed(){
        self.alertMessage("写真の保存ができません", "")
    }
    
    //メッセージ出力メソッド
    func alertMessage(_ title:String, _ message:String) {
        let aleartController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
        aleartController.addAction(defaultAction)
    
        present(aleartController, animated:true, completion:nil)
    
    }
}
