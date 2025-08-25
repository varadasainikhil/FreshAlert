//
//  product.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/25/25.
//

import Foundation
import SwiftData

@Model
class Product{
    var name : String
    var productDescription : String
    var dateAdded : Date
    var expirationDate : Date
    var productImage : Data?
    
    init(name: String, productDescription: String, expirationDate: Date, productImage: Data? = nil) {
        self.name = name
        self.productDescription = productDescription
        self.dateAdded = Date.now
        self.expirationDate = expirationDate
        self.productImage = productImage
    }
    
}
