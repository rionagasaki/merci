//
//  MyMainInfoView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct MyMainInfoView: View {
    @State var pictureSelectedViewVisible: Bool = false
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image("Person")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                Button {
                    self.pictureSelectedViewVisible = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(.all, 12)
                        .foregroundColor(.black)
                        .background(Color.yellow)
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
                Text("ながり")
                    .font(.system(size: 16))
                    .bold()
                Text("21歳/千葉")
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
                    Button {
                        print("aaa")
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

struct MyMainInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MyMainInfoView()
    }
}
