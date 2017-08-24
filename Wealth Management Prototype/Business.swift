//
//  Business.swift
//  Wealth Management Prototype
//
//  Created by Nicholas Cameron on 2017-08-23.
//  Copyright © 2017 CameronComputing. All rights reserved.
//

import UIKit

enum positiveLevel {
    case angry
    case medium
    case happy
}

struct review {
    var reviewerName:String?
    var review:String!
    var createdTime:String?
    var positiveLevel: positiveLevel?
    var reviewerRating:Int?
}

class Business: NSObject {
    
    var title:String?
    var address:String?
    var rating:Double?
    var id:String?
    var image:UIImage?
    var review: review?
    
    init(title:String,address:String,id:String,rating:Double,image:UIImage) {
        self.title = title
        self.address = address
        self.id = id
        self.rating = rating
        self.image = image
    }
}
