//
//  RootView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @State var isLogin: Bool = true
    var body: some View {
        Group {
            ContentView()

        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
