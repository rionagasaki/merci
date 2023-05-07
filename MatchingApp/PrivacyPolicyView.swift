//
//  PrivacyPolicyView.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/08.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("プライバシーポリシー")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .padding(.horizontal, 16)
                Text("プライバシーポリシー")
                    .fontWeight(.light)
                    .font(.system(size: 20))
                    .padding(20)
                Text("Privacy Policy")
                    .fontWeight(.light)
            }
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
