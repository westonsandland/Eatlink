//
//  RestaurantModel.swift
//  Eatlink
//
//  Created by Weston Sandland on 4/27/17.
//  Copyright © 2017 Sandland Apps. All rights reserved.
//

import Foundation

class RestaurantModel: NSObject {

    var ID: Int?
    var name: String?
    var address: String?
    var x: Float? //longitude
    var y: Float? //latitude
    var culture: String?
    var type: Int?
    var cost: Int?
    var vegetarian: Int?
    var popularity: Int?
    
    override init()
    {
        
    }

    init(ID: Int, name: String, address: String, x: Float, y: Float, culture: String, type: Int, cost: Int, vegetarian: Int, popularity: Int)
    {
        self.ID = ID
        self.name = name
        self.address = address
        self.x = x
        self.y = y
        self.culture = culture
        self.type = type
        self.cost = cost
        self.vegetarian = vegetarian
        self.popularity = popularity
    }
    
    override var description: String
    {
        return "Name:  \(name ?? "none"), Address: \(address ?? "none"), Longitude: \(x ?? 0.0), Latitude: \(y ?? 0.0)"
    }
    
}
