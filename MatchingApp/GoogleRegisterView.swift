//
//  GoogleRegisterView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/17.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift

//　新規登録のみを許容する。ログインはできない。
struct GoogleRegisterView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @State private var isModal: Bool = false
    @Binding var alreadyHasAccountAlert: Bool
    @Binding var alertText: String
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
            
            guard let profile = user.profile else { return }
            
            Firestore.firestore().collection("User").whereField("email", isEqualTo: profile.email).getDocuments { querySnapshots, error in
                // アカウントが存在しているので、登録不可。
                if querySnapshots?.count != 0 {
                    alreadyHasAccountAlert = true
                    alertText = "すでにアカウントが存在しています。"
                    return
                }
                // 新規登録させる。
                else {
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
                    self.register(credential: credential)
                }
            }
        }
    }
    
    private func register(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if error != nil, result == nil { return }
            if let additionalUserInfo = result?.additionalUserInfo {
                if additionalUserInfo.isNewUser {
                    isModal = true
                } else {
                    FetchFromFirestore().fetchUserInfoFromFirestore { user in
                        self.userModel.uid = user.id
                        self.userModel.nickname = user.nickname
                        self.userModel.email = user.email
                        self.userModel.activeRegion = user.activityRegion
                        self.userModel.birthPlace = user.birthPlace
                        self.userModel.educationalBackground = user.educationalBackground
                        self.userModel.work = user.work
                        self.userModel.height = user.height
                        self.userModel.weight = user.weight
                        self.userModel.bloodType = user.bloodType
                        self.userModel.liquor = user.liquor
                        self.userModel.cigarettes = user.cigarettes
                        self.userModel.purpose = user.purpose
                        self.userModel.datingExpenses = user.datingExpenses
                        self.userModel.birthDate = user.birthDate
                        self.userModel.gender = user.gender
                        self.userModel.profileImageURL = user.profileImageURL
                        self.userModel.subProfileImageURL = user.subProfileImageURLs
                        self.userModel.introduction = user.introduction
                        self.userModel.requestUids = user.requestUids
                        self.userModel.requestedUids = user.requestedUids
                        self.userModel.pairUid = user.pairUid
                        self.userModel.hobbies = user.hobbies
                        self.userModel.pairID = user.pairID
                        self.userModel.chatUnreadNum = user.chatUnreadNum
                        appState.notLoggedInUser = false
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
                Text("Sign up with Google")
                    .font(.system(size:18))
                    .bold()
                    .foregroundColor(.black)
            }
        }
        .frame(width: UIScreen.main.bounds.width-32, height: 50)
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

