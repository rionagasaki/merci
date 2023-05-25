//
//  GoodsListView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import SwiftUI

struct GoodsListView: View {
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Text("Hello!")
            }
        }
        .navigationTitle("もらったいいね")
    }
}

struct GoodsListView_Previews: PreviewProvider {
    static var previews: some View {
        GoodsListView()
    }
}
