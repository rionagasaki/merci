//
//  HomeView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            Text("相手をさがす")
                .foregroundColor(.black)
                .bold()
                .font(.system(size: 25))
                .padding(.all,16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(showsIndicators: false) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20){
                        NavigationLink {
                            UserProfileView()
                        } label: {
                            RecruitmentView()
                        }
                        
                        RecruitmentView()
                        RecruitmentView()
                    }
                    .padding(.top,8)
                }
            }
        }
    }
}

private func makeHeader(headerTitle: String, contentImage: Image) -> some View {
    return contentImage
        .resizable()
        .frame(width: UIScreen.main.bounds.width-30,height:200)
        .scaledToFill()
        .modifier(HeaderImageModifier(headerTitle: headerTitle))
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
