//
//  HeaderImageModifier.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//
import SwiftUI

struct HeaderImageModifier: ViewModifier {
    let headerTitle: String
    func body(content: Content) -> some View {
        content
            .overlay(content: {
            ZStack(alignment: .bottomLeading){
                LinearGradient(colors: [.clear, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                Text(headerTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .font(.system(size: 24))
                    .cornerRadius(20)
                    .padding(.leading, 8)
                    .padding(.bottom, 8)
                    
            }
        })
    }
}

