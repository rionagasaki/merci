//
//  MainImageTabView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/02.
//

import SwiftUI

struct MainImageTabView: View {
    @Binding var isPhotoPickerModal: Bool
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        Button {
            self.isPhotoPickerModal = true
        } label: {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 160, height: 160)
                    .clipShape(Circle())
            } else {
                
            }
        }
    }
}

