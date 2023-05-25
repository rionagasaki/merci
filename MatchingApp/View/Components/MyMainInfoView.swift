//
//  MyMainInfoView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct MyMainInfoView: View {
    @State var pictureSelectedViewVisible: Bool = false
    @StateObject var userModel: UserObservableModel
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: userModel.profileImageURL))
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                Button {
                    self.pictureSelectedViewVisible = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(.all, 12)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .frame(width: 48, height: 48)
                        .overlay(content: {
                            Circle().stroke(lineWidth: 4).foregroundColor(.white)
                        })
                        .clipShape(Circle())
                }
                .sheet(isPresented: $pictureSelectedViewVisible) {
                    SelectedPictureView()
                }
            }
            HStack {
                Text(userModel.nickname)
                    .font(.system(size: 16))
                    .bold()
                Text("\(userModel.birthDate)/\(userModel.activeRegion)")
            }
            HStack {
                VStack {
                    Text("友達")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .bold()
                    NavigationLink {
                        AddNewPairView()
                    } label: {
                        Text("追加")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .foregroundColor(.black.opacity(0.8))
                            .background(.gray.opacity(0.4))
                            .cornerRadius(15)
                    }
                    
                }
                Divider()
                VStack {
                    Text("無料会員")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .bold()
                    
                    NavigationLink {
                        PriceListView()
                    } label: {
                        Text("変更")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .foregroundColor(.black.opacity(0.8))
                            .background(.gray.opacity(0.4))
                            .cornerRadius(15)
                    }
                }
            }
            .frame(height: 100)
            CustomDivider()
        }
    }
}


