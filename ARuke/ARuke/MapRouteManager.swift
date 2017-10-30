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
    
    var mapView = GMSMapView()
    var routePath = GMSMutablePath()
    
    var drawLineFromPath = GMSPolyline()

    func drawRouteFromPath(){
        // ルートの線を引く GMSPathは静的配列のため, 動的配列のGMSMutablePathを使う.
        
        drawLineFromPath.map = nil
        drawLineFromPath = GMSPolyline(path: routePath)
        drawLineFromPath.strokeColor = .blue
        drawLineFromPath.strokeWidth = 10.0
        drawLineFromPath.map = mapView

    }
    
    func updateRoute(myLocation myLocation:CLLocation){
        routePath.replaceCoordinate(at: 0, with: myLocation.coordinate)
        drawRouteFromPath()
    }
    
    // チェックポイントについたかどうかの判定
    func isCheckpointArrive(_ myLocation:CLLocation, _ checkPointLocation:CLLocation) -> Bool{
        let errorRange:Double = 10 // error 10m
        let distanceInMeters = myLocation.distance(from: checkPointLocation)
        if distanceInMeters <= errorRange{
            return true
        }
        return false
        
    }
    
    
    func getRoutes(_ start:CLLocation, _ goal:CLLocation) {
        
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
                    self.routePath = GMSMutablePath(fromEncodedPath: route!)!
                    
                    self.drawRouteFromPath()
                    
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
    
    
    
    // ---- ここから, ダミーの値を返す関数群 ---- //
    
    // ダミーの琉球大学のチェックポイント
    let dummyCheckpoint = CLLocation(latitude: 26.253726, longitude: 127.766949)
    
    func getInitDummyRoutes(_ myLocation:CLLocation){
        let goalLocation = dummyCheckpoint
        getRoutes(myLocation, goalLocation)
    }
    
    // 琉球大学の場所にmarkerを設置できる関数
    func getDummyCheckpoint(){
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        
        // マーカーの場所を表示. WGS84の座標系. latitude: 緯度, longitude: 経度
        marker.position = dummyCheckpoint.coordinate
        marker.title = "Ryuukyuu"
        marker.snippet = "Okinawa"
        marker.map = mapView
    }
    
    // チェックポイントについたかどうかの判定
    func isDummyCheckpointArrive(_ myLocation:CLLocation) -> Bool{
        return isCheckpointArrive(myLocation,dummyCheckpoint)
    }
}

