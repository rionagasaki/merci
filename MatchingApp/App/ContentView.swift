//
//  ContentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine


struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @ObservedObject var tokenData = TokenData.shared
    @ObservedObject var selectedTab = SelectedTab.shared
    @ObservedObject var authManager = AuthenticationManager.shared
    @State var homePath = [String]()
    var body: some View {
        VStack {
            TabView(selection: $selectedTab.selectedTab){
                VStack(spacing: .zero){
                    NavigationStack{
                        HomeView()
                            .navigationBarTitleDisplayMode(.inline)
                    }
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
                    CustomTabView(selectedTab: $selectedTab.selectedTab)
                }
                .tag(Tab.message)
                
                VStack(spacing: .zero){
                    NavigationView {
                        NotificationListView()
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .ignoresSafeArea()
                    
                    CustomTabView(selectedTab: $selectedTab.selectedTab)
                }
                .tag(Tab.notification)
                
                NavigationView {
                    VStack(spacing: .zero){
                        ProfileView()
                        CustomTabView(selectedTab: $selectedTab.selectedTab)
                    }
                }
                .tag(Tab.profile)
            }
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
        .onReceive(tokenData.$token){ token in
            viewModel.updateUserTokenAndInitialUserInfo(token: token)
        }
        .onReceive(authManager.$user.compactMap { $0 }){ user in
            if viewModel.isFirstLaunch {
                viewModel.resetUserInfo(
                    userModel: userModel,
                    appState: appState
                )
            } else {
                viewModel.initialUserInfo(user: user, userModel: userModel, appState: appState)
            }
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

