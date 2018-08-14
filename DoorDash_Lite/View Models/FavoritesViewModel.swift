//
//  FavoriteViewModel.swift
//  DoorDash_Lite
//
//  Created by Chanikya on 6/4/18.
//  Copyright © 2018 chanikya. All rights reserved.
//

import UIKit

class FavoritesViewModel {
    fileprivate var restaurants: [RestaurantViewModel]
    
    static let sharedInstance = FavoritesViewModel()
    
    private init() {
        self.restaurants = [RestaurantViewModel]()
    }
    
    func addRestaurant(_ rest:RestaurantViewModel) {
        self.restaurants.append(rest)
    }
    
    func getFavorites() -> [RestaurantViewModel] {
        return self.restaurants
    }
    
    func removeFavorite(_ restaurant:RestaurantViewModel) {
        var removeIndex = -1
        for i in 0..<restaurants.count {
            if restaurants[i] == restaurant {
               removeIndex = i
               break
            }
        }
        self.restaurants.remove(at: removeIndex)
    }
    
    func isFavorite(_ restaurant:RestaurantViewModel) -> Bool {
        for item in restaurants {
            if item == restaurant {
                return true
            }
        }
        return false
    }
}
