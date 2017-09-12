//
//  HomeModel.swift
//  Eatlink
//
//  Created by Andrew Woodward on 4/27/17.
//  Copyright © 2017 Sandland Apps. All rights reserved.
//

import Foundation

protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class HomeModel: NSObject, URLSessionDataDelegate {

    weak var delegate: HomeModelProtocol!
    
    var data : NSMutableData = NSMutableData()
    //var wholeString : String!
    let urlPath: String = "https://eatlinkdb.com/service.php"
    
    func downloadItems()
    {
        let url: NSURL = NSURL(string: urlPath)!
        var wholeString : String!
        let task = URLSession.shared.dataTask(with: url as URL)
        { (data, response, error) in
            //wholeString = String(data: data!, encoding: String.Encoding.utf8)!
            if error != nil { print(error ?? "Doesn't work") }
            else
            {
                if let usableData = data
                {
                    //print(usableData)
                    wholeString = String(data: usableData, encoding: String.Encoding.utf8)!
                    //print(wholeString)
                }
            }
        }
        print(wholeString)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        print("Data appendeing")
        self.data.append(data as Data);
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        if error != nil
        {
            print("failed to download data")
        }else {
        print("data downloaded")
            self.parseJSON()
        }
    }
    func parseJSON()
    {
        print("running parsejson")
        print(self.data.length)
        var jsonResult: NSMutableArray = NSMutableArray()
    
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSMutableArray
        } catch let error as NSError
        {
            print(error)
        }
        print(jsonResult.count)
        var jsonElement: NSDictionary = NSDictionary()
        let restaurants: NSMutableArray = NSMutableArray()
    
        for index in 0 ... (jsonResult.count-1)
        {
            jsonElement = jsonResult[index] as! NSDictionary
            let restaurant = RestaurantModel()
            
            if let name = jsonElement["Name"] as? String,
            let address = jsonElement["Address"] as? String,
            let x = jsonElement["Longitude"] as? Float,
            let y = jsonElement["Latitude"] as? Float
            {
                restaurant.name = name
                restaurant.address = address
                restaurant.x = x
                restaurant.y = y
            }
            
            restaurants.add(restaurant)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: restaurants)
    
        })
    }
}
