//
//  FileSystem.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 19/10/2018.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import Foundation


class FileSystem
{
    class func GetPathBase() -> String
    {
        
        let pathBase:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        do{
            let fileManager:FileManager = FileManager()
            
            try fileManager.createDirectory(atPath: pathBase, withIntermediateDirectories: true, attributes: nil)
        }
        catch
        {
            
            
        }
        
        return pathBase
    }
    
    class func GetPath() -> URL
    {
        // Get App Document directory
        let pathBase:String = GetPathBase()
        
        
        let pathBD:String = pathBase + "/database.txt"
        
        let url:URL = URL(fileURLWithPath: pathBD)
        
        return url
    }
    
    class func Read() -> String
    {
        var data:String = ""
        
        
        do {
            data = try String(contentsOf: GetPath(), encoding: .utf8)
        }
        catch {
            //************ error handling
            
        }
        
        return data
    }
    
    
    class func GetPathImage(id:String)->String
    {
        return GetPathBase()+"/"+id;
        
    }
    
    class func WriteData(id:String,image:Data)
    {
        do {
            try image.write(to: URL(fileURLWithPath:GetPathBase()+"/"+id))
        }
        catch {
            //************ error handling
        }
        
        
    }
    
    
    class func Write(data:String)
    {
        do {
            try data.write(to: GetPath(), atomically: false, encoding: .utf8)
        }
        catch {
            //************ error handling
        }
        
        
    }
    
}
