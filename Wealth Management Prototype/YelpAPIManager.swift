//
//  YelpAPIManager.swift
//  Wealth Management Prototype
//
//  Created by Nicholas Cameron on 2017-08-21.
//  Copyright © 2017 CameronComputing. All rights reserved.
//

import UIKit

class YelpAPIManager: NSObject {

//MARK: Keyword Search/Parser
    
    //This method makes a call to yelp API and pulls back a json object based on the term provided by user.
    /// - parameter keyword: The keyword to search yelp API for.
    /// - parameter completion: escaping closer to see when call finishes.
    class func getYelpKeywordSearchResult(keyword:String,completion: @escaping (_ statusCode: Int) -> Void ){
        let urlWithParameters = NSURLComponents(string: Constants.yelpInitialURL + Constants.yelpSearchURL)!
        var queryDetails: [String: String] = [:]
        
        queryDetails["term"] = keyword
        queryDetails["location"] = "toronto"
        queryDetails["limit"] = "10"
        var items = [URLQueryItem]()
        
        for (key,value) in queryDetails {
            items.append(URLQueryItem(name: key, value: value))
        }
        
        items = items.filter{!$0.name.isEmpty}
        
        if !items.isEmpty {
            urlWithParameters.queryItems = items
        }
        
        var header: [String: Any] = [:]
        header["Authorization"] = Constants.ACCESS_TOKEN
        
        var urlRequest = URLRequest(url: urlWithParameters.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        urlRequest.allHTTPHeaderFields = header as? [String : String]

        let dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
       
            if error != nil{
            }else{
                _ = response as? HTTPURLResponse
                if let data = data{
                    if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]{
                        _ = self.parseSearchResults(jsonResponse!, completion: { (code) in
                        completion(code)
                            return
                        })
                    }
                }
            }
        })
        
        dataTask.resume()
    }

    
    //This method parses the search results and saves it as a business object array
   static func parseSearchResults(_ json:[String:Any],completion: @escaping (_ statusCode: Int) -> Void ){
    //resets the results
    AppController.shared.Businesses = [Business]()
        if let businesses = json["businesses"] as? [[String:Any]]{
                for business in businesses{
                    if let businessName = business["name"] as? String,
                    let addresses = business["location"] as? [String:Any],
                    let id = business["id"] as? String, let rating = business["rating"] as? Double,let imageUrl = business["image_url"] as? String{
                            let url = URL(string: imageUrl)
                            var image = UIImage()
                            if url != nil{
                                let data = try? Data(contentsOf: url!)
                                image = UIImage(data: data!)!
                            }
                            let address1 = addresses["address1"] as? String
                            AppController.shared.Businesses.append(Business(title: businessName, address: address1!, id: id, rating: rating, image: image))
                    }
                }
        }
     if AppController.shared.Businesses.count > 0{
        completion(200)

     }else{
        completion(500)

     }
 return
}
    
    
 //MARK: Review Service Call/Parser
    
    ///This method does the business review call and parses it into the passes object
    /// - parameter business: The business object to search yelp API reviews.
    /// - parameter completion: escaping closer to see when call finishes.

    class func getYelpReviewResult(business:Business,completion: @escaping (_ statusCode: Int) -> Void ){
        let urlWithParameters = NSURLComponents(string: Constants.yelpInitialURL + business.id! + Constants.yelpReviewsURL)!
        var queryDetails: [String: String] = [:]
        
        queryDetails["location"] = "toronto"
        var items = [URLQueryItem]()
        
        for (key,value) in queryDetails {
            items.append(URLQueryItem(name: key, value: value))
        }
        
        items = items.filter{!$0.name.isEmpty}
        
        if !items.isEmpty {
            urlWithParameters.queryItems = items
        }
        
        var header: [String: Any] = [:]
        header["Authorization"] = Constants.ACCESS_TOKEN
        
        var urlRequest = URLRequest(url: urlWithParameters.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        urlRequest.allHTTPHeaderFields = header as? [String : String]
        
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if error != nil{
            }else{
                _ = response as? HTTPURLResponse
                if let data = data{
                    if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]{
                        _ = self.parseReviewResults(jsonResponse!,business:business, completion: { (code) in
                            completion(code)
                            return
                        })
                    }
                }
            }
        })
        
        dataTask.resume()
    }

    
    ///This method parses the yelp business review json
    static func parseReviewResults(_ json:[String:Any],business:Business,completion: @escaping (_ statusCode: Int) -> Void ){
        var mostRecentReview = review()
        if let reviews = json["reviews"] as? [[String:Any]]{
            for review in reviews{
                if let user = review["user"] as? [String:Any]{
                    mostRecentReview.reviewerName = user["name"] as? String
                }
                if let review = review["text"] as? String {
                    mostRecentReview.review = review
                }
                if let rating = review["rating"] as? Int{
                    mostRecentReview.reviewerRating = rating
                    if rating <= 2{
                       mostRecentReview.positiveLevel = positiveLevel.angry
                    }else if rating <= 4{
                        mostRecentReview.positiveLevel = positiveLevel.medium
                    }else{
                        mostRecentReview.positiveLevel = positiveLevel.happy
                    }
                }
                if let createdTime = review["time_created"] as? String{
                    if mostRecentReview.createdTime != nil{
                        let dateOriginalFormat = DateFormatter()
                            dateOriginalFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            if let date = dateOriginalFormat.date(from: createdTime) {
                               if let mostRecentDate = dateOriginalFormat.date(from: mostRecentReview.createdTime!) {
                                if (date < mostRecentDate){
                                    mostRecentReview.createdTime = createdTime
                                }
                            }
                        }
                    }else{
                        mostRecentReview.createdTime = createdTime
                    }
                }
            }
        }
        business.review = mostRecentReview
        completion(200)
        return
    }

    
    
    
}
