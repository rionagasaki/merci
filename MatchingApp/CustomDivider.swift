//
//  CustomDivider.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        ZStack(alignment: .top){
            Rectangle()
                .foregroundColor(.gray.opacity(0.2))
                .frame(width: UIScreen.main.bounds.width, height: 10)
            Divider()
                .frame(height: 3)
        }
    }
}
