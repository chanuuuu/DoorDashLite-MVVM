//
//  Restuarant.swift
//  DoorDash_Lite
//
//  Created by chanikya on 6/4/18.
//  Copyright © 2018 chanikya. All rights reserved.
//

import UIKit

class Restaurant: NSObject {
    var title:String?
    var cuisine:String?
    var delivery_rate:Int?
    var delivery_time:String?
    var cover_image_url:String?
    var id:String?
    
    init(title:String, cuisine:String, delivery_rate:Int, delivery_time:String, cover_image_url:String) {
        self.title = title
        self.cuisine = cuisine
        self.delivery_rate = delivery_rate
        self.delivery_time = delivery_time
        self.cover_image_url = cover_image_url
    }
    
    init?(dictionary :[String:Any]) {
        if let business = (dictionary["business"] as? [String : Any]) {
            self.title = business["name"] as? String
        }
        self.cuisine = dictionary["description"] as? String
        self.delivery_rate = dictionary["delivery_fee"] as? Int
        self.delivery_time = dictionary["status"] as? String
        self.cover_image_url = dictionary["cover_img_url"] as? String
        self.id = dictionary["id"] != nil ? "\(dictionary["id"]!)" : nil
    }
}
