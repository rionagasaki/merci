//
//  OpenSourcePolicyView.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/08.
//
import SwiftUI

struct OpenSourceLibraryView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("オープンソースライブラリ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .padding(.horizontal, 16)
                Text("オープンソースライブラリ")
                    .fontWeight(.light)
                    .font(.system(size: 20))
                    .padding(20)
                Text("Open Source Policy")
                    .fontWeight(.light)
            }
        }
    }
}

struct OpenSourceLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        OpenSourceLibraryView()
    }
}
