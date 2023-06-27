//
//  ContentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State var isLoginModal: Bool = false
    @State private var isUserInfoSetModal: Bool = false
    @State private var selectedTab: Tab = .home
    @State private var navigationTitle:String = ""
    @State private var navigationStyle:Bool = true
    @State private var searchWord = ""
    @State var isLoading: Bool = false
    @State var isNoPairPresented: Bool = false
    
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    @State var requestedPairView: RequestedPairView = .init()
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some View {
        VStack {
            if isLoading {
                LottieView(animationResourceName: "rabbit")
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
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle("🔍相手をさがす")
                    }
                    .tag(Tab.home)
                    .ignoresSafeArea()
                    
                    NavigationView {
                        VStack {
                            MessageListView()
                            Divider()
                            CustomTabView(selectedTab: $selectedTab, navigationTitle: $navigationTitle)
                        }
                    }
                    .tag(Tab.message)
                    
                    ZStack {
                        NavigationView {
                            VStack{
                                ProfileView(noPairPopup: $isNoPairPresented)
                                Divider()
                                CustomTabView(
                                    selectedTab: $selectedTab,
                                    navigationTitle: $navigationTitle
                                )
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("プロフィール")
                        }
                        if isNoPairPresented {
                            PopupView(isPresented: $isNoPairPresented)
                        }
                    }
                    .tag(Tab.profile)
                }
            }
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
            
            // ユーザーがログイン状態であれば、そのユーザーの情報を取得する。
            if !appState.notLoggedInUser {
                // 初回起動時なのにログイン中である場合はサインアウトする。
                if isFirstLaunch {
                    SignOut.shared.signOut {
                        appState.messageListViewInit = true
                        appState.notLoggedInUser = true
                        isFirstLaunch = false
                        // SignOut時は全てをリセットする。
                        FetchFromFirestore().deleteListener()
                        self.userModel.uid = ""
                        self.userModel.nickname = ""
                        self.userModel.email = ""
                        self.userModel.gender = ""
                        self.userModel.activeRegion = ""
                        self.userModel.birthPlace = ""
                        self.userModel.educationalBackground = ""
                        self.userModel.work = ""
                        self.userModel.height = ""
                        self.userModel.weight = ""
                        self.userModel.bloodType = ""
                        self.userModel.liquor = ""
                        self.userModel.cigarettes = ""
                        self.userModel.purpose = ""
                        self.userModel.datingExpenses = ""
                        self.userModel.friendUids = []
                        self.userModel.birthDate = ""
                        self.userModel.profileImageURL = ""
                        self.userModel.subProfileImageURL = []
                        self.userModel.introduction = ""
                        self.userModel.requestUids = []
                        self.userModel.requestedUids = []
                        self.userModel.pairRequestUid = ""
                        self.userModel.pairRequestedUids = []
                        self.userModel.pairUid = ""
                        self.userModel.hobbies = []
                        self.userModel.pairID = ""
                        self.userModel.chatUnreadNum = [:]
                    }
                    return
                }
                isLoading = true
                guard let uid = AuthenticationManager.shared.uid else { return }
                FetchFromFirestore().snapshotOnRequest(uid: uid) { user in
                    if user.nickname == "" || user.gender == "" || user.activityRegion == "" || user.birthDate == "" || user.profileImageURL == "" {
                        isUserInfoSetModal = true
                    }
                    self.userModel.uid = user.id
                    self.userModel.nickname = user.nickname
                    self.userModel.fcmToken = user.fcmToken
                    self.userModel.coins = user.coins
                    self.userModel.email = user.email
                    self.userModel.activeRegion = user.activityRegion
                    self.userModel.birthPlace = user.birthPlace
                    self.userModel.educationalBackground = user.educationalBackground
                    self.userModel.work = user.work
                    self.userModel.height = user.height
                    self.userModel.weight = user.weight
                    self.userModel.bloodType = user.bloodType
                    self.userModel.liquor = user.liquor
                    self.userModel.cigarettes = user.cigarettes
                    self.userModel.purpose = user.purpose
                    self.userModel.datingExpenses = user.datingExpenses
                    self.userModel.friendUids = user.friendUids
                    self.userModel.birthDate = user.birthDate
                    self.userModel.gender = user.gender
                    self.userModel.profileImageURL = user.profileImageURL
                    self.userModel.subProfileImageURL = user.subProfileImageURLs
                    self.userModel.introduction = user.introduction
                    self.userModel.requestUids = user.requestUids
                    self.userModel.requestedUids = user.requestedUids
                    self.userModel.pairRequestUid = user.pairRequestUid
                    self.userModel.pairRequestedUids = user.pairRequestedUids
                    self.userModel.pairUid = user.pairUid
                    self.userModel.pairList = user.pairList
                    self.userModel.hobbies = user.hobbies
                    self.userModel.pairID = user.pairID
                    self.userModel.chatUnreadNum = user.chatUnreadNum
                    //
                    userModel.chatUnreadNum.forEach { unread in
                        if unread.value != 0 {
                            appState.messageListNotification = true
                        }
                    }
                    // すでに組んでるペアがいるならペアの情報をセットする。
                    if user.pairID != "" {
                        FetchFromFirestore().fetchSnapshotPairInfo(pairID: user.pairID) { pair in
                            pairModel.pair = pair.adaptPairModel()
                            // ペアの情報をAppStateで保管しておく。
                            FetchFromFirestore().fetchUserInfoFromFirestoreByUserID(uid: user.pairUid) { pair in
                                if let pair = pair {
                                    // トークン更新
                                    registerForPushNotifications { token in
                                        SetToFirestore.shared.updateFcmToken(user: userModel, pair: pairModel, newestToken: token)
                                    }
                                    appState.pairUserModel = pair.adaptUserObservableModel()
                                    isLoading = false
                                    appState.messageListViewInit = true
                                }
                            }
                        }
                    } else {
                        // トークン更新
                        isLoading = false
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $appState.notLoggedInUser) {
            EntranceView()
        }
        .fullScreenCover(isPresented: $isUserInfoSetModal) {
            NickNameView()
        }
    }
}
