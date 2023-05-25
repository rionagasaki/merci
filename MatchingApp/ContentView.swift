//
//  ContentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Tab = .home
    @State private var navigationTitle:String = ""
    @State private var navigationStyle:Bool = true
    @State private var searchWord = ""
    @EnvironmentObject var userModel: UserObservableModel
    
    var body: some View {
        NavigationView {
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
                }.tag(Tab.home)
                    .ignoresSafeArea()
                
                NavigationView {
                    VStack{
                        GoodsListView()
                        Divider()
                        CustomTabView(
                            selectedTab: $selectedTab,
                            navigationTitle: $navigationTitle
                        )
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }.tag(Tab.good)
                    .ignoresSafeArea()
                
                NavigationView {
                    VStack{
                        MakeRecuruitView()
                        Divider()
                        CustomTabView(
                            selectedTab: $selectedTab,
                            navigationTitle: $navigationTitle
                        )
                    }
                    
                }.tag(Tab.add)
                
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
                }.tag(Tab.message)
                
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
                }.tag(Tab.profile)
            }
        }
        .onAppear {
            
            UITabBar.appearance().isHidden = true

            FetchFromFirestore().fetchUserInfoFromFirestore { user in
                self.userModel.nickname = user.nickname
                self.userModel.email = user.email
                self.userModel.activeRegion = user.activityRegion
                self.userModel.birthDate = user.birthDate
                self.userModel.gender = user.gender
                self.userModel.profileImageURL = user.profileImageURL
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
