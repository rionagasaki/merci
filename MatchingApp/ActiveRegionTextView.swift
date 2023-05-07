//
//  ActiveRegionView.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/08.
//

import SwiftUI

struct ActiveRegionTextView: View {
    @StateObject private var viewModel = ActiveRegionTextViewModel()
    var body: some View {
        ScrollView {
            VStack {
                Text("活動地域を教えてね！")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                TextField("活動地域", text: $viewModel.activeRegionText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
            }
        }
    }
}

struct ActiveRegionTextView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveRegionTextView()
    }
}
