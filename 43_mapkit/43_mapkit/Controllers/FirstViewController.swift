//
//  FirstViewController.swift
//  43_mapkit
//
//  Created by fedir on 11.04.2020.
//  Copyright © 2020 fedir. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationEnabled()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //checkLocationEnabled()
    }
    
    
    func checkLocationEnabled() {
        
        if CLLocationManager.locationServicesEnabled() {
            //если локейшнманагер включен то подгружаем настройки
           settingMapView()
            //запрашиваем показание геолокации 
            checkAutorisation()
            
        }else{
            //если не включен выбрасываем алерт
            alertAction(title: "У вас выключена служба геолокации", message: "Включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES")!)
        }
    }
    
    
    
    //MARK: - настройки локейшнманагера
    func settingMapView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //MARK: - проверка и запрос на показ местоположения
    func checkAutorisation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse :
            //когда используется
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied :
            alertAction(title: "вы запретили использование местоположения", message: "Включить?", url: URL(string:  UIApplication.openSettingsURLString))
            break
        case .restricted :
            break
        case.notDetermined :
            //запрос когда не определено при использовании приложения
            locationManager.requestWhenInUseAuthorization()
     
        }
    }

}


//MARK: - допфункции для локейшнманагера
extension FirstViewController: CLLocationManagerDelegate {


//определение геопозиции  по последним координатам и передача их карте
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters:  10000,longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //при смене авторизации вызываем функцию чекавторизейшн для локейшнманагера
        checkAutorisation()
    }

    
    
}


//MARK: - алерт как расширение для контроллера
extension FirstViewController {
    func alertAction(title: String,message: String?,url: URL?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Настроить", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancel =  UIAlertAction(title: "Exit", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert , animated: true, completion: nil)
        }

}
//"App-Prefs:root=LOCATION_SERVICES"
