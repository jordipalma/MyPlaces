//
//  AppUtils.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 09/11/2018.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import Foundation
import UIKit

class AppUtils {

    //static let colorActiu = UIColor(red:0.80, green:0.40, blue:0.40, alpha:1.0)
    //Color principal: #ffc108
    //Color Secundari: #2196F3
    static let colorPrincipal = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
    static let colorSecundari = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
    
    
    static func drawCircle(size: CGSize, borderWith: CGFloat, fillColor: UIColor, borderColor: UIColor) -> UIImage {
        //let size = CGSize(width: 50, height: 50)
        //let borderWith = CGFloat(8)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: borderWith/2, y: borderWith/2, width: size.width - borderWith, height: size.height - borderWith)
            
            ctx.cgContext.setFillColor(fillColor.cgColor)
            ctx.cgContext.setStrokeColor(borderColor.cgColor)
            ctx.cgContext.setLineWidth(borderWith)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        return img
    }
    
}
