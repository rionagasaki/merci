//
//  UsagePolicyView.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/08.
//

import SwiftUI

struct UsagePolicyView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("利用規約")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .padding(.horizontal, 16)
                Text("利用規約")
                    .fontWeight(.light)
                    .font(.system(size: 20))
                    .padding(20)
                Text("Usage Policy")
                    .fontWeight(.light)
            }
        }
    }
}

struct UsagePolicyView_Previews: PreviewProvider {
    static var previews: some View {
        UsagePolicyView()
    }
}
