//
//  MapMarker.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/10/29.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON

class MapRouteManager{
    
    var routePath = GMSMutablePath()

    func getInitRoutes(_ start:CLLocation, _ goal:CLLocation,_ mapView:GMSMapView) {
        
        let requestURL = createRequeseURL(start, goal)
        print(requestURL)
        Alamofire.request(requestURL).responseJSON { response in
            
            // そもそも通信が成功しているか(サーバーからの返答があるか)判定
            switch response.result {
                
            case .success:
                print(response.request?.url! as Any)
                
                let json = JSON(response.result.value!)
                if json["status"].stringValue == "OK" {
                    
                    // 検索ルート候補のすべてを取得
                    let routes = json["routes"].arrayValue
                    // 検索ルート候補の0番目の始点から終点までのルートの情報を取得
                    let overviewPolyline = routes[0]["overview_polyline"].dictionary
                    let route = overviewPolyline!["points"]?.stringValue
                    
                    // ルートの線を引く GMSPathは静的配列のため, 動的配列のGMSMutablePathを使う.
                    self.routePath = GMSMutablePath.init(fromEncodedPath: route!)!
                    
                    let polyline = GMSPolyline(path: self.routePath)
                    
                    polyline.strokeColor = .blue
                    polyline.strokeWidth = 10.0
                    polyline.map = mapView
                }
                else{
                    self.routePath.add(goal.coordinate)
                    print("statusがokではありません")
                    
                }
                
            case .failure(let error):
                print(error)
                return
                
            }
            
        }
        
    }
    
    func createRequeseURL(_ start:CLLocation, _ goal:CLLocation) -> String{
        
        // baseURLの作成.
        let pearentURL = "https://maps.googleapis.com/maps/api/directions"
        
        // 必須項目
        let outputFormat="json" // json or xml
        let origin = "\(start.coordinate.latitude),\(start.coordinate.longitude)"// 出発点の緯度と経度
        let destination = "\(goal.coordinate.latitude),\(goal.coordinate.longitude)" // 到着点の緯度と経度
        
        // 省略可能な項目
        let mode = "walking" //driving(default), walking, bicycling, transit
        /*
         let waypoints = ["26.245985,127.763861", // 中継点.  琉球大学南口
         "26.247313,127.768448"] // 琉球大学東口
         .joined(separator: "|")*/
        let alternatives = "false" // 複数のルートを表示 -> true , いらない -> false
        
        // 子URLの作成
        let childURL = ["\(outputFormat)?",
            "origin=\(origin)",
            "destination=\(destination)",
            "alternatives=\(alternatives)",
            "mode=\(mode)"
            //"waypoints=\(waypoints)"
            ].joined(separator: "&")
        
        // URLの結合
        let requestURL = "\(pearentURL)/\(childURL)"
        // パイプライン(|)のエンコード(これをしないと中継点が正しく認識されない.
        if let requestEncodeURL = requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            return requestEncodeURL
        }
        
        return requestURL
        
    }
    
    func getInitDummyRoutes(_ myLocation:CLLocation, _ mapView:GMSMapView){
        // WGS84の座標系での琉球大学の位置(緯度, 経度)
        let ryukyuLatitude = 26.253726
        let ryukyuLongitude = 127.766949
        
        let goalLocation = CLLocation(latitude: ryukyuLatitude, longitude: ryukyuLongitude)
        getInitRoutes(myLocation, goalLocation ,mapView)
    }
}

