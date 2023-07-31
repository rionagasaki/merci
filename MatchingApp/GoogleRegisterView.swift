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
import Combine

//　新規登録のみを許容する。ログインはできない。
struct GoogleRegisterView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @StateObject var viewModel = GoogleRegisterViewModel()
    
    var body: some View {
        Button {
            viewModel.googleAuth()
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
        .alert(isPresented: $viewModel.alreadyHasAccountAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.alertText))
        }
        .frame(width: UIScreen.main.bounds.width-32, height: 50)
        .cornerRadius(5)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.black,lineWidth: 1)
        }
        .padding(.top, 8)
        .fullScreenCover(isPresented: $viewModel.isModal) {
            NickNameView()
        }
    }
}

