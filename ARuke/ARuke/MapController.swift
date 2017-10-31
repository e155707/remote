//
//  MapController.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/10/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import GoogleMaps
import UserNotifications

class MapConroller: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    let locationManager = CLLocationManager()
    let scoreManager = ScoreManager()
    let distanceManager = DistanceManager()
    let mapRouteManager = MapRouteManager()
    
    @IBOutlet var mapView: GMSMapView!
    
    var oldLocation:CLLocation!

    let zoomLevel:Float = 17
    
    /** override vieDidLoad()
     * Viewの初期化,locationManagerの初期化. GoogleMapをMap.storyboardに表示する.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        initManager()
        // notification()
        setLocateManager()
        
    }
    
    func initManager(){
        mapRouteManager.mapView = mapView
        mapRouteManager.getDummyCheckpoint()
    }
    
    // mapViewの初期化. 最初は琉球大学を写すよう指定
    func initMapView(){

        // GoogleMapの初期化
        getInitDummyCamera()
        self.mapView.delegate = self
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
        
        // 地形の起伏と道路を表示するマップ
        self.mapView.mapType = GMSMapViewType.terrain
        
    }
    
    func getInitDummyCamera(){
        // WGS84の座標系でカメラを設定. latitude: 緯度, longitude: 経度
        // WGS84の座標系での琉球大学の位置(緯度, 経度)
        let ryukyuLatitude = 26.253726
        let ryukyuLongitude = 127.766949
        let camera = GMSCameraPosition.camera(withLatitude: ryukyuLatitude, longitude: ryukyuLongitude, zoom: zoomLevel)
        self.mapView.camera = camera
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
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
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
            MapErrorController().notGetLocation()
            break
        
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            MapErrorController().notGetLocation()
            break
 
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            myLocationMarker(true)
            
            break
            
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            //alertMessage(message: "このアプリは常に位置情報が必要です.")
            myLocationMarker(true)
            locationManager.requestAlwaysAuthorization()
            // 位置情報取得の開始処理
            break
        
        }
    }
    
    
    
    // 位置情報がlocationManager.distanceFilterの値分更新された時に呼び出されるメソッド.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        self.mapView.camera = camera
        
        if oldLocation == nil {
            oldLocation = location
            mapRouteManager.getInitDummyRoutes(location)
        }
        let locationDistance = location.distance(from: oldLocation)
        //notification()
        if (mapRouteManager.isDummyCheckpointArrive(location)){
            notification()
            // 遷移
            let storyboard: UIStoryboard = UIStoryboard(name: "EventControlle", bundle: nil)
            let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
            present(next, animated: true, completion: nil)
            
        }else{

            mapRouteManager.updateRoute(myLocation: location)
            addScore(locationDistance)
            addWalk(locationDistance)
            oldLocation = location
        }
    }
    
    func notification() {
        
        print("scheduled notification")
        /*
        //let coordinate = mapRouteManager.dummyCheckpoint.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: 37.332331,longitude: -122.031219)
        let radius = 100.0
        let identifier = "arrived"
        
        let content = UNMutableNotificationContent()
        content.title = "ARukeより通知"
        content.body = "イベントが発生!!"
        content.sound = UNNotificationSound.default()
        
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: identifier)

        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let locationRequest = UNNotificationRequest(identifier: identifier,
                                                    content: content,
                                                    trigger: locationTrigger)
        UNUserNotificationCenter.current().add(locationRequest, withCompletionHandler: nil)
        */
        let content = UNMutableNotificationContent()
        content.title = "ARukeより通知"
        content.body = "イベントが発生!!"
        content.sound = UNNotificationSound.default()
        
        // 1秒後に発火
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "oneSecond",
                                            content: content,
                                            trigger: trigger)
        
        // ローカル通知予約
        UNUserNotificationCenter.current().add(request, withCompletionHandler:nil)
        
    }
    
    func addScore(_ distanceInMeters: CLLocationDistance){
        scoreManager.setScore(distanceInMeters)
    }
    
    func addWalk(_ distanceInMeters: CLLocationDistance){
        distanceManager.setdistance(distanceInMeters)
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
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
