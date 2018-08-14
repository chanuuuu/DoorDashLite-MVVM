//
//  APIClientManager.swift
//  DoorDash_Lite
//
//  Created by chanikya on 6/4/18.
//  Copyright © 2018 chanikya. All rights reserved.
//

import UIKit
import AFNetworking

class APIClientManager: AFHTTPSessionManager {
    static let sharedInstance = APIClientManager(baseURL: URL(string: Constants.api_base_url))
    
    private init(baseURL url: URL!) {
        super.init(baseURL: url, sessionConfiguration: nil)
        
        responseSerializer = AFJSONResponseSerializer()
        requestSerializer = AFJSONRequestSerializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getRestaurants (lat: Double, lng : Double, completion: @escaping (_ result: [Restaurant]?, _ error:Error?) -> Void) {
        var restaurants = [Restaurant]()
        
        let addressParams = ["lat" : lat, "lng" : lng]
        self.get("store_search/", parameters: addressParams, progress: nil, success: {
            (task: URLSessionDataTask!, responseObject: Any?) in
            if let responseObject = responseObject {
                let restaurantList = responseObject as! [[String:Any]]
                restaurants = restaurantList.compactMap { dictionary in
                    return Restaurant(dictionary :dictionary)
                }
            }
            completion(restaurants, nil)
        }, failure: {
            (task: URLSessionDataTask?, error: Error) in
            completion(nil, error)
        })
    }
}
