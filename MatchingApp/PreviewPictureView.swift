//
//  PreviewPictureView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/10.
//

import SwiftUI
import SDWebImageSwiftUI
struct PreviewPictureView: View {
    let imageUrlString: String
    let postText: String
    var body: some View {
        ZStack {
            Color.black
            VStack {
                WebImage(url: URL(string: imageUrlString))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                    .cornerRadius(20)
                HStack {
                    Text(postText)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 8)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea()
    }
}

