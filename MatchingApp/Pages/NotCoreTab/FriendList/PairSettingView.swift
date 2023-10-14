//
//  PairSettingView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/21.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct PairSettingView: View {
    @StateObject var viewModel = PairSettingViewModel()
    @State var snsShareHalfModal: Bool = false
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        VStack {
            SearchBar(viewModel: viewModel, userID: userModel.user.uid)
            ScrollView(showsIndicators: false) {
                VStack {
                    Label {
                        Text("送っているリクエスト")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                    } icon: {
                        Image(systemName: "person.2")
                            .foregroundColor(.customBlack)
                    }
                    .padding(.top, 24)
                    
                    if viewModel.requestFriendUsers.count == 0 {
                        Text("送っているリクエストはありません")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                            .padding(.leading, 8)
                    } else {
                        ForEach(viewModel.requestFriendUsers) { user in
                            UserCellView(buttonText: "キャンセル", buttonColor: .customBlue.opacity(0.8), user: user) {
                                viewModel.cancelFriendRequest(requestingUser: userModel, requestedUser: user)
                            }
                        }
                    }
                }
                
                VStack {
                    Label {
                        Text("受け取ったリクエスト")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                    } icon: {
                        Image(systemName: "bell")
                            .foregroundColor(.customBlack)
                    }
                    .padding(.top, 48)
                    
                    if viewModel.requestedFriendUsers.count == 0 {
                        Text("受け取っているリクエストはありません")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                            .padding(.leading, 8)
                    } else {
                        ForEach(viewModel.requestedFriendUsers) { user in
                            UserCellView(buttonText: "承認する", buttonColor: .customBlue.opacity(0.8), user: user) {
                                viewModel.approveRequest(
                                    requestUser: userModel,
                                    requestedUser: user)
                            }
                        }
                    }
                }
                
                if userModel.user.friendUids != [] {
                    Text("フレンド")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                        .padding(.top, 48)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            ForEach(viewModel.friendUsers) { user in
                                NavigationLink {
                                    UserProfileView(userId: user.user.uid, isFromHome: false)
                                } label: {
                                    UserRequestItem(user: user){
                                        viewModel.approveRequest(requestUser: userModel, requestedUser: user)
                                    }
                                }
                                .padding(.trailing, 14)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .refreshable {
            Task {
                UIIFGeneratorMedium.impactOccurred()
                await viewModel.initialFriendList(userModel: userModel)
            }
        }
        .onAppear {
            Task {
                await viewModel.initialFriendList(userModel: userModel)
            }
        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(
                title: Text("エラー"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
        .sheet(isPresented: $snsShareHalfModal){
            
        }
        .navigationDestination(isPresented: $viewModel.submit){
            if let user = viewModel.searchResultUser {
                UserProfileView(userId: user.user.uid, isFromHome: false)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    self.snsShareHalfModal = true
                } label: {
                    Image(systemName: "link")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct SearchBar: View {
    @StateObject var viewModel: PairSettingViewModel
    let userID: String
    var body: some View {
        HStack(spacing: .zero){
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundColor(.customDarkGray)
                .padding(.vertical, 8)
                .padding(.leading, 12)
            
            TextField(text: $viewModel.searchQuery) {
                Text("IDでユーザーを検索")
                    .foregroundColor(.customDarkGray)
                    .font(.system(size: 16, weight: .bold))
            }
            .onSubmit {
                Task {
                    await viewModel.searchUserByUid(userID: userID)
                }
            }
            .frame(height: 40)
            .foregroundColor(.black)
            .font(.system(size: 16, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .cornerRadius(30)
        }
        .background(
            Color.gray.opacity(0.2).cornerRadius(30)
        )
        .padding(.top, 8)
    }
}

struct UserCellView: View {
    let buttonText: String
    let buttonColor: Color
    let user: UserObservableModel
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(user.user.profileImageURLString)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .padding(.all, 8)
                .background(Color.gray.opacity(0.1))
                .clipShape(
                    Circle()
                )
            VStack(alignment: .leading){
                Text(user.user.nickname)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 20, weight: .bold))
                Button {
                    action()
                } label: {
                    Text(buttonText)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .padding(.all, 8)
                        .background(buttonColor.opacity(0.8))
                        .cornerRadius(10)
                }
                .padding(.top, 8)
            }
            .padding(.leading, 24)
            Spacer()
        }
        .frame(height: 120)
    }
}


struct UserRequestItem: View {
    let user: UserObservableModel
    let action: () -> Void
    var body: some View {
        VStack(spacing: 12){
            Image(user.user.profileImageURLString)
                .resizable()
                .scaledToFill()
                .frame(width: 96, height: 96)
                .padding(.all, 12)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            Text(user.user.nickname)
                .foregroundColor(.customBlack)
                .font(.system(size: 14, weight: .medium))
        }
        .shadow(radius: 2)
        .padding(.all, 4)
    }
}
