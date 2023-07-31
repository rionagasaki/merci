//
//  ChangeImageView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/01.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie
import Combine

struct ProfileImageChangeView: View {
    
    @StateObject var viewModel = ProfileImageChangeViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    
    @Environment(\.dismiss) var dismiss
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    func getImageFromURLString(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack {
                        VStack(alignment: .leading){
                            Text("プロフィール画像の追加")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .foregroundColor(Color.customBlack)
                                .padding(.top, 16)
                                .padding(.leading, 16)
                            
                            Text("画像を一枚以上追加してください。\nプロフィール画像あとから変更できます。")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                                .font(.system(size: 13))
                        }
                        HStack {
                            ForEach(viewModel.tabSections.indices, id: \.self) { index in
                                Button {
                                    withAnimation {
                                        viewModel.selection = index
                                    }
                                } label: {
                                    Text(viewModel.tabSections[index])
                                        .foregroundColor(index == viewModel.selection ? .customBlack: .customBlack.opacity(0.5))
                                        .font(.system(size: 16, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        .padding(.top, 24)
                        
                        ZStack(alignment: viewModel.selection == 0 ? .leading: .trailing) {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.8))
                                .frame(width: UIScreen.main.bounds.width, height: 2)
                            Rectangle()
                                .foregroundColor(.pink.opacity(0.7))
                                .frame(width: (UIScreen.main.bounds.width/2), height: 2)
                        }
                        
                        TabView(selection: $viewModel.selection) {
                            MainImageTabView(sheetItem: $viewModel.sheetItem, selectedImage: $viewModel.selectedImage)
                                .tag(0)
                            SubImageColumnView(sheetItem: $viewModel.sheetItem, subImagesIndex: $viewModel.subImageIndex, subImages: $viewModel.subImages)
                                .tag(1)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: UIScreen.main.bounds.width)
                        
                        Button {
                            UIIFGeneratorMedium.impactOccurred()
                            viewModel.uploadImages(userModel: userModel, pairModel: pairModel) { result in
                                switch result {
                                case .success(_):
                                    dismiss()
                                case .failure(let error):
                                    viewModel.isErrorAlert = true
                                    viewModel.errorMessage = error.errorMessage
                                }
                            }
                        } label: {
                            Text("登録する")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width-32, height: 50)
                                .background(viewModel.registerButtonEnabled ? .pink: .gray.opacity(0.4))
                                .font(.system(size: 16,weight: .bold))
                                .cornerRadius(10)
                                .padding(.top, 56)
                        }
                        .disabled(!viewModel.registerButtonEnabled)
                    }
                }
                .sheet(item: $viewModel.sheetItem) { item in
                    switch item {
                    case .mainImage: ImagePicker(selectedImage: $viewModel.selectedImage)
                    case .subImages: SubImagePicker(index: viewModel.subImageIndex, selectedImages: $viewModel.subImages)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                            
                        }
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            UIIFGeneratorMedium.impactOccurred()
                                viewModel.previewImagePresented = true
                        }, label: {
                            Text("プレビュー")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.customBlack)
                        }
                    )
                }
            }
            .sheet(isPresented: $viewModel.previewImagePresented) {
                ImagePreviewView(previewImages: $viewModel.allImages)
                    .onAppear {
                        viewModel.subImages.insert(viewModel.selectedImage!, at: 0)
                        viewModel.allImages = viewModel.subImages
                        viewModel.subImages.removeFirst()
                    }
            }
            .alert(isPresented: $viewModel.isErrorAlert){
                Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
            }
            .onAppear {
                viewModel.setupInitialImages(userModel: userModel)
            }
        }
    }
}
