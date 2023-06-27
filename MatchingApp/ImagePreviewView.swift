//
//  ImagePreviewView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/17.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImagePreviewView: View {
    
    @State var selection: Int = 0
    @Binding var previewImages:[UIImage]
    @Environment(\.dismiss) var dismiss
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        VStack {
            if previewImages == [] {
                VStack {
                    Image(systemName: "eyes")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.top, 40)
                    Text("画像が一枚も設定されていないため、プレビューの表示ができません💦")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 20, weight: .bold))
                }
                .padding(.horizontal, 16)
            } else {
                ZStack(alignment: .bottom){
                    Image(uiImage: previewImages[selection])
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width-30, height: UIScreen.main.bounds.width-30)
                        .scaledToFit()
                        .cornerRadius(10)
                    HStack(spacing: .zero){
                        Button {
                            if 0 < selection {
                                UIIFGeneratorMedium.impactOccurred()
                                selection -= 1
                            }
                        } label: {
                            Rectangle()
                                .foregroundColor(.clear)
                        }
                        
                        Button {
                            if previewImages.count - 1 > selection {
                                UIIFGeneratorMedium.impactOccurred()
                                selection += 1
                            }
                        } label: {
                            Rectangle()
                                .foregroundColor(.clear)
                        }
                    }
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 30, height: 3)
                            .foregroundColor(.white)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 30, height: 3)
                            .foregroundColor(.white)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 30, height: 3)
                            .foregroundColor(.white)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).frame(width: 120, height: 20).foregroundColor(.gray))
                    .padding(.bottom, 8)
                }
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("閉じる")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.pink.opacity(0.7))
                    .cornerRadius(10)
            }
        }
    }
}
