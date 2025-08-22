//
//  AuthenticationManager.swift
//  FreshAlert
//
//  Created by Sai Nikhil Varada on 8/21/25.
//

import Foundation
import FirebaseAuth

@Observable
final class SignUpViewViewModel{
    var emailAddress : String = "" {
        // Validating the email after a change is made to the email
        didSet {
            emailValidation()
            checkCriteriaMet()
        }
    }
    
    var password : String = "" {
        // Validating the password after a change is made to the email

        didSet{
            checkPasswords()
            checkCriteriaMet()
        }
    }
    
    var confirmationPassword : String = "" {
        // Validating the confirmPassword after a change is made to the email
        didSet{
            checkPasswords()
            checkCriteriaMet()
        }
    }
    
    var passwordsMatching = false
    var passwordLengthOk = false
    var isEmailValidated : Bool = false
    
    var isButtonActive : Bool = false

    func checkCriteriaMet(){
        if passwordsMatching  && passwordLengthOk && isEmailValidated {
            isButtonActive = true
        }
        else{
            isButtonActive = false
        }
    }
    // Checking if the email has 1 @, ., alteast 7 characters and the first and last character is a letter
    final private func emailValidation() {
        if emailAddress.filter({$0 == "@"}).count == 1
        && emailAddress.contains(".")
        && emailAddress.trimmingCharacters(in: .whitespacesAndNewlines).count > 7
        && emailAddress.last?.isLetter ?? false
        && emailAddress.first?.isLetter ?? false{
            isEmailValidated = true
        }
    }
    
    // Checking passwords if they are matching and if they are atleast 7 characters long
    final func checkPasswords(){
        if password == confirmationPassword {
            passwordsMatching = true
        } else{
            passwordsMatching = false
        }
        
        if password.trimmingCharacters(in: .whitespacesAndNewlines).count > 7 && confirmationPassword.trimmingCharacters(in: .whitespacesAndNewlines).count > 7 {
            passwordLengthOk = true
        }
        else{
            passwordLengthOk = false
        }
    }
    
    // Creating an account
    func createAccount() async{
        print("Sign Up button is pressed.")
        if isEmailValidated && passwordsMatching && passwordLengthOk{
            Auth.auth().createUser(withEmail: emailAddress, password: password){ result, error in
                print(error?.localizedDescription ?? "User signed in succesfully")
            }
        }
    }
    
    // Signing Out
    func signOut(){
        do{
            try Auth.auth().signOut()
            print("User signed out successfully.")
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
}
