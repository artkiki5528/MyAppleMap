//
//  ViewController.swift
//  MyAppleMap
//
//  Created by lemonart on 2018/12/21.
//  Copyright © 2018 Lemon. All rights reserved.
//

import UIKit
import CoreLocation  //引入核心定位框架
import MapKit        //引入地圖框架
import SafariServices //引用瀏覽器框架
//以定位管理員進行定位，請遵循以下Step1~StepN的步驟
class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate
    //Step1. MKMapViewDelegate引入地圖協定,CLLocationManagerDelegate引入定位協定
    
{
    
    @IBOutlet weak var lblDirection: UILabel!    //方向
    @IBOutlet weak var lblAltitude: UILabel!     //高度
    @IBOutlet weak var lblLatitude: UILabel!     //緯度
    @IBOutlet weak var lblLongitude: UILabel!    //經度
    @IBOutlet weak var mapView: MKMapView!       //地圖
    
    
    //Step2.宣告定位管理員
    let  locationManager = CLLocationManager()
   //Step2-1.<增加>紀錄定位完成後的目前位置
    var currentLocation:CLLocation!
    // MARK : - ViewLifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Step3.由定位管理員要求持續定位授權 (需配合Info.plist設定共３種privacy Location)
        locationManager.requestAlwaysAuthorization()
        //Step4.指定定位管理員的相關代理事件，時坐在此類別
        locationManager.delegate = self
        //Step5.指定地圖協定方法時坐在此類別
        mapView.delegate = self
        //Step6.讓地圖顯示目前定位
        mapView.showsUserLocation = true
        
        //初始化大頭針陣列
        var arrAnnotation = [MKPointAnnotation]()
        
        
        //-------產生第一個大頭針-------------
        //初始化一個地圖的大頭針物件
        var annotation = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation.coordinate = CLLocationCoordinate2D(latitude: 24.137426, longitude: 121.275753)
        //設定大頭針的主副標題
        annotation.title = "武嶺"
        //將大頭針加入陣列
        annotation.subtitle = "南投縣仁愛鄉"
        //將大頭針加入陣列
        arrAnnotation.append(annotation)
        
        //-------產生第二個大頭針-------------
        annotation = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation.coordinate = CLLocationCoordinate2D(latitude: 23.510041, longitude: 120.700458)
        //設定大頭針的主副標題
        annotation.title = "奮起湖"
        //將大頭針加入陣列
        annotation.subtitle = "嘉義縣竹崎鄉"
        //將大頭針加入陣列
        arrAnnotation.append(annotation)
        
        
        
        
        //在地圖上標示大頭針陣列
        mapView.addAnnotations(arrAnnotation)
        
        //地圖以第一個大頭針為中心點顯示
        mapView.setCenter(arrAnnotation[0].coordinate, animated: false)
        
        
        //10-7.在地圖上標示區域(可以使用MKCircle繪製圓形圖層、MKPolygon繪製多邊形、MKPoly)
        var arrPoints = [CLLocationCoordinate2D]()
        //依序產生既個多邊形頂點座標
        arrPoints.append(CLLocationCoordinate2D(latitude: 24.2013, longitude: 120.5810))
        arrPoints.append(CLLocationCoordinate2D(latitude: 24.2044, longitude: 120.6559))
        arrPoints.append(CLLocationCoordinate2D(latitude: 24.1380, longitude: 120.6401))
        arrPoints.append(CLLocationCoordinate2D(latitude: 24.1424, longitude: 120.5783))
        //產生多邊形類別實體
        let polygon = MKPolygon(coordinates: &arrPoints, count: arrPoints.count)
        //將多邊形類別實體家在地圖上（注意：此時地圖上的多邊形為透明，需要透過代理事件才能執行）
        mapView.addOverlay(polygon)
        //移動地圖
        mapView.setCenter(arrPoints[0], animated: false)
        
    }
    //Step7.請定位管理員開始定位（注意：不可以在ViewDidLoad事件，請定位管理員開始定位）
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //Step7-1.開始定位取得目前位置（此時會呼叫Step8對應的代理事件 locationManager(_:didUpdateLocations:)
        locationManager.startUpdatingLocation()
        //Step7-2.開始偵測設備前段的方位（此時會呼叫Step9對應的代理事件 locationManager(_:didUpdateHeading:)
        locationManager.startUpdatingHeading()//開始偵測方位
    }
    
    
    // MARK : - Target Action
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
            case 1:  //衛星地圖
                mapView.mapType = MKMapType.satellite
            case 2:  //混合地圖（衛星＋路名）
                mapView.mapType = MKMapType.hybrid
            case 3:  //3D
                break
            default: //標準地圖
                mapView.mapType = MKMapType.standard
        }
        
        
        
    }
    
    
    
    
    
    
    
     // MARK: - 自訂函式
    //由CALLOUT面板上呼叫的對應函式
    @objc func buttonPress(_ sender: UIButton)
    {
        if sender.tag == 100
        {
            //準備一個網址物件(注意：不需在info.plist加上App Transport Security的Allow Arbitrary Loads -->假如網址是https就需要加)
            let url = URL(string: "http://www.taroko.gov.tw")
            let safari = SFSafariViewController(url: url!)//Safari瀏覽器不需要參考info.plist設定
            self.show(safari, sender: nil)
        }
    }
    // MARK: - CLLocationManagerDelegate
    //Step8. 定位管理員定位完成
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("定位完成：\(locations.first!.coordinate.latitude),\(locations[0].coordinate.longitude)")//.first和[0]是一樣的
        lblAltitude.text = String(format: "%.2f公尺", locations.first!.altitude)
        
        lblLatitude.text = String(format: "%.6f", locations.first!.coordinate.latitude)
        lblLongitude.text = String(format: "%.6f", locations.first!.coordinate.longitude)
        
    }
    //Step9. 已偵測到設備前端的方位
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
         print("磁性方位：\(newHeading.magneticHeading),真實方位\(newHeading.trueHeading)")
        //記憶方位值（0-360度,0為北方,90為東方，180為南方）
        let doubleDirection = newHeading.trueHeading
        if doubleDirection < 0
        {
            lblDirection.text = "未知"
        }
        else if doubleDirection >= 0 && doubleDirection < 46
        {
            lblDirection.text = "東北"
        }
        else if doubleDirection >= 46 && doubleDirection < 91
        {
            lblDirection.text = "東"
        }
        else if doubleDirection >= 91 && doubleDirection < 136
        {
            lblDirection.text = "東南"
        }
        else if doubleDirection >= 136 && doubleDirection < 181
        {
            lblDirection.text = "南"
        }
        else if doubleDirection >= 181 && doubleDirection < 226
        {
            lblDirection.text = "西南"
        }
        else if doubleDirection >= 226 && doubleDirection < 271
        {
            lblDirection.text = "西"
        }
        else if doubleDirection >= 271 && doubleDirection < 316
        {
            lblDirection.text = "西北"
        }
        else
        {
            lblDirection.text = "北"
        }
    }
    
    // MARK: - MKMapViewDelegate的處理函數
    /*
    //<方法一>10-3更改預設大頭針樣式
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //如果是使用者位置的標示時
        if annotation is MKUserLocation
        {
            //不要更改大頭針樣式
            return nil
        }
        //以Pin當作ID來取得大頭針樣式（並轉型為預設大頭針樣式）
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") as? MKPinAnnotationView
        //如果無法以Pin當作ID來取得可回收的大頭針樣式
        if annView == nil
        {
            //新作一個以Pin為ID的大頭針樣式
            annView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        if annotation.title == "武嶺"
        {
            //將大頭針換成綠色
            annView?.pinTintColor = UIColor.green
        }
        else if annotation.title == "奮起湖"
        {
            //將大頭針換成橘色
            annView?.pinTintColor = UIColor.orange
        }
        //允許大頭針點選時，有彈出視窗顯示訊息
        annView?.canShowCallout = true
        //回傳指定的樣式
        return annView
    }
*/
    //<方法二>10-4將大頭針改為自定圖片樣式
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //如果是使用者位置的標示時
        if annotation is MKUserLocation
        {
            //不要更改大頭針樣式
            return nil
        }
        //以Pin當作ID來取得大頭針的一般樣式（❗️注意：不要轉型為預設大頭針樣式）
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") //as? MKPinAnnotationView
        //如果無法以Pin當作ID來取得可回收的大頭針樣式
        if annView == nil
        {
            //新作一個以Pin為ID的大頭針樣式
            annView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        if annotation.title == "武嶺"
        {
            //0.更動大頭針本身樣式，１～３更動Callout面板樣式
            //0.將大頭針換成咖啡杯
            annView?.image = UIImage(named: "coffee_to_go.png")
            //1.更動Callout面板的左側視圖
            let imageView = UIImageView(image: UIImage(named: "wuling.jpg"))
           /*
            imageView.frame = annView!.frame
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
 */
            annView?.leftCalloutAccessoryView = imageView

            //2.準備UILabel以呈現經緯度資訊
            let label = UILabel()
            label.numberOfLines = 2
            label.text = "緯度：\(annotation.coordinate.latitude)\n經度：\(annotation.coordinate.longitude)\n"
            //將呈現經緯度資訊的UILabel呈現在callout面板的詳細資料視圖上
            annView?.detailCalloutAccessoryView = label
            //3.準備一個按鈕
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            button.tag = 100
            button.addTarget(self, action: #selector(buttonPress(_:)), for: UIControl.Event.touchUpInside)
            //在Callout面板的右側視圖顯示一個按鈕
            annView?.rightCalloutAccessoryView = button
            
        }
        else if annotation.title == "奮起湖"
        {
            //將大頭針換成咖啡杯
            annView?.image = UIImage(named: "coffee_to_go.png")
        }
        //允許大頭針點選時，有彈出視窗顯示訊息
        annView?.canShowCallout = true
        //回傳指定的樣式
        return annView
    }
    // MARK : -
    //回傳地圖塗層的渲染樣式
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        //取得塗層目前的渲染樣式(一開始為透明)
        let render = MKPolygonRenderer(overlay: overlay)
        if overlay is MKPolygon
        {
            //設定範圍內的填滿顏色（半透明）
            render.fillColor = UIColor.red.withAlphaComponent(0.2)
            //設定畫筆顏色（邊框顏色）
            render.strokeColor = UIColor.red.withAlphaComponent(0.7)
            //設定線條粗細
            render.lineWidth = 3
        }
        
        return render
    }
    
    
    
    
    
}

