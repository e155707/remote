//
//  MapErrorController.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/10/29.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit

class MapErrorController: UIViewController{

    func notAccess(){
        self.alertMessage(message: "通信ができないので, ルートを検索することができません.")
        
    }
    
    func notGetLocation(){
        self.alertMessage(message: "位置情報にアクセスできません.\n 設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい")
    }
    
    //メッセージ出力メソッド
    func alertMessage(message:String) {
        let aleartController = UIAlertController(title: "注意", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
        aleartController.addAction(defaultAction)
    
        present(aleartController, animated:true, completion:nil)
    
    }
}
