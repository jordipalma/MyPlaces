//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 20/9/18.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController, ManagerPlacesObserver {

    let m_provider:ManagerPlaces = ManagerPlaces.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view: UITableView = (self.view as? UITableView)!;
        view.delegate = self
        view.dataSource = self
        
        //afegim el propi controlador a la llista d'observadors.
        //let manager = ManagerPlaces.shared()
        m_provider.addObserver(object:self)

    }


    
    
    // **************************************************
    // TABLE PROTOCOL
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Número de elmentos del manager
        return m_provider.GetCount()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Sirve para indicar subsecciones de la lista. En nuestro caso devolvemos // 1 porque no hay subsecciones.
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Detectar pulsación en un elemento.
        
        let p = m_provider.GetItemAt(position: indexPath.row)
        
        print("Element seleccionat a la llista: " + p.name)
        
        let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        dc.place = p
        present(dc, animated: true, completion: nil)
        
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Devolver la altura de la fila situada en una posición determinada.
        return 100 //De moment retornem sempre la mateix aalçada
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // devolver una instancia de la clase UITableViewCell que pinte la fila
        //seleccionada.
        var cell: UITableViewCell
        cell = UITableViewCell()
        
        let wt: CGFloat = tableView.bounds.size.width

        let p = m_provider.GetItemAt(position: indexPath.row)
        
        
        // Add subviews to cell
        // UILabel and UIImageView
        
        var label: UILabel
        label = UILabel(frame: CGRect(x:100,y:10,width:wt,height:40))
        let fuente: UIFont = UIFont(name: "Arial", size: 22)!
        label.font = fuente
        label.numberOfLines = 4
        label.text = p.name
        label.sizeToFit()
        cell.contentView.addSubview(label)

        //agafem la imatge del FileSystem.
        //let imageIcon: UIImageView = UIImageView(image: UIImage(data: p.image!))
        var image = UIImage(contentsOfFile: m_provider.GetPathImage(p: p))
        if image == nil {
            image = UIImage(named: "placeholder")
        }
        
        let imageIcon = UIImageView(image: image)
        
        imageIcon.frame = CGRect(x:5, y:5, width:90, height:90)
        cell.contentView.addSubview(imageIcon)
        
        return cell
    }
    
    //
    
    func onPlacesChange() {
        let view: UITableView = (self.view as? UITableView)!
        view.reloadData()
    }

}
