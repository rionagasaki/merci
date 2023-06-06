import SwiftUI
import AuthenticationServices
import Foundation
import FirebaseAuth
import CryptoKit

struct LoginView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("アプリのロゴ")
                        .fontWeight(.heavy)
                        .font(.system(size: 30))
                        .padding(.top, 16)
                    
                    TextField("", text: $viewModel.email , prompt: Text("メールアドレス"))
                        .padding(.leading, 10)
                        .frame(height: 38)
                        .overlay(RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.customLightGray, lineWidth: 2))
                        .onChange(of: viewModel.email, perform: { _ in
                            viewModel.validateEmail()
                        })
                        .padding(.horizontal, 16)
                        .padding(.top, 56)
                    
                    SecureField("", text: $viewModel.password , prompt: Text("パスワード"))
                        .padding(.leading, 10)
                        .frame(height: 38)
                        .overlay(RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.customLightGray, lineWidth: 2))
                        .onChange(of: viewModel.password, perform: { _ in
                            viewModel.validatePassword()
                        })
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    
                    NavigationLink {
                        
                    } label: {
                        Text("パスワードを忘れた方")
                            .fontWeight(.heavy)
                            .font(.system(size: 13))
                            .foregroundColor(.customBlue)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                    }
                    
                    
                    Button {
                        SignIn.shared.signInWithEmail(email: viewModel.email, password: viewModel.password) { result in
                            switch result {
                            case .success(_):
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
                                    self.userModel.requestUids = user.requestUids
                                    self.userModel.requestedUids = user.requestedUids
                                    if userModel.pairID != "" {
                                        FetchFromFirestore().fetchCurrentUserPairInfo(pairID: userModel.pairID) { pair in
                                            pairModel.id = pair.id
                                            pairModel.gender = pair.gender
                                            pairModel.pair_1_uid = pair.pair_1_uid
                                            pairModel.pair_1_nickname = pair.pair_1_nickname
                                            pairModel.pair_1_profileImageURL = pair.pair_1_profileImageURL
                                            pairModel.pair_1_activeRegion = pair.pair_1_activeRegion
                                            pairModel.pair_1_birthDate = pair.pair_1_birthDate
                                            pairModel.pair_2_uid = pair.pair_2_uid
                                            pairModel.pair_2_nickname = pair.pair_2_nickname
                                            pairModel.pair_2_profileImageURL = pair.pair_2_profileImageURL
                                            pairModel.pair_2_activeRegion = pair.pair_2_activeRegion
                                            pairModel.pair_2_birthDate = pair.pair_2_birthDate
                                            pairModel.chatPairIDs = pair.chatPairIDs
                                            appState.isLogin = true
                                            appState.messageListViewInit = true
                                        }
                                    } else {
                                        appState.isLogin = true
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
                            .font(.system(size: 17))
                            .bold()
                            .frame(width: UIScreen.main.bounds.width-40, height: 50)
                            .background(Color.customBlack)
                            .cornerRadius(32)
                            .padding(.top, 8)
                            .padding(.horizontal,16)
                    }
                    .disabled(!viewModel.isEnabledTappedLoginButton)
                    
                    HStack {
                        VStack {
                            Divider()
                        }
                        Text("または")
                            .foregroundColor(.gray)
                            .font(.system(size: 17))
                            .bold()
                            .padding(.vertical, 16)
                        VStack {
                            Divider()
                        }
                    }
                    .padding(.horizontal, 8)
                    AppleAuthView()
                    GoogleAuthView()
                    
                }
            }
            Spacer()
            Button {
                viewModel.registerSheet = true
            } label: {
                HStack(spacing: .zero){
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                    Text("アカウントの新規作成は")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                        .padding(.leading, 8)
                    Text("こちらから")
                        .foregroundColor(.blue.opacity(0.8))
                        .font(.system(size: 16))
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 60)
            .background(.ultraThinMaterial)
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.isVisibleValidateAlert) {
            Alert(
                title: Text("入力内容が間違っています")
                    .bold(),
                message: Text("メールアドレス、またはパスワードが違います。再度正しく入力してください。")
                    .fontWeight(.medium)
                ,
                dismissButton: .cancel(
                    Text("閉じる")
                        .fontWeight(.light)
                        .foregroundColor(.customBlue)
                )
            )
        }
        .sheet(isPresented: $viewModel.registerSheet) {
            RegisterView()
        }
        .fullScreenCover(isPresented: $viewModel.isModal) {
            NickNameView()
        }
    }
}


extension View {
    public func gradientForegroundColor() -> some View {
        self.overlay(.linearGradient(Gradient(colors: [.white, .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
}

struct LoginView_preview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
