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
import Keys

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
    
    func updateRoute(myLocation:CLLocation){
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
        
        let requestURL = createRequeseURL(start: start, goal: goal)
        //print(requestURL)
        Alamofire.request(requestURL).responseJSON { response in
            
            // そもそも通信が成功しているか(サーバーからの返答があるか)判定
            switch response.result {
                
            case .success:
                //print(response.request?.url! as Any)
                
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
    
    // randomなCheckpointを作成.
    func getRandomCheckpoints(_ myLocation:CLLocation, _ checkpointNum: Int = 1, _ randomCoordinate: Double = 0.003, returnCheckpoints:@escaping ([CLLocation]) -> Void ){
        
        // 自分を中心に, randomCoordinateの長さの円を描き, その中から1つの点を選ぶような感じ.
        var randomCheckpoints:[CLLocation] = []
        let _max = randomCoordinate
        let _min = -1 * _max
        let z = _max
        var x:Double = 0
        var y:Double = 0
        for _ in 1 ... checkpointNum {
            
            x = Double(arc4random_uniform(UINT32_MAX)) / Double(UINT32_MAX) * (_max - _min) + _min
            y = sqrt((z * z) - (x * x))
            
            // yは正の値しか取らないため, 0がでたら-1を掛ける
            if arc4random_uniform(2) == 0 {
                y = -1*y
            }
            
            let randomLatitude = Double(myLocation.coordinate.latitude) + x
            let randomLongitude = Double(myLocation.coordinate.longitude) + y
            randomCheckpoints.append(CLLocation(latitude: randomLatitude, longitude: randomLongitude))
            
        }
        
        // 先程選んだランダムな点の近くの道を検索.
        let requestURL = createRequeseURL(points: randomCheckpoints)
        print("url = \(requestURL)")
        Alamofire.request(requestURL).responseJSON { response in
            
            // そもそも通信が成功しているか(サーバーからの返答があるか)判定
            switch response.result {
                
            case .success:
                //print(response.request?.url! as Any)
                let json = JSON(response.result.value!)
                //print(json)
                if let snappedPoints:[JSON] = json["snappedPoints"].arrayValue {
                    for snappedPoint in snappedPoints {
                        let index = snappedPoint["originalIndex"].intValue
                        let latitude = snappedPoint["location"]["latitude"].doubleValue
                        let longitude = snappedPoint["location"]["longitude"].doubleValue
                        randomCheckpoints[index] = CLLocation(latitude: latitude, longitude: longitude)
                        // print("lati = \(latitude), long = \(longitude), index = \(index)")
                    }
                    
                    returnCheckpoints(randomCheckpoints)
                    
                }
                else{
                    // 上手くデータが取れなかったら, 再帰処理
                    self.getRandomCheckpoints(myLocation, checkpointNum, randomCoordinate){checkpoints in
                        returnCheckpoints(checkpoints)
                        
                    }
                    print(json["snappedPoints"].error!)
                    
                }
                
            case .failure(let error):
                print(error)
                return
                
            }
        
        }
        
    }


    // ルートを取得するためのURLを作成
    func createRequeseURL(start:CLLocation, goal:CLLocation) -> String{
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
        let childURL = [
                    "origin=\(origin)",
                    "destination=\(destination)",
                    "alternatives=\(alternatives)",
                    "mode=\(mode)"
                    //"waypoints=\(waypoints)"
                    ].joined(separator: "&")
        

        // URLの結合
        let requestURL = "\(pearentURL)/\(outputFormat)?\(childURL)"
        // パイプライン(|)のエンコード(これをしないと中継点が正しく認識されない.
        if let requestEncodeURL = requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            return requestEncodeURL
        }
        return requestURL
        
    }
    
    // ある地点の近くの道を検索するためのURLを作成
    func createRequeseURL(points:[CLLocation]) -> String{
        // baseURLの作成.
        let pearentURL = "https://roads.googleapis.com/v1"
        
        // 必須項目
        var _points = ""
        
        for index in 0 ... points.count-1{
            let point = points[index]
            let latitude = point.coordinate.latitude
            let longitude = point.coordinate.longitude
            _points = _points + "\(String(format:"%.6f",latitude)),\(String(format:"%.6f",longitude))"
            if index == points.count - 1{
                break
            }else{
                _points = _points + "|"
            }
            
        }
        
        
        // 子URLの作成
        let childURL = ["points=\(_points)",
                        "key=\(ARukeKeys().googleMapAPIKey)"
                        ].joined(separator: "&")
        
        
        // URLの結合
        let requestURL = "\(pearentURL)/nearestRoads?\(childURL)"
        // パイプライン(|)のエンコード(これをしないと中継点が正しく認識されない.
        if let requestEncodeURL = requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            return requestEncodeURL
        }
        return requestURL
        
    }
    

    func drawCheckpointMarker(checkpointLocations:[CLLocation]){
        var i = 1
        for checkpointLocation in checkpointLocations{
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            // マーカーの場所を表示. WGS84の座標系. latitude: 緯度, longitude: 経度
            marker.position = checkpointLocation.coordinate
            marker.title = "checkpoint\(i)"
            marker.snippet = "Okinawa"
            marker.map = mapView
            i = i+1
            
        }
    }
    
    
    
    // ---- ここから, ダミーの値を返す関数群 ---- //
    
    // ダミーの琉球大学のチェックポイント
    // latitude: 緯度, longitude: 経度
    let dummyCheckpoint = CLLocation(latitude: 26.253726, longitude: 127.766949)
    
    let ryukyuCenter = CLLocation(latitude: 26.249834, longitude: 127.765789)
    
    func getInitDummyRoutes(_ myLocation:CLLocation){
        let goalLocation = dummyCheckpoint
        
        getRoutes(myLocation, goalLocation)
    }
    
    
    // 琉球大学の場所にmarkerを設置できる関数
    func getStaticDummyCheckpoint(){
        drawCheckpointMarker(checkpointLocations: [dummyCheckpoint])
    }
    // 琉球大学の場所にmarkerを設置できる関数
    func getRandomDummyCheckpoint(){
        
        getRandomCheckpoints(ryukyuCenter){ checkpoints in
            self.getRoutes(self.ryukyuCenter, checkpoints.last!)
            self.drawCheckpointMarker(checkpointLocations: checkpoints)
            
        }
    
    }
    
    // チェックポイントについたかどうかの判定
    func isDummyCheckpointArrive(_ myLocation:CLLocation) -> Bool{
        return isCheckpointArrive(myLocation,dummyCheckpoint)
    }
}

