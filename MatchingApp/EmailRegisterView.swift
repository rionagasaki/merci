//
//  EmailRegisterView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/15.
//

import SwiftUI
import PopupView

struct EmailRegisterView: View {
    enum FocusTextFields {
        case email
        case password
    }
    @EnvironmentObject var appState: AppState
    @FocusState private var focusState: FocusTextFields?
    @StateObject private var viewModel = EmailRegisterViewModel()
    @Binding var isShow: Bool
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .light)
    @State var errorToast: Bool = false
    
    
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
                        Text("新規登録")
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
                            .stroke(focusState == .email ? .black: viewModel.isValidEmail() || viewModel.email == "" ? .gray.opacity(0.3): .red, lineWidth: 1)
                    }
                if !(viewModel.isValidEmail() || viewModel.email == "") {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.red)
                        Text("形式が正しくありません")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(.red)
                    }
                    .padding(.leading, 8)
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
                        if !viewModel.isValidPassword(){
                            
                        }
                    })
                    .focused($focusState, equals: .password)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(focusState == .password ? .black: viewModel.isValidPassword() || viewModel.password == "" ? .gray.opacity(0.3): .red , lineWidth: 1)
                    }
                if viewModel.isValidPassword() || viewModel.password == "" {
                    Text("※半角英数字含み8文字以上")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.customBlack)
                        .padding(.leading, 8)
                } else {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.red)
                        Text("半角英数字を含み、8文字以上で入力してください")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(.red)
                    }
                    .padding(.leading, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            Button {
                SignUp.shared.handleSignUp(email: viewModel.email, password: viewModel.password) { result in
                    switch result {
                    case .success(_):
                        viewModel.isModal = true
                        viewModel.email = ""
                        viewModel.password = ""
                    case .failure(let failure):
                        
                        print("Errorが起きました" ,failure)
                    }
                }
            } label: {
                Text("新規登録")
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
        .fullScreenCover(isPresented: $viewModel.isModal) {
            NickNameView()
        }
        .popup(isPresented: $errorToast) {
            VStack {
                Text("すでに存在するアカウントです")
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width,height: 100)
            .background(Color.red.opacity(0.7))
        } customize: {
            $0
                .appearFrom(.top)
                .animation(.easeIn)
                .position(.top)
                .type(.toast)
                
                
        }

    }
}
