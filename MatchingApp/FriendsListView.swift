//
//  FriendsListView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/21.
//

import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    @State var users: [UserObservableModel] = []
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        VStack {
            if userModel.friendUids == [] {
                VStack {
                    LottieView(animationResourceName: "search")
                        .frame(height: 200)
                    Text("友達がいません👀")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 150)
            } else {
                ScrollView {
                    VStack {
                        ForEach(users) { user in
                            FriendCellView(user: user)
                            Divider()
                        }
                    }
                }
            }
        }
        .onAppear {
            print("friendUID!!!\(userModel.friendUids)")
            FetchFromFirestore().fetchConcurrentUserInfo(userIDs: userModel.friendUids) { users in
                self.users = users.map { $0.adaptUserObservableModel() }
                
                if let index = self.users.firstIndex(where: { $0.uid == userModel.pairUid }) {
                    let pairUser = self.users.remove(at: index)
                    self.users.insert(pairUser, at: 0)
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
                Text("友達")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 22, weight: .bold))
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SelectAddPairWayView()
                        .onAppear {
                            UIIFGeneratorMedium.impactOccurred()
                        }
                } label: {
                    Text("追加")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.all, 8)
                        .background(Color.pink.opacity(0.7))
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView()
    }
}
