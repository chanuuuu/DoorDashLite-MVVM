//
//  SecondViewController.swift
//  DoorDash_Lite
//
//  Created by chanikya on 6/4/18.
//  Copyright © 2018 chanikya. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel :RestaurantListViewModel = RestaurantListViewModel(restaurants: [])  {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:Constants.primary_color]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.title = "Favorites"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.favoritesChanged(notification:)), name: Notification.Name("favoritesChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel = RestaurantListViewModel(restaurants:FavoritesViewModel.sharedInstance.getFavorites())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("favoritesChanged"), object: nil)
    }
    
    @objc func favoritesChanged(notification: NSNotification){
        self.viewModel = RestaurantListViewModel(restaurants:FavoritesViewModel.sharedInstance.getFavorites())
    }
}

extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel.restaurants.count
        if count == 0 {
            // Add info label when no restaurants are available
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No restaurants available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        else {
            tableView.backgroundView = nil
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantTableViewCell
        let rest = self.viewModel.restaurants[indexPath.row]
        
        cell.titleLabel.text = rest.title
        cell.cuisineLabel.text = rest.cuisine
        cell.deliveryRateLabel.text = rest.delivery_rate
        cell.deliveryTimeLabel.text = rest.delivery_time
        if let image_url = rest.cover_image_url {
            cell.restaurantIcon.sd_setImage(with: URL(string: image_url), placeholderImage: UIImage(named: "restaurant-placeholder"))
        }
        cell.restaurantViewModel = rest
        if FavoritesViewModel.sharedInstance.isFavorite(rest) {
            cell.favoriteIcon.image = UIImage(named: "heart-filled-25")
        }
        else {
            cell.favoriteIcon.image = UIImage(named: "heart-outline-25")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // todo
    }
}

