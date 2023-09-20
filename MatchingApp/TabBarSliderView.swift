//
//  TabBarSliderView.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/11/22.
//

import SwiftUI

struct TabBarSliderView: View {
    let width: CGFloat
    let alignment: Alignment
    var body: some View{
        ZStack(alignment: alignment) {
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(maxWidth: .infinity)
                .frame(height: 2.0)
            Rectangle()
                .fill(Color.customBlack)
                .frame(width: width, height: 2.0)
        }
    }
}
