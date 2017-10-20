//
//  MapController.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/10/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import GoogleMaps

class MapConroller: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    // WGS84の座標系での琉球大学の位置(緯度, 経度)
    let latitude = 26.247582
    let longitude = 127.765142
    let zoomLevel:Float = 17
    
    /** override vieDidLoad()
     * Viewの初期化,locationManagerの初期化. GoogleMapをMap.storyboardに表示する.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        initMapView()
        setLocateManager()
        ryukyuLocationMarker()
        
    }
    
    // mapViewの初期化. 最初は琉球大学を写すよう指定
    func initMapView(){
        // WGS84の座標系でカメラを設定. latitude: 緯度, longitude: 経度
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        
        // GoogleMapの初期化
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        // 地形の起伏と道路を表示するマップ
        mapView.mapType = GMSMapViewType.terrain
        view = mapView
        
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
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    

    
    // 琉球大学の場所にmarkerを設置できる関数
    func ryukyuLocationMarker(){
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        
        // マーカーの場所を表示. WGS84の座標系. latitude: 緯度, longitude: 経度
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Ryuukyuu"
        marker.snippet = "Okinawa"
        marker.map = mapView
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
        mapView.camera = camera
        
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
