//
//  GoogleAuthView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift

// Googleでログインする場合。アカウント作成はできない！

struct GoogleAuthView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    @Binding var noAccountAlert: Bool
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
                if querySnapshots?.count != 0 {
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
                    self.login(credential: credential)
                } else {
                    noAccountAlert = true
                    alertText = "このアドレスに紐づくアカウントは存在しません。"
                    return
                }
            }
        }
    }
    
    private func login(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if error != nil, result == nil { return }
            if let additionalUserInfo = result?.additionalUserInfo {
                if !additionalUserInfo.isNewUser {
                    // エラーハンドリング4
                    guard let uid = AuthenticationManager.shared.uid else { return }
                    FetchFromFirestore().snapshotOnRequest(uid: uid) { user in
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
                        self.userModel.friendUids = user.friendUids
                        self.userModel.pairRequestUid = user.pairRequestUid
                        self.userModel.pairRequestedUids = user.pairRequestedUids
                        self.userModel.pairUid = user.pairUid
                        self.userModel.hobbies = user.hobbies
                        self.userModel.pairID = user.pairID
                        self.userModel.pairList = user.pairList
                        self.userModel.chatUnreadNum = user.chatUnreadNum
                        
                        if user.pairID != "" {
                            FetchFromFirestore().fetchSnapshotPairInfo(pairID: user.pairID) { pair in
                                pairModel.pair = pair.adaptPairModel()
                                // ペアの情報をAppStateで保管しておく。
                                FetchFromFirestore().fetchUserInfoFromFirestoreByUserID(uid: user.pairUid) { pair in
                                    if let pair = pair {
                                        appState.pairUserModel = pair.adaptUserObservableModel()
                                        appState.messageListViewInit = true
                                    }
                                }
                            }
                        } else {
                           
                        }
                        
                        FetchFromFirestore().fetchUserInfoFromFirestoreByUserID(uid: user.pairUid) { pair in
                            if let pair = pair {
                                appState.notLoggedInUser = false
                                appState.pairUserModel = pair.adaptUserObservableModel()
                                appState.messageListViewInit = true
                            }
                        }
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
                Text("Sign in with Google")
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
    }
}
