//
//  ContentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var isModal: Bool = false
    @State private var selectedTab: Tab = .home
    @State private var navigationTitle:String = ""
    @State private var navigationStyle:Bool = true
    @State private var searchWord = ""
    @State var isLoading: Bool = false
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    @State var requestedPairView: RequestedPairView = .init(userID: "", nickname: "", birthDate: "", activeRegion: "", profileImageURL: "", introduction: "")
    
    var body: some View {
        NavigationView {
            if isLoading {
                LottieView(animationResourceName: "loading")
                    .frame(width: 100, height: 100)
            } else {
                TabView(selection: $selectedTab){
                    NavigationView {
                        VStack{
                            HomeView()
                            Divider()
                            CustomTabView(
                                selectedTab: $selectedTab,
                                navigationTitle: $navigationTitle
                            )
                        }
                        
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .tag(Tab.home)
                        .ignoresSafeArea()
                    
                    NavigationView {
                        VStack {
                            if appState.isLogin {
                                MessageListView()
                            } else {
                                NotLoginMessageListView()
                            }
                            Divider()
                            CustomTabView(selectedTab: $selectedTab, navigationTitle: $navigationTitle)
                        }
                    }
                    .tag(Tab.message)
                    
                    NavigationView {
                        VStack{
                            if appState.isLogin {
                                ProfileView(userModel: userModel)
                            } else {
                                NotLoginProfileView()
                            }
                            Divider()
                            CustomTabView(
                                selectedTab: $selectedTab,
                                navigationTitle: $navigationTitle
                            )
                        }
                    }
                    .tag(Tab.profile)
                }
            }
        }
        .sheet(isPresented: $isModal){
            // リクエストしてきたユーザーのユーザー情報を入れていく。
            requestedPairView
        }
        .onAppear {
            //MARK: @EnvironmentObjectに代入して汎用的に使う値はここで初期化をしておく
            isLoading = true
            //　ログインユーザーの情報もここで取得
            UITabBar.appearance().isHidden = true
            if Authentication().currentUid != "" {
                FetchFromFirestore().snapshotOnRequest(uid: Authentication().currentUid) { user in
                    self.userModel.uid = user.id
                    self.userModel.nickname = user.nickname
                    self.userModel.email = user.email
                    self.userModel.activeRegion = user.activityRegion
                    self.userModel.birthDate = user.birthDate
                    self.userModel.gender = user.gender
                    self.userModel.profileImageURL = user.profileImageURL
                    self.userModel.subProfileImageURL = user.subProfileImageURLs
                    self.userModel.introduction = user.introduction
                    self.userModel.requestUids = user.requestUids
                    self.userModel.requestedUids = user.requestedUids
                    self.userModel.pairUid = user.pairUid
                    self.userModel.hobbies = user.hobbies
                    self.userModel.pairID = user.pairID
                    if user.pairID != "" {
                        FetchFromFirestore().fetchCurrentUserPairInfo(pairID: user.pairID) { pair in
                                pairModel.id = pair.id
                                pairModel.gender = pair.gender
                                pairModel.pair_1_uid = pair.pair_1_uid
                                pairModel.pair_1_nickname = pair.pair_1_nickname
                                pairModel.pair_1_profileImageURL = pair.pair_1_profileImageURL
                                pairModel.pair_1_activeRegion = pair.pair_1_activeRegion
                                pairModel.pair_1_birthDate = pair.pair_1_birthDate
                                pairModel.pair_2_uid = pair.pair_2_uid
                                pairModel.pair_2_nickname = pair.pair_2_nickname
                                pairModel.pair_2_profileImageURL = pair.pair_2_profileImageURL
                                pairModel.pair_2_activeRegion = pair.pair_2_activeRegion
                                pairModel.pair_2_birthDate = pair.pair_2_birthDate
                                pairModel.chatPairIDs = pair.chatPairIDs
                            print(pair.chatPairIDs)
                            isLoading = false
                        }
                    } else {
                        isLoading = false
                    }
                    
                    if userModel.requestedUids != [] {
                        isModal = true
                    } else {
                        isModal = false
                    }
                }
            }
        }
    }
}


