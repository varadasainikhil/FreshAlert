//
//  SwiftUIView.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/29/25.
//

import SwiftData
import SwiftUI

struct CardView: View {
    @Environment(\.modelContext) var modelContext
    @State private var viewModel = CardViewViewModel()
    var product : Item
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(product.borderColor)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12))
            
            
            VStack{
                HStack{
                    Image("placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        Text(product.name)
                            .font(.title3.bold())
                            .lineLimit(2)
                        
                        Text(!product.productDescription.isEmpty ? product.productDescription : "")
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    if product.isExpired{
                        Button {
                            // delete the product
                            withAnimation {
                                viewModel.deleteProduct(modelContext: modelContext, product: product)
                            }
                        } label: {
                            Image(systemName: "trash.circle")
                                .font(.title)
                                .foregroundStyle(product.isUsed ? .green : .black)
                        }
                    }
                    else {
                        Button {
                            // mark the product as used and completed
                            product.markUsed()
                        } label: {
                            Image(systemName: product.isUsed ? "checkmark.circle.fill" : "checkmark.circle")
                                .font(.title)
                                .foregroundStyle(product.isUsed ? .green : .black)
                        }
                    }
                    
                    
                    
                }
                .padding(.horizontal)
                
                
            }
        }
        .frame(height: 100)
        
        
    }
}

#Preview {
    CardView(product: Item(barcode: "123456789", name: "Milk", productDescription: "Organic whole milk from the cows in the swiss", expirationDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()))
}
