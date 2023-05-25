//
//  SelectedPictureVie.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//

import SwiftUI

struct SelectedPictureView: View {
    @StateObject var viewModel = SelecPictureViewModel()
    
    var body: some View {
        VStack {
            Button {
                viewModel.showingImage = true
            } label: {
                (viewModel.mainImageIcon != nil)
                ? Image(uiImage: viewModel.mainImageIcon!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 300):
                Image("Person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 300)
            }
            .sheet(isPresented: $viewModel.showingImage) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.mainImageIcon)
            }
            VStack {
                HStack {
                    Image("Person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width/2)-40, height:
                                100)
                    
                    Image("Person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width/2)-40, height:
                                100)
                    
                    
                }
                HStack {
                    Image("Person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width/2)-40, height:
                                100)
                    
                    Image("Person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width/2)-40, height:
                                100)
                }
            }
            Spacer()
            Button {
//                ImageUpload(data: (viewModel.mainImageIcon?.jpegData(compressionQuality: 0.8))!).handleImageUpload()
            } label: {
                Text("保存する")
                
                    .foregroundColor(.black
                    )
                    .bold()
                    .frame(width: 300, height: 50)
                    .background(.yellow)
                    .cornerRadius(20)
            }
        }
    }
}

struct SelectedPictureView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPictureView()
    }
}
