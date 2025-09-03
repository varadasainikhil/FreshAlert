//
//  HomeView.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/25/25.
//
import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @State var showingAddProduct : Bool = false
    @Query(sort:\GroupedProducts.expirationDate) var groups : [GroupedProducts]

    var body: some View {
        ZStack{
            ScrollView{
                // create a card view that shows the product, then order it by expiration date
                ForEach(groups){group in
                    HStack{
                        // Change the date to the number of days left
                        // Also move the method for the number of days left from product to the groupProducts
                        Text("\(group.expirationDate.formatted(date : .abbreviated, time: .omitted))")
                        Spacer()
                    }
                    
                    ForEach(group.products){ product in
                        CardView(product: product)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        // Show the sheet for the addProductView
                        showingAddProduct = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .glassEffect()
                    }
                }
            }
            
        }
        .padding()
        .sheet(isPresented: $showingAddProduct) {
            AddProductView()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: GroupedProducts.self, configurations: config)
        let context = container.mainContext
        
        // Add sample products
        let today = Calendar.current.startOfDay(for: Date())
        let threeDaysFromNow = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 3, to: today) ?? today)
        let fiveDaysFromNow = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 5, to: today) ?? today)
        let twoDaysAgo = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -2, to: today) ?? today)
        
        let sampleGroups = [
            GroupedProducts(expirationDate: threeDaysFromNow, products: [
                Product(barcode: "123456789", name: "Milk", productDescription: "Organic whole milk", expirationDate: threeDaysFromNow),
                Product(barcode: "987654321", name: "Bread", productDescription: "Whole wheat bread", expirationDate: threeDaysFromNow)
            ]),
            GroupedProducts(expirationDate: fiveDaysFromNow, products: [
                Product(barcode: "456789123", name: "Eggs", productDescription: "Free-range eggs", expirationDate: fiveDaysFromNow),
                Product(barcode: "789123456", name: "Yogurt", productDescription: "Greek yogurt", expirationDate: fiveDaysFromNow)
            ]),
            GroupedProducts(expirationDate: twoDaysAgo, products: [
                Product(barcode: "987654322", name: "Bread", productDescription: "Whole wheat bread", expirationDate: twoDaysAgo),
                Product(barcode: "456789124", name: "Eggs", productDescription: "Free-range eggs", expirationDate: twoDaysAgo),
                Product(barcode: "789123457", name: "Yogurt", productDescription: "Greek yogurt", expirationDate: twoDaysAgo)
            ])
        ]
        
        
        for group in sampleGroups {
            context.insert(group)
        }

        
        return HomeView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview")
    }
}
