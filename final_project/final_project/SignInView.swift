//
//  SignInView.swift
//  final_project
//
//  Created by Upneet Bir on 12/5/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignInView: View {
    @State var email = ""
    @State var password = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button(action: { login() }) {
                Text("Sign in")
            }
        }
        .padding()
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
