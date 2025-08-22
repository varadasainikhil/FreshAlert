//
//  LoginViewViewModel.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/21/25.
//

import Foundation
import FirebaseAuth

@Observable
class LoginViewViewModel{
    var emailAddress : String = ""{
        didSet{
            emailAndPasswordValidation()
        }
    }
    
    var password : String = ""{
        didSet{
            emailAndPasswordValidation()
        }
    }
    
    var readyForSignIn : Bool = false
    var errorMessage : String = ""
    var showingError : Bool = false
    
    
    func emailAndPasswordValidation(){
        if emailAddress.filter({$0 == "@"}).count == 1
        && emailAddress.contains(".")
        && emailAddress.trimmingCharacters(in: .whitespacesAndNewlines).count > 7
        && emailAddress.last?.isLetter ?? false
        && emailAddress.first?.isLetter ?? false
        && password.trimmingCharacters(in: .whitespacesAndNewlines).count > 7 {
            readyForSignIn = true
        }
    }
    
    func signIn() async{
        if readyForSignIn{
            Auth.auth().signIn(withEmail: emailAddress, password: password){result, error in
                if (error != nil){
                    print(String(error!.localizedDescription))
                    self.errorMessage = String(error!.localizedDescription)
                    self.showingError = true
                }
            }
        }
    }
}
