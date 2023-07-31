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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            SearchBar(viewModel: viewModel, user: userModel)
            ScrollView(showsIndicators: false){
               
                if userModel.user.pairUid.isEmpty && viewModel.requestPairUser == nil {
                    VStack(alignment: .leading){
                        Label {
                            Text("現在のペア")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                        } icon: {
                            Image(systemName: "person.2")
                                .foregroundColor(.customBlack)
                        }
                        .padding(.top, 24)
                        Text("現在ペアは未設定です。ペアを決めてみよう。")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                            .padding(.leading, 8)
                    }
                } else if let requestPairUser = viewModel.requestPairUser {
                    VStack {
                        Label {
                            Text("リクエストを送っている相手")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                        } icon: {
                            Image(systemName: "person.2")
                                .foregroundColor(.customBlack)
                        }
                        .padding(.top, 24)
                        
                        Text("新しくペアを決める場合、現在のペアを解除する必要があります")
                            .foregroundColor(.customDarkGray)
                            .font(.system(size: 12))
                        UserCellView(buttonText: "リクエスト取消し", buttonColor: .customOrange, user: requestPairUser) {
                            viewModel.cancelPair(requestingUser: userModel, requestedUser: requestPairUser)
                        }
                    }
                } else if let currentPairUser = viewModel.currentPairUser {
                    VStack(alignment: .leading){
                        Label {
                            Text("現在のペア")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                        } icon: {
                            Image(systemName: "person.2")
                                .foregroundColor(.customBlack)
                        }
                        .padding(.top, 24)
                        Text("新しくペアを決める場合、現在のペアを解除する必要があります")
                            .foregroundColor(.customDarkGray)
                            .font(.system(size: 12))
                        UserCellView(buttonText: "ペア解除", buttonColor: .customOrange, user: currentPairUser) {
                            viewModel.dissolvePair(requestUser: userModel, requestedUser: appState.pairUserModel)
                        }
                        
                    }
                }
                
                VStack(alignment: .leading){
                    Label {
                        Text("リクエストされている相手")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                    } icon: {
                        Image(systemName: "bell")
                            .foregroundColor(.customBlack)
                    }
                    .padding(.top, 48)
                    
                    if viewModel.requestedPairUsers.count == 0 {
                        Text("現在リクエストされている相手はいません。")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                            .padding(.leading, 8)
                    } else {
                        ForEach(viewModel.requestedPairUsers) { user in
                            UserCellView(buttonText: "ペアになる", buttonColor: .customOrange, user: user) {
                                viewModel.createPair(
                                    requestUser: userModel,
                                    requestedUser: user)
                            }
                        }
                    }
                }
                
                if userModel.user.pairMapping != [:] {
                    Text("過去にペアだった相手")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                        .padding(.top, 48)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            ForEach(viewModel.pastPairUsers) { user in
                                UserRequestItem(user: user){
                                    viewModel.unPairRequestModal = true
                                }
                                .padding(.trailing, 14)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            if let user = viewModel.searchResultUser {
                NavigationLink(isActive: $viewModel.submit){
                    UserProfileView(user: user)
                } label: {
                    EmptyView()
                }
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.initialFriendList(userModel: userModel)
        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .halfModal(isPresented: $snsShareHalfModal){
            SNSShareView()
        }
        .halfModal(isPresented: $viewModel.unPairRequestModal){
            UnPairRequestView(requestedUser: userModel)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
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

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        PairSettingView()
    }
}


struct SearchBar: View {
    @StateObject var viewModel: PairSettingViewModel
    let user: UserObservableModel
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
                viewModel.searchUserByUid(userModel: user)
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
            WebImage(url: URL(string: user.user.profileImageURL))
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
            VStack(alignment: .leading){
                Text(user.user.nickname)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 20, weight: .bold))
                if let age = CalculateAge.calculateAge(from: user.user.birthDate) {
                    Text("\(age)歳・\(user.user.activeRegion)")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16))
                }
                Spacer()
                Button {
                    action()
                } label: {
                    Text(buttonText)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 150, height: 42)
                        .background(buttonColor)
                        .cornerRadius(20)
                }
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
            WebImage(url: URL(string: user.user.profileImageURL))
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
            
            Button {
                action()
            } label: {
                Text("ペア申請")
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
                    .frame(width: 120, height: 35)
                    .background(Color.customOrange)
                    .cornerRadius(20)
            }
        }
        .shadow(radius: 2)
    }
}
