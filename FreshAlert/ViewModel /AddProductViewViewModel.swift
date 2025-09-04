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
    var isLoading : Bool = false
    var errorMessage : String?
    var searchSuccess : Bool = false
    var isSearchButtonDisabled : Bool {
        return barcode.isEmpty || isLoading
    }
    
    // Usage
    
    
    func createProduct(modelContext : ModelContext){
        let newProduct = Item(barcode: barcode, name: name, productDescription: productDescription, expirationDate: expirationDate)
        
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
    
    func getAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let apiKey = plist["API_KEY"] as? String else {
            return nil
        }
        print(apiKey)
        return apiKey
    }
    
    func searchBarCode(barCode: String) async throws {
        
        // Reset state
        await MainActor.run {
            isLoading = true
            errorMessage = nil
            searchSuccess = false
        }
        
        print("Searching for barcode: \(barCode)")
        let apiKey = getAPIKey()
        
        // Validate API key
        guard let validApiKey = apiKey, !validApiKey.isEmpty else {
            print("❌ Error: API key is nil or empty")
            await MainActor.run {
                isLoading = false
                errorMessage = "API key not configured"
            }
            return
        }
        
        print("✅ API key retrieved successfully")
        
        guard var urlComponents = URLComponents(string: "https://api.barcodelookup.com/v3/products") else {
            print("❌ Error: Failed to create URL components")
            throw URLError(.badURL)
        }
        
        let queryItems : [URLQueryItem] = [
            URLQueryItem(name: "barcode", value: barCode),
            URLQueryItem(name: "formatted", value: "y"),
            URLQueryItem(name: "key", value: validApiKey)
        ]
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("❌ Error: Failed to create final URL")
            throw URLError(.badURL)
        }
        
        print("🌐 Making request to: \(url.absoluteString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Log response details
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Response status code: \(httpResponse.statusCode)")
            }
            
            print("📦 Received data size: \(data.count) bytes")
            
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(Response.self, from: data)
            
            print("✅ Successfully decoded response")
            print("📊 Number of products found: \(apiResponse.products.count)")
            
            if let firstProduct = apiResponse.products.first {
                print("🏷️ First product title: \(firstProduct.title)")
                await MainActor.run {
                    self.name = firstProduct.title
                    self.productDescription = firstProduct.description
                    self.isLoading = false
                    self.searchSuccess = true
                    self.errorMessage = nil
                }
                
            } else {
                print("⚠️ No products found in response")
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "No products found for this barcode"
                }
            }
            
        } catch let decodingError as DecodingError {
            print("❌ JSON Decoding Error: \(decodingError)")
            print("❌ Decoding Error Details: \(decodingError.localizedDescription)")
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = "Failed to parse product data"
            }
        } catch let urlError as URLError {
            print("❌ Network Error: \(urlError)")
            print("❌ Network Error Code: \(urlError.code.rawValue)")
            print("❌ Network Error Description: \(urlError.localizedDescription)")
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = "Network error: \(urlError.localizedDescription)"
            }
        } catch {
            print("❌ Unknown Error: \(error)")
            print("❌ Error Type: \(type(of: error))")
            print("❌ Error Description: \(error.localizedDescription)")
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = "Unexpected error: \(error.localizedDescription)"
            }
        }
    }
}
