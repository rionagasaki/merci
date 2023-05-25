//
//  MessageListView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/17.
//

import SwiftUI

struct MessageListView: View {
    @StateObject var viewModel = MessageListViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: .zero){
                OneMessageListView()
                OneMessageListView()
                OneMessageListView()
                OneMessageListView()
            }
        }
        .navigationTitle("やりとり")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
