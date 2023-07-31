//
//  SubImageColumnView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/02.
//

import SwiftUI

struct SubImageColumnView: View {
    @Binding var sheetItem: ImageSheetItem?
    @Binding var subImagesIndex: Int
    @Binding var subImages: [UIImage]
    
    var body: some View {
        LazyVGrid(columns: [.init(),.init()], spacing: 10) {
            ForEach(0..<4) { index in
                Button {
                    subImagesIndex = index
                    sheetItem = .subImages
                } label: {
                    if subImages.count <= index {
                        ZStack {
                            Image("Food")
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width/2)-18, height: (UIScreen.main.bounds.width/2)-18)
                                .opacity(0.6)
                                .cornerRadius(10)
                            VStack {
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.white)
                                Text("編集")
                                    .foregroundColor(.white)
                                    .font(.system(size: 10))
                            }
                            .background(
                                Circle()
                                    .foregroundColor(.gray.opacity(0.8))
                                    .frame(width: 50, height: 50)
                            )
                        }
                    } else {
                        Image(uiImage: subImages[index])
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.width/2)-18, height: (UIScreen.main.bounds.width/2)-18)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
}


