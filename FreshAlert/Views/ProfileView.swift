//
//  ProfileView.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/25/25.
//

import SwiftUI

struct ProfileView: View {
    @State var authManager : SignUpViewViewModel
    var body: some View {
        VStack {
            Button{
                Task{
                    authManager.signOut()
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
    ProfileView(authManager: SignUpViewViewModel())
}
