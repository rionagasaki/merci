//
//  FriendCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendCellView: View {
    let user: UserObservableModel
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if user.pairUid == userModel.uid {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(colors: [.red, .yellow], startPoint: .leading, endPoint: .trailing
                            )
                        )
                            .frame(width: 70, height: 70)
                            
                        ZStack(alignment: .topLeading){
                            WebImage(url: URL(string: user.profileImageURL))
                                .resizable()
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                            Text("ペア")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .bold))
                                .background(Color.pink)
                                .padding(.all,2)
                                .cornerRadius(10)
                                
                        }
                    }
                } else {
                    WebImage(url: URL(string: user.profileImageURL))
                        .resizable()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading){
                    HStack {
                        Text(user.nickname)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.customBlack)
                        if let age = CalculateAge().calculateAge(from: user.birthDate) {
                            Text("\(age)歳・\(user.activeRegion)")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.customBlack)
                        }
                        Spacer()
                        Button {
                            print("aaa")
                        } label: {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                        
                    }
                    if userModel.pairRequestedUids.contains(user.uid){
                        Button {
                            SetToFirestore.shared.updatePair(currentUser: userModel, requestedUser: user)
                        } label: {
                            Text("ペアリクエストが届いています！")
                                .foregroundColor(.white)
                            
                                .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                .background(Color.pink.opacity(0.7))
                                .cornerRadius(20)
                        }
                    } else {
                        if userModel.pairUid == user.uid {
                            Button {
                                SetToFirestore.shared.changePair(currentUser: userModel, pairUser: user)
                            } label: {
                                Text("ペア解除")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                    .background(Color.pink.opacity(0.7))
                                    .cornerRadius(20)
                            }
                        } else {
                            if userModel.pairRequestUid == user.uid {
                                Button {
                                    SetToFirestore.shared.cancelPairRequest(currentUid: userModel.uid, pairUserUid: user.uid)
                                } label: {
                                    Text("ペアリクエスト中")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .bold))
                                        .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                        .background(Color.pink.opacity(0.7))
                                        .cornerRadius(20)
                                }
                            } else {
                                Button {
                                    SetToFirestore.shared.requestPair(currentUid: userModel.uid, pairUserUid: user.uid)
                                } label: {
                                    Text("ペアリクエストを送る")
                                        .foregroundColor(.pink.opacity(0.7))
                                        .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                        .background(Color.white)
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.pink.opacity(0.7),lineWidth: 2))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct FriendCellView_Previews: PreviewProvider {
    static var previews: some View {
        FriendCellView(user: .init())
    }
}
