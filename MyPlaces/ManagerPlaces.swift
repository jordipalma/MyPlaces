//
//  ManagerPlaces.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 20/9/18.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import Foundation


class ManagerPlaces{
    
    var places : [Place] = []
    
    init(){
        
        
    }
    
    //******************************************
     // Singleton
     //
     //  Unique instance for all App
     //
     private static var sharedManagerPlaces: ManagerPlaces = {
         var singletonManager : ManagerPlaces
     
         singletonManager = ManagerPlaces()
     
         return singletonManager
     }()
 
 
     class func shared() -> ManagerPlaces {
        return sharedManagerPlaces
     }
     // ****************************************
    
    
    
    //per afegir un place
    func append(_ value:Place){
        places.append(value)
    }

    //compta el número de Place
    func GetCount() -> Int{
        return places.count
    }
    //obtenir un Place per posició
    func GetItemAt(position:Int) -> Place{
        return places[position]
    }
    
    //obtenir un Place per id
    func GetItemById(id:String) -> Place{
        return places.filter { $0.id == id }[0]
    }
    
    //eliminar un place per id
    func remove(_ value:Place){
        self.places = places.filter { $0.id != value.id }
    }
}
