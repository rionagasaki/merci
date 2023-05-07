//
//  ContentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var app: AppState
    @State private var selectedTab: Tab = .home
    @State private var navigationTitle:String = ""
    @State private var navigationStyle:Bool = true
    @State private var searchWord = ""
    
    init(){
        UITabBar.appearance().isHidden = true
    }
    
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
                        MakeRecuruitView()
                        Divider()
                        CustomTabView(
                            selectedTab: $selectedTab,
                            navigationTitle: $navigationTitle
                        )
                    }
                    
                }.tag(Tab.search)
                
                NavigationView {
                    VStack{
                        ProfileView()
                        Divider()
                        CustomTabView(
                            selectedTab: $selectedTab,
                            navigationTitle: $navigationTitle
                        )
                    }
                }.tag(Tab.profile)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
