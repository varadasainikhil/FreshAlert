//
//  File.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/26/25.
//

import Foundation
import SwiftData

@Observable
class AddProductViewViewModel {
    var barcode : String = ""
    var name : String = ""
    var productDescription : String = ""
    var expirationDate : Date = Date.now.addingTimeInterval(86400)
    var productImage : Data?
    
    func createProduct(modelContext : ModelContext){
        let newProduct = Product(barcode: barcode, name: name, productDescription: productDescription, expirationDate: expirationDate)
        
        modelContext.insert(newProduct)
        try? modelContext.save()
    }
}
