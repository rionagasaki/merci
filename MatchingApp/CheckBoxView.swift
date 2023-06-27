//
//  CheckBoxView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/05.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var select: Bool
    var body: some View {
        ZStack {
            Button {
                select.toggle()
            } label: {
                Circle()
                    .stroke(.pink.opacity(0.7), lineWidth: 1)
                    .frame(width: 20, height:20)
            }

            if select {
                Circle()
                    .foregroundColor(.pink.opacity(0.7))
                    .frame(width: 16, height:16)
            }
        }
    }
}
