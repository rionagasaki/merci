//
//  EmailLoginView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/15.
//

import SwiftUI
import Combine
import FirebaseAuth

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
    @State var isInitialLoadingFailed: Bool = false
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .light)
    @State var cancellable = Set<AnyCancellable>()
    
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
                viewModel.signInWithEmail(userModel: userModel, pairModel: pairModel, appState: appState)
            } label: {
                Text("ログイン")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.customRed)
                    .cornerRadius(5)
            }
            .padding(.top, 40)
            Spacer()
        }
        .background(Color.white)
    }
}
