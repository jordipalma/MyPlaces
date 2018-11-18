//
//  ManagerLocation.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 16/10/2018.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import Foundation
import MapKit

class ManagerLocation: NSObject, CLLocationManagerDelegate{
    
    /*static var pos:Int = 0
    static var locations:[CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 41.387834, longitude: 2.170130),CLLocationCoordinate2D(latitude: 41.387834, longitude: 2.170130),CLLocationCoordinate2D(latitude: 41.391980, longitude: 2.196036)]
    */
    
    var m_locationManager:CLLocationManager!
    
    //******************************************
    // Singleton
    //
    //  Unique instance for all App
    //
    private static var sharedManagerLocation: ManagerLocation = {
        var singletonManager:ManagerLocation?
        
        if(singletonManager == nil) {
            singletonManager = ManagerLocation()
            singletonManager!.m_locationManager = CLLocationManager()
            singletonManager!.m_locationManager.delegate = singletonManager
            
            // Permitir updates en background
            singletonManager!.m_locationManager.allowsBackgroundLocationUpdates = true
            // Minima distancia para que detecte cambio de posición = 500 metros
            singletonManager!.m_locationManager.distanceFilter = 10
            // Que use la forma más optima para calcular la geolocalización.
            singletonManager!.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if (status == CLAuthorizationStatus.notDetermined){
                singletonManager!.m_locationManager.requestWhenInUseAuthorization()
                
            }else{
                singletonManager!.startLocation()
            }
            
        }
        return singletonManager!
    }()
    
    
    class func shared() -> ManagerLocation {
        return sharedManagerLocation
    }
    // ****************************************
    
    
    
    // Implementamos el método startLocation que arranca la obtención de coordenadas
    func startLocation() {
        self.m_locationManager.startUpdatingLocation()
    }
    
    
   
    //Per obtenir la posició des del CLLocationManager
    public func getLocation()->CLLocationCoordinate2D {
        return (self.m_locationManager!.location?.coordinate)!
    }
    


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locations)")
    }
    
    
    
    
    /*
    static func GetLocation()->CLLocationCoordinate2D
    {
        pos += 1
        if(pos>=locations.count) {
            pos = 0
        }
        
        return locations[pos]
        
    }
    */
    
    
}
