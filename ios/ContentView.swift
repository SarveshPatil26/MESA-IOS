import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        if isLoggedIn {
            SubjectSelectionView()
        } else {
            VStack {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Login") {
                    isLoggedIn = true
                }
                .padding()
            }
            .padding()
        }
    }
}
