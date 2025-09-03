//
//  AddProductView.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/26/25.
//

import SwiftData
import SwiftUI

struct AddProductView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var viewModel = AddProductViewViewModel()
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    CustomTextFieldWithHeading(heading: "Barcode", textToShow: "Enter the Product Barcode", variabletoBind: $viewModel.barcode)
                }
                
                Section{
                    CustomTextFieldWithHeading(heading: "Product Name", textToShow: "Enter the Product Name", variabletoBind: $viewModel.name)
                    
                    CustomTextFieldWithHeading(heading: "Description", textToShow: "Enter Product Description", variabletoBind: $viewModel.productDescription)
                    
                    DatePicker("Enter the Expiration Date", selection: $viewModel.expirationDate, displayedComponents: [.date])
                        .datePickerStyle(.wheel)
                }
                .listRowSeparator(.hidden)
                
            }
            .navigationTitle("Add a Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // save the product and dismiss the sheet
                        viewModel.createProduct(modelContext: modelContext)
                        dismiss()
                        
                    } label: {
                        Image(systemName: "checkmark")
                    }

                }
            }
            
        }
    }
}

#Preview {
    AddProductView()
}
