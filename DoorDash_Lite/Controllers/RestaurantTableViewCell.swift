//
//  RestaurantTableViewCell.swift
//  DoorDash_Lite
//
//  Created by chanikya on 6/4/18.
//  Copyright © 2018 chanikya. All rights reserved.
//

import UIKit

//Represents a prototype cell
class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var deliveryRateLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var favoriteIcon: UIImageView!
    var restaurantViewModel: RestaurantViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RestaurantTableViewCell.toggleFavorite(sender:)))
        self.favoriteIcon.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func toggleFavorite(sender: UITapGestureRecognizer? = nil) {
        if FavoritesViewModel.sharedInstance.isFavorite(restaurantViewModel) {
            FavoritesViewModel.sharedInstance.removeFavorite(restaurantViewModel)
            self.favoriteIcon.image = UIImage(named: "heart-outline-25")
        }
        else {
            FavoritesViewModel.sharedInstance.addRestaurant(restaurantViewModel)
            self.favoriteIcon.image = UIImage(named: "heart-filled-25")
        }
        
        NotificationCenter.default.post(name: Notification.Name("favoritesChanged"), object: nil)
    }
}
