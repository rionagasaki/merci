//
//  SelectPostKindsView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/06.
//

import SwiftUI

struct SelectPostKindsView: View {
    let user: UserObservableModel
    @State var isContentSearchModal: Bool = false
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text("何をシェアする？")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: UIScreen.main.bounds.width-32)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 32)
                NavigationLink {
                    CreatePostView(user: user)
                } label: {
                    HStack {
                        Image("Bubble")
                            .resizable()
                            .frame(width: 50, height:50)
                            .cornerRadius(10)
                        Text("つぶやき")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                            .padding(.leading, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                
                Button {
                    self.isContentSearchModal = true
                } label: {
                    HStack {
                        Image("Movie")
                            .resizable()
                            .frame(width: 50, height:50)
                            .cornerRadius(10)
                        Text("コンテンツ")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                            .padding(.leading, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 28)
                }
                
                
                HStack {
                    Image("Map")
                        .resizable()
                        .frame(width:50, height:50)
                        .cornerRadius(10)
                    Text("スポット")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.leading, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 28)
                Spacer()
            }
            .sheet(isPresented: $isContentSearchModal){
                ContentSearchView()
            }
        }
    }
}
