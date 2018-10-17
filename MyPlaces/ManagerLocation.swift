//
//  ManagerLocation.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 16/10/2018.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import Foundation
import MapKit

// Dummy class
class ManagerLocation
{
    
    static var pos:Int = 0
    static var locations:[CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 41.387834, longitude: 2.170130),CLLocationCoordinate2D(latitude: 41.387834, longitude: 2.170130),CLLocationCoordinate2D(latitude: 41.391980, longitude: 2.196036)]
    
    
    static func GetLocation()->CLLocationCoordinate2D
    {
        pos += 1
        if(pos>=locations.count) {
            pos = 0
        }
        
        return locations[pos]
        
    }
    
    
}
