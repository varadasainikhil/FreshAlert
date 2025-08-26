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
    var barcode : String = ""
    var name : String = ""
    var productDescription : String = ""
    var dateAdded : Date = Date.now
    var expirationDate : Date = Date.now
    var productImage : Data?
    
    init(barcode: String , name: String, productDescription: String, expirationDate: Date, productImage: Data? = nil) {
        self.barcode = barcode
        self.name = name
        self.productDescription = productDescription
        self.dateAdded = .now
        self.expirationDate = expirationDate
        self.productImage = productImage
    }
    
}
