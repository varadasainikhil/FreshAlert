//
//  ContentView.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/21/25.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel : SignUpViewViewModel
    var body: some View {
        VStack {
            Button{
                Task{
                    viewModel.signOut()
                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.green)
                    Text("Sign Out")
                        .foregroundStyle(.white)
                }
                
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: SignUpViewViewModel())
}
