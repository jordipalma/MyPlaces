//
//  Place.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 20/9/18.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import MapKit


class Place{
    enum PlacesTypes {
        case GenericPlace
        case TouristicPlace
    }


    var id: String = ""
    var type: PlacesTypes = .GenericPlace
    var name: String = ""
    var description: String = ""
    var location: CLLocationCoordinate2D!
    var image:Data? = nil

    init()
    {
        
        
    }
    
    init(name:String,description:String,image_in:Data?) {
        self.id = UUID().uuidString
    }
    
    init(type:PlacesTypes,name:String,description:String,image_in:Data?){
        self.id = UUID().uuidString
    }
}
