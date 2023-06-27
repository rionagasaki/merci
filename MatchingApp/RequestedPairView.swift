//
//  RequestedPairView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/27.
//

import SwiftUI

struct RequestedPairView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    @State var friendRequestUsers:[UserObservableModel] = []
    @State var pairRequestUsers:[UserObservableModel] = []
    
    @State var selection = 0
    let tabSections = ["ペア", "友達"]
    var body: some View {
        VStack {
            HStack {
                ForEach(tabSections.indices, id: \.self) { index in
                    Button {
                        withAnimation {
                            selection = index
                        }
                    } label: {
                        Text(tabSections[index])
                            .foregroundColor(index == selection ? .customBlack: .customBlack.opacity(0.5))
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .padding(.top, 24)
            ZStack(alignment: selection == 0 ? .leading: .trailing) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.8))
                    .frame(width: UIScreen.main.bounds.width, height: 2)
                Rectangle()
                    .foregroundColor(.pink.opacity(0.7))
                    .frame(width: (UIScreen.main.bounds.width/2), height: 2)
            }
            
            TabView(selection: $selection) {
                ForEach(tabSections.indices, id: \.self) { index in
                    if index == 0 {
                        if userModel.pairRequestedUids == [] {
                            VStack {
                                LottieView(animationResourceName: "search")
                                    .frame(height: 200)
                                Text("現在リクエストは届いていません🐾")
                                    .foregroundColor(.customBlack)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .padding(.bottom, 150)
                        } else {
                            ScrollView {
                                VStack {
                                    ForEach(pairRequestUsers) { user in
                                        PairRequestCellView(user: user)
                                        Divider()
                                    }
                                }
                            }
                        }
                    } else {
                        if userModel.requestedUids == [] {
                            VStack {
                                LottieView(animationResourceName: "search")
                                    .frame(height: 200)
                                Text("現在リクエストは届いていません🐾")
                                    .foregroundColor(.customBlack)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .padding(.bottom, 150)
                        } else {
                            ScrollView {
                                VStack {
                                    ForEach(friendRequestUsers) { user in
                                        RequestCellView(user: user)
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .onAppear {
            self.friendRequestUsers = []
            self.pairRequestUsers = []
            FetchFromFirestore().fetchConcurrentUserInfo(userIDs: userModel.requestedUids) { users in
                users.forEach { user in
                    self.friendRequestUsers.append(user.adaptUserObservableModel())
                }
            }
            FetchFromFirestore().fetchConcurrentUserInfo(userIDs: userModel.pairRequestedUids) { users in
                users.forEach { user in
                    self.pairRequestUsers.append(user.adaptUserObservableModel())
                }
            }
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
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("リクエスト")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 22, weight: .bold))
            }
        }
    }
}
