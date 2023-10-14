//
//  ContentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine


struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel = ContentViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @ObservedObject var tokenData = TokenData.shared
    @ObservedObject var selectedTab = SelectedTab.shared
    @ObservedObject var authManager = AuthenticationManager.shared
    @State var homePath = [String]()
    private let realtimeDatabase = RealTimeDatabaseManager()
    var body: some View {
        VStack {
            TabView(selection: $selectedTab.selectedTab){
                VStack(spacing: .zero){
                    NavigationStack{
                        HomeView()
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .tint(.customBlack)
                    .ignoresSafeArea()
                    CustomTabView(selectedTab: $selectedTab.selectedTab)
                }
                .tag(Tab.home)
                
                VStack(spacing: .zero){
                    NavigationStack {
                        MessageListView()
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .ignoresSafeArea()
                    .tint(.customBlack)
                    CustomTabView(selectedTab: $selectedTab.selectedTab)
                }
                .tag(Tab.message)
                
                VStack(spacing: .zero){
                    NavigationStack {
                        NotificationListView()
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .ignoresSafeArea()
                    .tint(.customBlack)
                    
                    CustomTabView(selectedTab: $selectedTab.selectedTab)
                }
                .tag(Tab.notification)
                
                VStack(spacing: .zero){
                    NavigationStack {
                        ProfileView()
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .ignoresSafeArea()
                    .tint(.customBlack)
                    CustomTabView(selectedTab: $selectedTab.selectedTab)
                }
                .tag(Tab.profile)
            }
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
        .onReceive(tokenData.$token) { token in
            Task {
                await viewModel.updateUserTokenAndInitialUserInfo(token: token)
            }
        }
        .onReceive(authManager.$user.compactMap { $0 }){ user in
            viewModel.initialUserInfo(user: user, userModel: userModel, appState: appState)
            viewModel.resetChannelID(userID: user.uid)
            self.realtimeDatabase.managedUsersConnection()
        }
        .fullScreenCover(isPresented: Binding(get: { authManager.user == nil }, set: { _ in })) {
            EntranceView()
        }
        .fullScreenCover(isPresented: $viewModel.isUserInfoSetupRequired) {
            NickNameInitView()
        }
        .fullScreenCover(isPresented: $viewModel.isRequiredOnboarding){
            WelcomeView()
        }
        .alert(isPresented: $viewModel.isErrorAlert) {
            Alert(title: Text("読み込みエラー"), message: Text("情報の読み込みに失敗しました。"))
        }
    }
}

