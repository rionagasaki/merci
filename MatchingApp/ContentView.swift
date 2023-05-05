//
//  ContentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var app: AppState
    
    var body: some View {
        
        TabView {
            NavigationView {
                HomeView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Top View")
            .tabItem {
                VStack {
                    Image(systemName: "house")
                        .foregroundColor(.black)
                    Text("ホーム")
                        .foregroundColor(.black)
                }
            }
            
            MakeRecuruitView()
                .tabItem {
                    Image(systemName: "person")
                    Text("作成する")
                        .foregroundColor(.black)
                }
            NavigationView{
                ProfileView()
            }
            .navigationTitle("Top View")
            .tabItem {
                Image(systemName: "person")
                Text("マイページ")
                    .foregroundColor(.black)
            }
        }
        .accentColor(.black.opacity(0.8))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
