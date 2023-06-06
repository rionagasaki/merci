//
//  ProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pairModel: PairObservableModel
    @StateObject var userModel: UserObservableModel
    @State var showingAlert: Bool = false
    @State var profileModal: Bool = false
    var body: some View {
        ScrollView {
            VStack {
                MyMainInfoView(userModel: userModel)
                NavigationLink {
                    DetailUserIntroductionView()
                } label: {
                    VStack(alignment: .leading, spacing: .zero) {
                        HStack {
                            Text("自己紹介")
                                .foregroundColor(.black.opacity(0.8))
                                .font(.system(size: 18))
                                .bold()
                            Spacer()
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 8, height: 10)
                                .scaledToFit()
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        
                        if userModel.introduction == "" {
                            Text("未設定")
                                .foregroundColor(.gray.opacity(0.8))
                                .fontWeight(.light)
                                .font(.system(size: 14))
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(userModel.introduction)
                                .foregroundColor(.black.opacity(0.8))
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 16)
                            
                                .font(.system(size: 14))
                                .fontWeight(.light)
                        }
                    }
                }
                NavigationLink {
                    HobbiesView()
                } label: {
                    VStack(spacing: .zero){
                        Text("興味")
                            .padding(.leading, 16)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black.opacity(0.8))
                            .font(.system(size: 18))
                            .bold()
                        if userModel.hobbies == [] {
                            Text("未設定")
                                .foregroundColor(.gray.opacity(0.8))
                                .fontWeight(.light)
                                .font(.system(size: 14))
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack {
                                    ForEach(userModel.hobbies, id: \.self) { tag in
                                        ProfileTagView(tagName: tag)
                                    }
                                }
                                .padding(.vertical, 4)
                                .padding(.leading, 16)
                            }
                        }
                    }
                }
                CustomDivider()
                HStack {
                    Text("ペア")
                        .foregroundColor(.black.opacity(0.8))
                        .font(.system(size: 18))
                        .bold()
                    Spacer()
                    Button {
                        profileModal = true
                    } label: {
                        Text("ペアプロフィール確認")
                            .foregroundColor(.blue.opacity(0.8))
                            .font(.system(size: 14))
                            .underline()
                    }
                }
                .padding(.horizontal, 16)
                if userModel.pairUid == "" {
                    Text("未設定")
                        .foregroundColor(.gray.opacity(0.8))
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .padding(.leading, 16)
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    if pairModel.pair_1_uid == userModel.pairUid {
                        HStack {
                            WebImage(url: URL(string: pairModel.pair_1_profileImageURL))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(5)
                            
                            Text(pairModel.pair_1_nickname)
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .light))
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .padding(.leading, 16)
                    } else {
                        HStack {
                            WebImage(url: URL(string: pairModel.pair_2_profileImageURL))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(5)
                            Text(pairModel.pair_2_nickname)
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .light))
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .padding(.leading, 16)
                    }
                }
                
                if userModel.pairUid == "" {
                    NavigationLink {
                        AddNewPairView()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 10, height: 10)
                            Text("追加する")
                        }
                        .foregroundColor(.black)
                    }
                } else {
                    Button {
                        showingAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.2.circlepath")
                                .resizable()
                                .frame(width: 12, height: 10)
                                .scaledToFit()
                            Text("変更する")
                        }
                        .foregroundColor(.black)
                    }
                    
                }
                
                CustomDivider()
                Group {
                    NewIntroductionView()
                    CustomDivider()
                    SettingView()
                        .padding(.leading, 16)
                    Button {
                        SignOut.shared.signOut {
                            appState.messageListViewInit = true
                            appState.isLogin = false
                        }
                    } label: {
                        Text("ログアウト")
                            .foregroundColor(.red)
                            .padding(.vertical, 16)
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("警告"),
                  message: Text("新しいユーザーにリクエストを送ると、今のペアが解消されますがよろしいですか?"),
                  primaryButton: .cancel(Text("キャンセル")),    // キャンセル用
                  secondaryButton: .destructive(Text("OK")))   // 破壊的変更用
        }
        .sheet(isPresented: $profileModal) {
            ModalGroupProfileView(pair: pairModel)
        }
    }
}
