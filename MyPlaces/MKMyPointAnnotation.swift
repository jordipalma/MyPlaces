//
//  MKMyPointAnnotation.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 07/11/2018.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class MKMyPointAnnotation: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    var place_id:String = ""
    var image: UIImage?
    init(coordinate: CLLocationCoordinate2D, title:String, subtitle:String, place_id:String, image:UIImage) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.place_id = place_id
        self.image = image
    }
}
