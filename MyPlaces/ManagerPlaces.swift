//
//  ManagerPlaces.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 20/9/18.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import Foundation


class ManagerPlaces: Codable{
    
    var places : [Place] = []
    
    //patró observador definit al protocol del final d'aquest fitxer.
    //llista d'observadors.
    public var m_observers = Array<ManagerPlacesObserver>()
    
    enum CodingKeys: String, CodingKey {
        case places
    }
    enum PlacesTypeKey: CodingKey {
        case type
    }
    
    init(){
        
        
    }
    
    //******************************************
     // Singleton
     //
     //  Unique instance for all App
     //
     private static var sharedManagerPlaces: ManagerPlaces = {
        var singletonManager : ManagerPlaces?
        singletonManager = load()
        if(singletonManager == nil) {
            singletonManager = ManagerPlaces()
        }
        return singletonManager!
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
    
    //eliminar un place
    func remove(_ value:Place){
        self.places = places.filter { $0.id != value.id }
    }

    
    func GetPathImage(p:Place)->String {
        let r = FileSystem.GetPathImage(id:p.id)
        return r;
    }

    
    //mètodes per treballar amb el patró observer
    //afegim l'Objecte a la llista d'observadors
    public func addObserver(object:ManagerPlacesObserver){
        m_observers.append(object)
    }
    
    public func updateObservers(){
        //recorrem la llista d'observers i executem el mètode onPlacesChange
        m_observers.forEach{ ob in
            ob.onPlacesChange()
        }
        self.store()
    }
    
    func store() {
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            for place in places {
                if(place.image != nil){
                    FileSystem.WriteData(id:place.id,image:place.image!)
                    print(GetPathImage(p: place))
                    place.image = nil;
                }
            }
            FileSystem.Write(data: String(data: data, encoding: .utf8)!)
        }
        catch{
        }
    }
    
    static func load() -> ManagerPlaces? {
        var resul:ManagerPlaces? = nil
        let data_str = FileSystem.Read()
        if(data_str != "") {
            do{
                let decoder = JSONDecoder()
                let data:Data = Data(data_str.utf8)
                resul = try decoder.decode(ManagerPlaces.self,from: data)
            }
            catch{
                resul = nil
            }
        }
        return resul
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(places, forKey: .places)
    }
    func decode(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        places = [Place]()
        var objectsArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.places)
        var tmp_array = objectsArrayForType
        while(!objectsArrayForType.isAtEnd) {
            let object = try objectsArrayForType.nestedContainer(keyedBy: PlacesTypeKey.self)
            let type = try object.decode(Place.PlacesTypes.self, forKey: PlacesTypeKey.type)
            switch type {
                case Place.PlacesTypes.TouristicPlace:
                    self.append(try tmp_array.decode(PlaceTourist.self))
                default :
                    self.append(try tmp_array.decode(Place.self))
            }
        }
    }
    
}


protocol ManagerPlacesObserver {
    func onPlacesChange()
}
