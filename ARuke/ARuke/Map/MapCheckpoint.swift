//
//  MapCheckpoint.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/11/07.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON
import Keys

class MapCheckpoint {
    var mapView = GMSMapView()
    var checkpoints:[CLLocation] = []

    // ランダムなチェックポイントの配列を取得する関数
    func getRandomCheckpoints(_ myLocation:CLLocation, _ checkpointNum: Int = 1, _ randomCoordinate: Double = 0.003) -> [CLLocation]{
        
        // 自分を中心に, randomCoordinateの長さの円を描き, その中からcheckpointNumの数の点を選ぶような感じ.
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
        
        //ロックの取得
        var keepAlive = true
        
        // 先程選んだランダムな点の近くの道を検索.
        let requestURL = createRequeseURL(points: randomCheckpoints)
        //print("url = \(requestURL)")
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
                    keepAlive = false
                    self.checkpoints = randomCheckpoints
                }
                else{
                    // 上手くデータが取れなかったら, 再帰処理
                    //randomCheckpoints = self.getRandomCheckpoints(myLocation, checkpointNum, randomCoordinate)
                    print(json["snappedPoints"].error!)
                    keepAlive = false
                }
                
            case .failure(let error):
                print(error)
                return
                
            }
            
        }

        // データを受け取るまでプログラム待機させる.
        let runLoop = RunLoop.current
        while keepAlive &&
            runLoop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date as Date) {
                // 0.1秒毎の処理なので、処理が止まらない
        }
        return randomCheckpoints
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
    
    func drawCheckpointMarker(_ checkpointLocations:[CLLocation]){
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
    
    let ryukyuCenter = CLLocation(latitude: 26.249834, longitude: 127.765789)
    
    // 琉球大学の場所にmarkerを設置できる関数
    func getRandomDummyCheckpoint() -> [CLLocation] {
        return getRandomCheckpoints(ryukyuCenter)
    }
    
    
}
