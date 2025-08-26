//
//  HomeView.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/25/25.
//

import SwiftUI

struct HomeView: View {
    @State var showingAddProduct : Bool = false
    var body: some View {
        ZStack{
            VStack{
                
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        // show the add product view as a sheet
                        showingAddProduct = true
                    } label: {
                        ZStack{
                            Circle()
                                .glassEffect(in: .circle)
                            
                            Image(systemName: "plus")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                            
                        }
                        .frame(width: 40)
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
    HomeView()
}
