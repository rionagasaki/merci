//
//  RootView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        Group {
            if appState.isLogin == true {
                ContentView()
            }else{
                OnboardingView()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
