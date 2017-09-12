//
//  ViewController.swift
//  Eatlink
//
//  Created by Weston Sandland on 4/16/17.
//  Copyright © 2017 Sandland Apps. All rights reserved.

import UIKit
import CoreLocation

var idealRestaurant = [-1, -1, -1, -1, -1, -1]
var userLocation = [0.0, 0.0]
var scoreIDs = ["", "", ""]
var allRestaurants = [[String]]()
var topRestaurants = [[String]]()
var list5 : [String] = []
var firstLoad = true
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocol {

    var feedItems: NSArray = NSArray()
    var selectedLocation : RestaurantModel = RestaurantModel()
    var arrTemp : [String] = Array(repeating: "", count: 10)
    let locationManager = CLLocationManager()
    var primaryColor = #colorLiteral(red: 0.9843137255, green: 0.5137254902, blue: 0.3058823529, alpha: 1)
    var secondaryColor = #colorLiteral(red: 0.2549019608, green: 0.2509803922, blue: 0.2588235294, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        topRestaurants = Array(repeating: Array(repeating: "0", count: 11), count: 3)
        if(firstLoad){
        if(CLLocationManager.locationServicesEnabled()){
            self.locationManager.requestAlwaysAuthorization()}
        let restaurantString = "9^0^0^33.1051^-96.8236^1^American^0^3001 Dallas Pkwy^Jamba Juice#11^0^0^33.1722^-96.7335^1^Sandwich^0^11501 Custer Rd^Subway#12^0^0^33.173^-96.7337^1^Coffee^0^11625 Custer Rd^Starbucks#13^1^1^33.1721^-96.7337^0^Italian^0^11477 Custer Rd^Rosati's Pizza#14^1^2^33.1724^-96.7345^0^Japanese^0^11501 Custer Rd^Madai Sushi#15^0^0^33.1737^-96.7343^0^American^0^16125 Eldorado Pkwy^McDonald's#16^0^0^33.1754^-96.7335^0^Chicken^0^12055 Custer Rd^Chicken Express#17^1^1^33.175^-96.7345^1^Mediterranean^0^16120 Eldorado Pkwy^Zoes Kitchen#18^0^0^33.175^-96.7343^1^Smoothie^0^16120 Eldorado Pkwy^Smoothie King#19^2^1^33.1749^-96.7358^0^Chinese^0^15910 Eldorado Pkwy^Green Asian Bistro#20^2^1^33.1754^-96.7357^0^Southern^0^15922 Eldorado Pkwy^Barn Light Eatery#21^0^1^33.1755^-96.8412^0^Chicken^0^5220 Eldorado Pkwy^Raising Cane's#22^1^1^33.1757^-96.8421^1^Sandwich^0^5110 El Dorado Parkway^Jersey Mike's#23^1^1^33.1547^-96.8046^0^Barbecue^0^9225 Preston Rd^Hutchins BBQ#24^0^0^33.1546^-96.8039^0^Southern^0^9185 Preston Rd^Popeyes Louisiana Kitchen#25^0^0^33.1549^-96.8039^0^Chinese^0^9285 Preston Rd^Golden Moon Chinese Restaurant#26^1^1^33.1537^-96.8038^0^Asian^0^9101 Preston Rd^Aiya#27^2^1^33.1573^-96.804^0^American^0^9741 Preston Rd^Frisco Star Cafe#28^2^1^33.1552^-96.8043^0^Bar & Grill^0^9305 Preston Rd^Rockin S Bar & Grill"
        arrTemp = restaurantString.characters.split{$0 == "#"}.map(String.init)
        allRestaurants = Array(repeating: Array(repeating: "", count: 10), count: arrTemp.count)
        for i in 0...arrTemp.count-1
        {
            allRestaurants[i] = arrTemp[i].characters.split{$0 == "^"}.map(String.init)
            if(!list5.contains(allRestaurants[i][6]))
            {
                list5.append(allRestaurants[i][6])
            }
        }
            firstLoad = false
        }
        findTopRestaurants()
        
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
    }

    var preferredList = [""]
    let defList = ["INCORRECT_TAG"]
    let list = ["Quick Serve", "Takeout", "Sit Down"]
    let list2 = ["$", "$$", "$$$"]
    let list3 = ["Must be close", "Preferred close", "Distance doesn't matter"]
    let list4 = ["Vegetarian", "Non-vegetarian"]
    var colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    let cell2 = UITableViewCell()
    
    @IBOutlet weak var rowLabel: UILabel!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView.tag == 1) //type
        {
            preferredList = list
            return list.count
        }
        else if(tableView.tag == 2) //cost
        {
            preferredList = list2
            return list2.count
        }
        else if(tableView.tag == 3) //location
        {
            preferredList = list3
            return list3.count
        }
        else if(tableView.tag == 4) //vegetarian
        {
            preferredList = list4
            return list4.count
        }
        else if(tableView.tag == 5) //cuisine
        {
            preferredList = list5
            return list5.count
        }
        else if(tableView.tag == -1)
        {
            return topRestaurants.count
        }
        else
        {
            preferredList = defList
            return defList.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = secondaryColor
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let item: RestaurantModel = feedItems[indexPath.row] as! RestaurantModel
        //print(feedItems.count)
        tableView.backgroundColor = secondaryColor
        if(tableView.tag == -1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopRestaurantsTableViewCell
            cell.name.text = topRestaurants[indexPath.row][9]
            cell.cuisine.text = topRestaurants[indexPath.row][6]
            cell.address.text = topRestaurants[indexPath.row][8]
            cell.distance.text = String(Float((self.locationManager.location?.distance(from: CLLocation.init(latitude: CLLocationDegrees.init(exactly: Float(topRestaurants[indexPath.row][3])!)!, longitude: CLLocationDegrees.init(exactly: Float(topRestaurants[indexPath.row][4])!)!)))! * 0.000621371)) + " mi"
            cell.name.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.cuisine.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.address.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.distance.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            return cell
        }
        else
        {
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = preferredList[indexPath.row]
            while(colors.count < preferredList.count)
            {
                colors.append(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            }
            cell.textLabel?.textColor = colors[indexPath.row]
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //let cell = tableView.cellForRow(at: indexPath)
        ///TODO: ADD FIND MY RESTAURANT SELECTION --> Maps App
        if(tableView.tag > 0)
        {
        var colorcounter = 0
        while colorcounter < colors.count {
            colors[colorcounter] = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            colorcounter += 1
        }
        colors[indexPath[1]] = primaryColor
        idealRestaurant[tableView.tag-1] = indexPath[1]
        //print(idealRestaurant.description)
        }
        tableView.reloadData()
    }

    func findTopRestaurants()
    {
        scoreIDs = ["", "", ""]
        var score : Float
        for i in 0...allRestaurants.count-1
        {
            var tempRestaurant = [String]()
            var placeholder = [String]()
            score = 1000
            //print(idealRestaurant[4])
            //print( Int(allRestaurants[i][1])!)
            if(idealRestaurant[0] == Int(allRestaurants[i][1])!) //type
            {
                //print("type matched")
                score += 50
            }
            if(idealRestaurant[1] == Int(allRestaurants[i][2])!) //cost
            {
                //print("Cost matches")
                score += 50
            }
            if(CLLocationManager.locationServicesEnabled() && idealRestaurant[2] >= 0) //location
            {
                score -= Float((self.locationManager.location?.distance(from: CLLocation.init(latitude: CLLocationDegrees.init(exactly: Float(allRestaurants[i][3])!)!, longitude: CLLocationDegrees.init(exactly: Float(allRestaurants[i][4])!)!)))!) * 0.000621371 * Float(2-idealRestaurant[2]) * 30
            }
            if(idealRestaurant[3] == Int(allRestaurants[i][5])!) //vegetarian
            {
                //print("vegetated")
                score += 40
            }
            if(idealRestaurant[4] >= 0 && list5[idealRestaurant[4]] == allRestaurants[i][6]) //cuisine
            {
                //print("cuisine matched")
                score += 180
            }
            tempRestaurant = allRestaurants[i]
            tempRestaurant.append(String(score))
            for j in 0...topRestaurants.count-1
            {
                if((Float(tempRestaurant[10])! > Float(topRestaurants[j][10])!) && !scoreIDs.contains(tempRestaurant[0]))
                {
                    scoreIDs[j] = tempRestaurant[0]
                    placeholder = topRestaurants[j]
                    topRestaurants[j] = tempRestaurant
                    tempRestaurant = placeholder
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

