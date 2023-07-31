//
//  MainImageTabView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/02.
//

import SwiftUI

struct MainImageTabView: View {
    @Binding var sheetItem: ImageSheetItem?
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        Button {
            sheetItem = .mainImage
        } label: {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: (UIScreen.main.bounds.width)-32, height: (UIScreen.main.bounds.width)-32)
                    .cornerRadius(10)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: (UIScreen.main.bounds.width)-32, height: (UIScreen.main.bounds.width)-32)
                        .foregroundColor(.gray.opacity(0.3))
                    VStack {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                        Text("編集")
                            .foregroundColor(.white)
                            .font(.system(size: 10))
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
}

