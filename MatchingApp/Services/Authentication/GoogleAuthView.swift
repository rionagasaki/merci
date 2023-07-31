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

// Googleでログインする場合。アカウント作成はできない！

struct GoogleAuthView: View {
    @StateObject var viewModel = GoogleAuthViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    
    var body: some View {
        Button {
            viewModel.googleAuth(
                userModel: userModel,
                pairModel: pairModel,
                appState: appState
            )
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
        .alert(isPresented: $viewModel.isFailedAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.black,lineWidth: 1)
        }
        .padding(.top, 8)
    }
}
