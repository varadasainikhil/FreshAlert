//
//  LoginView.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/21/25.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel = LoginViewViewModel()
    var body: some View {
        NavigationStack{
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(lineWidth: 2)
                    TextField("Enter your Email", text: $viewModel.emailAddress)
                        .padding(.horizontal)
                        .textInputAutocapitalization(.never)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(lineWidth: 2)
                    SecureField("Enter your Password", text: $viewModel.password)
                        .padding(.horizontal)
                        .textInputAutocapitalization(.never)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                
                Button{
                    // Sign up
                    Task{
                        await viewModel.signIn()
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.green)
                        Text("Sign In")
                            .foregroundStyle(.white)
                    }
                    
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .shadow(radius: 5)
                    .opacity(viewModel.readyForSignIn ? 1.0 : 0.6)
                }
                .disabled(!viewModel.readyForSignIn)
                
            }
            .padding()
            .navigationTitle("Welcome Back")
            .alert("Error", isPresented: $viewModel.showingError) {
                // Nothing to do
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    LoginView()
}
