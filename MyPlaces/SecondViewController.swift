//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 20/9/18.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate, ManagerPlacesObserver {

    @IBOutlet weak var m_map: MKMapView!
    let m_provider:ManagerPlaces = ManagerPlaces.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m_map.delegate = self
        
        m_provider.addObserver(object:self)
        addMarkers()
    }

    
    //Per esborrar tots els Markers o indicadors
    func removeMarkers() {
        let lista = self.m_map.annotations.filter {
            !($0 is MKUserLocation)
        }
        self.m_map.removeAnnotations(lista)
    }
    
    //afegir marcador
    func addMarkers() {
        let provider:ManagerPlaces = ManagerPlaces.shared()
        for i in 0..<provider.GetCount() {
            let p = provider.GetItemAt(position: i)
            let title:String = p.name
            let subtitle:String = p.description
            let id:String = p.id
            let lat:Double = p.location.latitude
            let lon:Double = p.location.longitude
            let annotation:MKMyPointAnnotation = MKMyPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat,longitude: lon),title: title, subtitle: subtitle, place_id: id)
            self.m_map.addAnnotation(annotation)
        }
    }
    
    //proporcionem al mapa una View a partir d'un MKMyPointAnnotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if let annotation = annotation as? MKMyPointAnnotation {
            let identifier = "CustomPinAnnotationView"
            var pinView: MKPinAnnotationView
            if let dequeuedView = self.m_map?.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier:identifier)
                pinView.canShowCallout = true
                pinView.calloutOffset = CGPoint(x: -5, y: 5)
                pinView.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
                pinView.setSelected(true,animated: true)
            }
            return pinView
        }
        return nil
    }
    
    //detectem la pulsació aal botó associat a un marker
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation:MKMyPointAnnotation = annotationView.annotation as! MKMyPointAnnotation
        
        // Mostrar el DetailController de ese Place
        let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        dc.place = m_provider.GetItemById(id: annotation.place_id)
        present(dc, animated: true, completion: nil)
    }
    
    //MARK: ManagerPlacesObserver
    func onPlacesChange() {
        removeMarkers()
        addMarkers()
    }
}

