//
//  EmailLoginView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/15.
//

import SwiftUI

struct EmailLoginView: View {
    enum FocusTextFields {
        case email
        case password
    }
    @Binding var isShow: Bool
    @FocusState private var focusState: FocusTextFields?
    @StateObject private var viewModel = EmailLoginViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    @EnvironmentObject var appState: AppState
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        isShow = false
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width:10, height:15)
                        
                            .foregroundColor(.customBlack)
                        Text("ログイン")
                            .foregroundColor(.customBlack)
                            .bold()
                            .font(.system(size: 16))
                    }
                }
                .padding(.leading, 16)
                .padding(.top, 16)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 4){
                Text("📧メールアドレス")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 13, weight: .bold))
                TextField("", text: $viewModel.email , prompt: Text("sample@icloud.com").foregroundColor(.gray.opacity(0.5)))
                    .padding(.leading, 10)
                    .frame(height: 38)
                    .onChange(of: viewModel.email, perform: { _ in
                        viewModel.validateEmail()
                    })
                    .focused($focusState, equals: .email)
                    
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(focusState == .email ? .black: .gray.opacity(0.3) , lineWidth: 1)
                    }
            }
            .padding(.horizontal, 16)
            .padding(.top, 56)
            
            VStack(alignment: .leading, spacing: 4){
                Text("🔑パスワード")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 13, weight: .bold))
                SecureField("", text: $viewModel.password , prompt: Text("パスワードを入力"))
                    .padding(.leading, 10)
                    .frame(height: 38)
                    .onChange(of: viewModel.password, perform: { _ in
                        viewModel.validatePassword()
                    })
                    .focused($focusState, equals: .password)
                    
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(focusState == .password ? .black: .gray.opacity(0.3) , lineWidth: 1)
                    }
                
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            Button {
                SignIn.shared.signInWithEmail(email: viewModel.email, password: viewModel.password) { result in
                    switch result {
                    case .success(_):
                        UIIFGeneratorMedium.impactOccurred()
                        // エラーハンドリング2
                        guard let uid = AuthenticationManager.shared.uid else { return }
                        FetchFromFirestore().snapshotOnRequest(uid: uid){ user in
                            UIIFGeneratorMedium.impactOccurred()
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
                            self.userModel.chatUnreadNum = user.chatUnreadNum
                            if userModel.pairID != "" {
                                FetchFromFirestore().fetchPairInfo(pairID: userModel.pairID) { pair in
                                    pairModel.pair = pair.adaptPairModel()
                                    FetchFromFirestore().fetchUserInfoFromFirestoreByUserID(uid: user.pairUid) { pair in
                                        if let pair = pair {
                                            appState.pairUserModel = pair.adaptUserObservableModel()
                                            appState.notLoggedInUser = false
                                            appState.messageListViewInit = true
                                        }
                                    }
                                }
                            } else {
                                appState.notLoggedInUser = false
                                appState.messageListViewInit = true
                            }
                        }
                    case .failure(let failure):
                        print(failure)
                    }
                }
            } label: {
                Text("ログイン")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.pink.opacity(0.7))
                    .cornerRadius(5)
            }
            .padding(.top, 40)
            
            Spacer()
        }
        .background(Color.white)
    }
}
