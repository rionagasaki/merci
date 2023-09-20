//
//  ContentSearchView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/09.
//

import SwiftUI

struct ContentSearchView: View {
    @StateObject var viewModel = ContentSearchViewModel()
    @FocusState var focus: Bool
    var body: some View {
        VStack(spacing: .zero){
            
            TabBarSliderView(width: 100.0, alignment: .top)
            VStack {
                HStack(spacing: .zero){
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .focused($focus)
                        .cornerRadius(10)
                    TextField(text: $viewModel.searchQuery) {
                        Text("映画名")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .onSubmit {
                        
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .cornerRadius(10)
                    
                }
                .background(
                    ZStack {
                        Color.white
                        Color.customBlack.opacity(0.8)
                    }
                        .cornerRadius(10)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            Spacer()
        }
        
        .onAppear {
            self.focus = true
        }
    }
}
