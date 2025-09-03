//
//  GroupedProducts.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 9/2/25.
//

import Foundation
import SwiftData

@Model
class GroupedProducts{
    var expirationDate : Date = Date.now
    var products : [Product] = [Product]()
    
    init(expirationDate: Date, products: [Product]) {
        self.expirationDate = expirationDate
        self.products = products
    }
}
