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
    var body: some View {
        ZStack {
            Color.black
            WebImage(url: URL(string: imageUrlString))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width)
        }
        .ignoresSafeArea()
    }
}

