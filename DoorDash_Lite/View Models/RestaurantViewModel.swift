//
//  RestaurantViewModel.swift
//  DoorDash_Lite
//
//  Created by chanikya on 6/4/18.
//  Copyright © 2018 chanikya. All rights reserved.
//

import Foundation

struct RestaurantListViewModel {
    var restaurants :[RestaurantViewModel] = [RestaurantViewModel]()
    init(restaurants :[RestaurantViewModel]) {
        self.restaurants = restaurants
    }
}

struct RestaurantViewModel {
    var title:String?
    var cuisine:String?
    var delivery_rate:String?
    var delivery_time:String?
    var cover_image_url:String?
    var id:String?
    
    init(restaurant :Restaurant) {
        self.title = restaurant.title
        self.cuisine = restaurant.cuisine
        self.delivery_time = restaurant.delivery_time
        self.cover_image_url = restaurant.cover_image_url
        if let delivery_fee = restaurant.delivery_rate, delivery_fee != 0 {
            self.delivery_rate = "$" + "\(delivery_fee)" + " delivery"
        }
        else {
            self.delivery_rate = "Free delivery"
        }
        self.id = restaurant.id
    }
}

extension RestaurantViewModel:Equatable {
    static func == (lhs: RestaurantViewModel, rhs: RestaurantViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}

