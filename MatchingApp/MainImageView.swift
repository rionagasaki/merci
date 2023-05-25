//
//  MainImageView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/25.
//

import SwiftUI

struct MainImageView: View {
    @State var pictureSelectedViewVisible:Bool = false
    @State var selectedImage: UIImage?
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                Text("プロフィール画像の追加")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(Color.customBlack)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("画像を一枚以上追加してください。\nプロフィール画像あとから変更できます。")
                    .foregroundColor(.gray.opacity(0.5))
                    .fontWeight(.light)
                Button {
                    self.pictureSelectedViewVisible = true
                } label: {
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .frame(width: 300, height: 300)
                            .cornerRadius(20)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 300, height: 300)
                                .foregroundColor(.gray.opacity(0.3))
                            VStack {
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                Text("編集")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                            .background(
                                Circle()
                                    .foregroundColor(.gray.opacity(0.8))
                                    .frame(width: 100, height: 100)
                            )
                        }
                    }
                }
            }
            .sheet(isPresented: $pictureSelectedViewVisible) {
                ImagePicker(selectedImage: $selectedImage)
            }
            Spacer()
            Button {
                print("aaaa")
            } label: {
                Text("登録する")
                    
            }
            .frame()

        }
    }
}

struct MainImageView_Previews: PreviewProvider {
    static var previews: some View {
        MainImageView()
    }
}
