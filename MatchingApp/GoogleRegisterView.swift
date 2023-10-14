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

struct GoogleRegisterView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @StateObject var viewModel = GoogleAuthViewModel()
    
    var body: some View {
        Button {
            Task {
                await viewModel.googleAuth(userModel:userModel, appState: appState, isNewUser: true)
            }
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
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .frame(width: UIScreen.main.bounds.width-32, height: 50)
        .background(Color.white)
        .cornerRadius(30)
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(.black,lineWidth: 1)
        }
        .padding(.top, 8)
    }
}

