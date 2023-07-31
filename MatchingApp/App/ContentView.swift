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
    @EnvironmentObject var pairModel: PairObservableModel
    @ObservedObject var tokenData = TokenData.shared
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LottieView(animationResourceName: "loading")
                    .frame(width: 300, height: 300)
            } else {
                TabView(selection: $viewModel.selectedTab){
                    NavigationView {
                        VStack{
                            HomeView()
                            Divider()
                            CustomTabView(
                                selectedTab: $viewModel.selectedTab,
                                navigationTitle: $viewModel.navigationTitle
                            )
                        }
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle("🔍相手を探す")
                    }
                    .tag(Tab.home)
                    .ignoresSafeArea()
                    
                    NavigationView {
                        VStack {
                            MessageListView()
                            Divider()
                            CustomTabView(selectedTab: $viewModel.selectedTab, navigationTitle: $viewModel.navigationTitle)
                        }
                    }
                    .tag(Tab.message)
                    
                    ZStack {
                        NavigationView {
                            VStack{
                                ProfileView(
                                    noPairPopup: $viewModel.isPairSetUpRequired)
                                Divider()
                                CustomTabView(
                                    selectedTab: $viewModel.selectedTab,
                                    navigationTitle: $viewModel.navigationTitle
                                )
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("プロフィール")
                            
                        }
                    }
                    .tag(Tab.profile)
                }
            }
        }
        
        .onReceive(tokenData.$token, perform: { token in
            viewModel.updateUserTokenAndInitialUserInfo(token: token)
        })
        .onAppear {
            UITabBar.appearance().isHidden = true
            
            if !appState.notLoggedInUser {
                // 初回起動時なのにログイン中である場合はサインアウトさせる。
                if viewModel.isFirstLaunch {
                    viewModel.resetUserInfo(
                        userModel: userModel,
                        pairModel: pairModel,
                        appState: appState
                    )
                } else {
                    viewModel.initialUserInfo(
                        userModel: userModel,
                        pairModel: pairModel,
                        appState: appState
                    )
                }
            }
        }
        .fullScreenCover(isPresented: $appState.notLoggedInUser) {
            EntranceView()
        }
        .fullScreenCover(isPresented: $viewModel.isUserInfoSetupRequired, onDismiss: {
            viewModel.isRequiredOnboarding = true
        }) {
            NickNameView()
        }
        .fullScreenCover(isPresented: $viewModel.isRequiredOnboarding){
            WelcomeView()
        }
        .alert(isPresented: $viewModel.isErrorAlert) {
            Alert(title: Text("読み込みエラー"), message: Text("情報の読み込みに失敗しました。"))
        }
    }
}

