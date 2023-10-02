//
//  UserProfileBottomView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/22.
//

import SwiftUI

struct UserProfileBottomView: View {
    @EnvironmentObject var userModel: UserObservableModel
    let user: UserObservableModel
    @StateObject var viewModel = UserProfileBottomViewModel()
    var body: some View {
        HStack {
            if userModel.user.friendRequestUids.contains(user.user.uid) {
                Button {
                    viewModel.cancelRequestFriend(requestingUser: userModel, requestedUser: user)
                } label: {
                    HStack {
                        Text("キャンセル")
                        Image(systemName: "plus")
                    }
                    .foregroundColor(.customBlack)
                    .font(.system(size: 14))
                    .frame(width: (UIScreen.main.bounds.width/1.2)/1.2, height: 40)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.customBlack, lineWidth: 1)
                    }
                }
            } else if userModel.user.friendRequestedUids.contains(user.user.uid) {
                HStack {
                    Button {
                        viewModel.approveFriendRequest(
                            requestingUser: userModel,
                            requestedUser: user
                        )
                    } label: {
                        HStack {
                            Text("追加する")
                            Image(systemName: "plus")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .frame(width: ((UIScreen.main.bounds.width/1.2)/1.2)-40, height: 40)
                        .background(Color.customBlack)
                        .cornerRadius(20)
                    }
                    
                    ZStack {
                        Circle()
                            .stroke(Color.customBlack, lineWidth: 1)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "person.fill.xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.customRed)
                    }
                    .onTapGesture {
                        viewModel.alertType = .blockUser
                        viewModel.isAlert = true
                    }
                }
            } else if userModel.user.friendUids.contains(user.user.uid) {
                if Array<String>(user.user.notificationMapping.keys).contains(userModel.user.uid) {
                    HStack {
                        HStack {
                            Text("友達中")
                            Image(systemName: "bell.and.waves.left.and.right")
                        }
                        .foregroundColor(.customBlack)
                        .font(.system(size: 14))
                        .frame(width: ((UIScreen.main.bounds.width/1.2)/1.2)-40, height: 40)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.customBlack, lineWidth: 1)
                        }
                        
                        Button {
                            viewModel.isActionSheet = true
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Color.customBlack, lineWidth: 1)
                                    .frame(width: 40, height: 40)
                                Image(systemName: "hand.wave")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.customRed)
                            }
                        }
                    }
                } else {
                    HStack {
                        HStack {
                            Text("友達中")
                            Image(systemName: "personalhotspot")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .frame(width: ((UIScreen.main.bounds.width/1.2)/1.2)-40, height: 40)
                        .background(Color.customBlack)
                        .cornerRadius(20)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.customBlack, lineWidth: 1)
                        }
                        
                        Button {
                            viewModel.isActionSheet = true
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Color.customBlack, lineWidth: 1)
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "hand.wave")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.customRed)
                            }
                        }
                    }
                }
            } else {
                HStack {
                    Button {
                        viewModel.requestFriend(requestingUser: userModel, requestedUser: user)
                    } label: {
                        HStack {
                            Text("友達申請")
                            Image(systemName: "plus")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .frame(width: ((UIScreen.main.bounds.width/1.2)/1.2)-40, height: 40)
                        .background(Color.customBlack)
                        .cornerRadius(20)
                    }
                    ZStack {
                        Circle()
                            .stroke(Color.customBlack, lineWidth: 1)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "person.fill.xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.customRed)
                    }
                    .onTapGesture {
                        viewModel.alertType = .blockUser
                        viewModel.isAlert = true
                    }
                }
            }
            
            NavigationLink {
                ChatView(toUser: user)
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.customBlack, lineWidth: 1)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "message.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.customBlack)
                    
                }
            }
        }
        .padding(.vertical, 16)
        .actionSheet(isPresented: $viewModel.isActionSheet) {
            return ActionSheet(
                title: Text("ユーザーの削除"),
                message: Text("フレンド解消は、フレンド状態を解消します。\nブロックはフレンド状態を解消し、合わせてそのユーザーとのトーク履歴を削除、ユーザーのつぶやき等の非表示化を行います。"),
                buttons: [
                    .default(Text("フレンド解消"), action: {
                        viewModel.alertType = .deleteFriend
                        viewModel.isAlert = true
                    }),
                    .destructive(Text("ブロック"), action: {
                        viewModel.alertType = .blockUser
                        viewModel.isAlert = true
                    }),
                    .cancel(Text("キャンセル"))
                ]
            )
        }
        .alert(isPresented: $viewModel.isAlert) {
            switch viewModel.alertType {
            case .requestFriend:
                return Alert(
                    title: Text("友達申請を送りました"),
                    message: Text("申請が承認されると、友達になります")
                )
            case .deleteFriend:
                return Alert(
                    title: Text("友達の削除"),
                    message: Text("\(user.user.nickname)さんを友達から削除しますか？"),
                    primaryButton: .cancel(Text("キャンセル")),
                    secondaryButton: .destructive(Text("削除"), action: {
                        viewModel.deleteFriend(requestingUser: userModel, requestedFriend: user)
                    })
                )
            case .blockUser:
                return Alert(
                    title: Text("ブロック"),
                    message: Text("\(user.user.nickname)さんをブロックしますか?ブロックするとこのユーザーのつぶやきは表示されません。"),
                    primaryButton: .cancel(Text("キャンセル")),
                    secondaryButton: .destructive(Text("ブロック"), action: {
                        viewModel.blockedUser(requestingUser: userModel, requestedUser: user)
                    })
                )
            }
        }
    }
}
