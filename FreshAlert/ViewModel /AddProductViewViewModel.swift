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
        
        // after creating a new product, we first have to check any other product with same expiration date, if there are other products, we have to add it to the same groupedProduct or else, we have to create a new one .
        
        do {
            // Use Calendar to compare dates by day instead of exact timestamp
            let calendar = Calendar.current
            let newProductDayStart = calendar.startOfDay(for: newProduct.expirationDate)
            
            let descriptor = FetchDescriptor<GroupedProducts>()
            
            let allGroupedProducts = try modelContext.fetch(descriptor)
            
            // Filter manually by day since SwiftData predicates can't use Calendar operations
            let foundGroupedProducts = allGroupedProducts.filter { groupedProduct in
                calendar.startOfDay(for: groupedProduct.expirationDate) == newProductDayStart
            }
            
            // if we didnt find any groupedProducts, we create a new one
            if foundGroupedProducts.isEmpty {
                let newGroupedProducts = GroupedProducts(expirationDate: newProduct.expirationDate, products: [newProduct])
                modelContext.insert(newGroupedProducts)
                try modelContext.save()
            }
            // If there is a match, we just add it to the array of products
            else {
                guard let matchingGroupedProducts = foundGroupedProducts.first else {
                    throw NSError(domain: "AddProductError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to unwrap grouped products"])
                }
                matchingGroupedProducts.products.append(newProduct)
                try modelContext.save()
            }
            
        }
        catch{
            print(error.localizedDescription)
        }
        
        print("Created a new product and inserted it in the modelContext.")
    }
}
