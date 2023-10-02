//
//  ReAuthenticationView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/27.
//

import SwiftUI
import AuthenticationServices

struct ReAuthenticationView: View {
    @StateObject var viewModel = ReAuthenticationViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("本人確認のため、再認証を行なってください。")
                .foregroundColor(.customBlack)
                .font(.system(size: 24, weight: .medium))
            Image(userModel.user.profileImageURLString)
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.all, 16)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
                .padding(.top, 16)
            
            Text(userModel.user.nickname)
                .foregroundColor(.customBlack)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            switch viewModel.provider {
            case .apple:
                SignInWithAppleButton(.signIn){ request in
                    viewModel.handleRequest(request: request)
                } onCompletion: { result in
                    viewModel.handleResult(result: result)
                }
                .signInWithAppleButtonStyle(.black)
                .frame(width: UIScreen.main.bounds.width-32, height: 50)
                .cornerRadius(30)
            case .google:
                Button {
                    viewModel.googleAuth()
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
                .background(Color.white)
                .cornerRadius(30)
                .alert(isPresented: $viewModel.isErrorAlert){
                    Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.black,lineWidth: 1)
                }
                .padding(.top, 8)
            case .none:
                EmptyView()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .onAppear {
            viewModel.initial()
        }
        .onReceive(viewModel.$isSuccess) {
            if $0 {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
    }
}

struct ReAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        ReAuthenticationView()
    }
}
