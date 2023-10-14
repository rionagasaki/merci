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
import Combine

struct GoogleAuthView: View {
    @StateObject var viewModel = GoogleAuthViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    
    var body: some View {
        Button {
            Task {
                await viewModel.googleAuth(
                    userModel: userModel,
                    appState: appState,
                    isNewUser: false
                )
            }
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
    }
}
