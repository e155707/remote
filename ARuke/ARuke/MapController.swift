//
//  MapController.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/10/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON

class MapConroller: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    let locationManager = CLLocationManager()
    var routePath = GMSMutablePath()
    @IBOutlet var mapView: GMSMapView!
    
    var lineMeToGoal = GMSPolyline()

    var mylocation = CLLocation()
    
    var goal = CLLocation()
    var count = 0
    // WGS84の座標系での琉球大学の位置(緯度, 経度)
    let ryukyuLatitude = 26.253726
    let ryukyuLongitude = 127.766949
    let zoomLevel:Float = 17
    
    //AppDelegateを呼ぶ
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Scoreや歩いている距離に関する変数
    var tmpScore:Double = 0 // 誤差を保存しておく
    //appDelegate.totalScore// これが表示されるScore
    var scoreRatio:Double = 1 // 倍率
    
    var tmpWalkInKilometre:Double = 0 // 誤差を保存しておく
    var totalWalk: Double = 0 //今まで歩いた数. 単位はメートル
    
    
    /** override vieDidLoad()
     * Viewの初期化,locationManagerの初期化. GoogleMapをMap.storyboardに表示する.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        goal = CLLocation(latitude: ryukyuLatitude, longitude: ryukyuLongitude)
        initMapView()
        setLocateManager()
        // makeCheckpointに直す
        ryukyuLocationMarker()
        
    }
    
    // mapViewの初期化. 最初は琉球大学を写すよう指定
    func initMapView(){
        // WGS84の座標系でカメラを設定. latitude: 緯度, longitude: 経度
        
        
        // positonMasure -> getCurrentposition or makeダミーpositionみたいな感じで琉球大学をさす
        let camera = GMSCameraPosition.camera(withLatitude: ryukyuLatitude, longitude: ryukyuLongitude, zoom: zoomLevel)

   
        // GoogleMapの初期化
        //self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.mapView.camera = camera
        self.mapView.delegate = self
    
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
        
        // 地形の起伏と道路を表示するマップ
        self.mapView.mapType = GMSMapViewType.terrain
        // view = mapView
        
    }
    
    // 位置情報の設定
    func setLocateManager(){
        
        // 現在位置情報の精度, 誤差を決定. 以下の様なものがある
        // - kCLLocationAccuracyBestForNavigation ナビゲーションに最適な値
        // - kCLLocationAccuracyBest 最高精度(iOS,macOSのデフォルト値)
        // - kCLLocationAccuracyNearestTenMeters 10m
        // - kCLLocationAccuracyHundredMeters 100m（watchOSのデフォルト値）
        // - kCLLocationAccuracyKilometer 1Km
        // - kCLLocationAccuracyThreeKilometers 3Km
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 現在位置からどれぐらい動いたら更新するか. 単位はm
        locationManager.distanceFilter = 1
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func initScore(_ distanceInMeters: CLLocationDistance){
        if count == 0 {
            appDelegate.totalScore = 0
            count = 1
        }
        
    }
    
    // flagがtrueの場合, 自分の位置を表示. 役割をわかりやすくするために関数化しただけ.
    func myLocationMarker(_ flag: Bool){
        mapView.isMyLocationEnabled = flag
    }

    
    //起動時と, 位置情報のアクセス許可が変更された場合に呼び出されるメソッド. ここで位置情報のアクセス許可をとる.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            // 位置情報アクセスを常に許可するかを問いかける
            locationManager.requestAlwaysAuthorization()
            
            break
            
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 位置情報アクセスを常に許可するかを問いかける
            locationManager.requestAlwaysAuthorization()
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            alertMessage(message: "設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい")
            break
        
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            alertMessage(message: "このアプリは位置情報を取得できないために、正常に動作できません")
            break
 
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            myLocationMarker(true)
            getRoutes(mylocation, goal)
            break
            
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            //alertMessage(message: "このアプリは常に位置情報が必要です.")
            myLocationMarker(true)
            locationManager.requestAlwaysAuthorization()
            getRoutes(mylocation, goal)
            // 位置情報取得の開始処理
            break
        
        }
    }
    
    //　遷移関係は, 別のクラスを用意したりする. gameEngine
    // プロトコルを作る. locationChangedという
    
    // 位置情報がlocationManager.distanceFilterの値分更新された時に呼び出されるメソッド.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        self.mapView.camera = camera
        
        
        routePath.replaceCoordinate(at: 0, with: location.coordinate)
        
        let locationDistance = location.distance(from: mylocation)
        if (isCheckpointArrive(location, goal)){
            let storyboard: UIStoryboard = UIStoryboard(name: "EventControlle", bundle: nil)
            let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
            present(next, animated: true, completion: nil)
            
            // let distanceInMeters = coordinate0.distance(from: coordinate1)
            
        }else{

            lineMeToGoal.map = nil
            lineMeToGoal = GMSPolyline(path: self.routePath)
            lineMeToGoal.strokeColor = .blue
            lineMeToGoal.strokeWidth = 10.0
            lineMeToGoal.map = self.mapView
            addScore(locationDistance)
            addWalk(locationDistance)
            initScore(locationDistance)
            mylocation = location
        }
    }
    
    // チェックポイントについたかどうかの判定
    func isCheckpointArrive(_ firstLocation:CLLocation, _ secondLocation:CLLocation) -> Bool{
        let errorRange:Double = 1 // error 10m
        let distanceInMeters = firstLocation.distance(from: secondLocation)
        if distanceInMeters <= errorRange{
            return true
        }
        return false
        
    }
    
    
    func addScore(_ distanceInMeters: CLLocationDistance){
        tmpScore = scoreRatio * distanceInMeters
        appDelegate.totalScore  = appDelegate.totalScore + Int64(tmpScore)
        print(appDelegate.totalScore)
    }
    
    func addWalk(_ distanceInMeters: CLLocationDistance){
        tmpWalkInKilometre = distanceInMeters
        totalWalk = totalWalk + tmpWalkInKilometre
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    //メッセージ出力メソッド
    func alertMessage(message:String) {
        let aleartController = UIAlertController(title: "注意", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
        aleartController.addAction(defaultAction)
        
        present(aleartController, animated:true, completion:nil)
        
    }
    
    // routeManagerを作る
    func getRoutes(_ start:CLLocation, _ end:CLLocation) {
        
        let requestURL = createRequeseURL(start, end)
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
                    polyline.map = self.mapView
                }
                else{
                    self.routePath.add(self.goal.coordinate)
                    print("statusがokではありません")
                    
                }
                
            case .failure(let error):
                print(error)
                self.alertMessage(message: "通信ができないので, ルートを検索することができません.")
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
            ]
            .joined(separator: "&")
        
        // URLの結合
        let requestURL = "\(pearentURL)/\(childURL)"
        // パイプライン(|)のエンコード(これをしないと中継点が正しく認識されない.
        if let requestEncodeURL = requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            return requestEncodeURL
        }
        
        return requestURL
        
    }
    
    func getRyukyuLoopRoutes() {
        let requestURL = createRequestRyukyuURL()

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
                    polyline.map = self.mapView
                }
                
            case .failure(let error):
                print(error)
                self.alertMessage(message: "通信ができないので, ルートを検索することができません.")
                return
                
            }
        }
    }
    // 琉球大学のループ道路のルート検索URL
    func createRequestRyukyuURL() -> String{
        
        // baseURLの作成.
        let pearentURL = "https://maps.googleapis.com/maps/api/directions"
        
        
        // 必須項目
        let outputFormat="json" // json or xml
        let origin = "\(ryukyuLatitude),\(ryukyuLongitude)"// 出発点の緯度と経度
        let destination = "\(ryukyuLatitude),\(ryukyuLongitude)" // 到着点の緯度と経度
        
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
            ]
            .joined(separator: "&")
        
        // URLの結合
        let requestURL = "\(pearentURL)/\(childURL)"
        // パイプライン(|)のエンコード(これをしないと中継点が正しく認識されない.
        if let requestEncodeURL = requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            return requestEncodeURL
        }
        
        return requestURL
        
    }
    
    // 琉球大学の場所にmarkerを設置できる関数
    func ryukyuLocationMarker(){
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        
        // マーカーの場所を表示. WGS84の座標系. latitude: 緯度, longitude: 経度
        marker.position = CLLocationCoordinate2D(latitude: ryukyuLatitude, longitude: ryukyuLongitude)
        marker.title = "Ryuukyuu"
        marker.snippet = "Okinawa"
        marker.map = mapView
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
