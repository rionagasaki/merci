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
            ScrollView {
                VStack(alignment: .center){
                    TabView(selection: $viewModel.selection){
                        ForEach(viewModel.headers.indices, id: \.self) { index in
                            makeHeader(
                                headerTitle: viewModel.headers[index].headerTitle,
                                contentImage: Image(viewModel.headers[index].headerImageString)
                            ).tag(index)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width-30,height:200)
                }
                HStack(alignment: .bottom){
                    Text("募集中")
                        .foregroundColor(.black)
                        .bold()
                        .font(.system(size: 18))
                        .padding(.leading,16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    NavigationLink {
                       RecuruitmentListView()
                    } label: {
                        Text("もっと見る")
                            .foregroundColor(.blue.opacity(0.6))
                            .bold()
                            .font(.system(size: 14))
                            .padding(.trailing,16)
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        RecruitmentView()
                        RecruitmentView()
                        RecruitmentView()
                    }
                }
                Text("場所から探す")
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 18))
                    .padding(.top, 16)
                    .padding(.leading,16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                PlacePanelView()
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
