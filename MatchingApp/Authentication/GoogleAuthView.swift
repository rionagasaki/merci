//
//  GoogleAuthView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct GoogleAuthView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @State private var isModal: Bool = false
    
    private func googleAuth() {
        
        guard let clientID:String = FirebaseApp.app()?.options.clientID else { return }
        let config:GIDConfiguration = GIDConfiguration(clientID: clientID)
        
        let windowScene:UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController:UIViewController? = windowScene?.windows.first!.rootViewController!
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController!) { result, error in
            guard error == nil else {
                print("GIDSignInError: \(error!.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
            self.login(credential: credential)
        }
    }
    
    private func login(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if error != nil, result == nil { return }
            if let additionalUserInfo = result?.additionalUserInfo {
                if additionalUserInfo.isNewUser {
                   isModal = true
                } else {
                    FetchFromFirestore().fetchUserInfoFromFirestore { user in
                        self.userModel.nickname = user.nickname
                        self.userModel.email = user.email
                        self.userModel.activeRegion = user.activityRegion
                        self.userModel.birthDate = user.birthDate
                        self.userModel.gender = user.gender
                        self.userModel.profileImageURL = user.profileImageURL
                        self.userModel.subProfileImageURL = user.subProfileImageURLs
                        self.userModel.introduction = user.introduction
                        self.userModel.uid = user.id
                        self.userModel.hobbies = user.hobbies
                        self.userModel.pairID = user.pairID
                        appState.isLogin = true
                        appState.messageListViewInit = true
                    }
                }
            }
        }
    }
    var body: some View {
        Button {
            googleAuth()
        } label: {
            HStack {
                Image("Google")
                    .resizable()
                    .frame(width: 15, height: 15)
                Text("Sign in with google")
                    .font(.system(size:15))
                    .foregroundColor(.black)
            }
        }
        .frame(width: 224, height: 40)
        .cornerRadius(5)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.black,lineWidth: 1)
        }
        .padding(.top, 8)
        .sheet(isPresented: $isModal) {
            NickNameView()
        }
    }
}

struct GoogleAuthView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuthView()
    }
}
