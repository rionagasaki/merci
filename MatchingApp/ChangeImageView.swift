//
//  ChangeImageView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/01.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

enum ImageSheetItem: Identifiable {
    case mainImage
    case subImages
    var id: Int {
        hashValue
    }
}

struct ChangeImageView: View {
    
    var registerButtonEnabled: Bool {
        return selectedImage != nil
    }
    
    @State var showEditImageModal: Bool = false
    
    @State var previewModal: Bool = false
    
    @State var selectedImage: UIImage?
    @State var selection: Int = 0
    
    @State var subImages: [UIImage] = []
    @State var subImagesIndex: Int = 0
    @State var sheetItem: ImageSheetItem?
    
    @State var allImages:[UIImage] = []
    
    @State var tabSection = ["メイン(必須)","サブ"]
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
                        VStack {
                            BannerView()
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            ForEach(tabSection.indices, id: \.self) { index in
                                Button {
                                    withAnimation {
                                        selection = index
                                    }
                                } label: {
                                    Text(tabSection[index])
                                        .foregroundColor(index == selection ? .customBlack: .customBlack.opacity(0.5))
                                        .font(.system(size: 16, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        .padding(.top, 24)
                        
                        ZStack(alignment: selection == 0 ? .leading: .trailing) {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.8))
                                .frame(width: UIScreen.main.bounds.width, height: 2)
                            Rectangle()
                                .foregroundColor(.pink.opacity(0.7))
                                .frame(width: (UIScreen.main.bounds.width/2), height: 2)
                        }
                        
                        TabView(selection: $selection){
                            ForEach(tabSection.indices, id: \.self) { index in
                                if index == 0 {
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
                                } else {
                                    SubImageColumnView(sheetItem: $sheetItem, subImagesIndex: $subImagesIndex, subImages: $subImages)
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: UIScreen.main.bounds.width)
                        
                        Button {
                            UIIFGeneratorMedium.impactOccurred()
                            // エラーハンドリング3
                            guard let selectedImage = selectedImage else { return }
                            RegisterStorage().registerImageToStorage(folderName: "UserProfile", profileImage: selectedImage) { imageURLString in
                                userModel.profileImageURL = imageURLString
                                RegisterStorage().registerConcurrentImageToStorage(folderName: "SubImage", images: subImages) { urlStrings in
                                    userModel.subProfileImageURL = urlStrings
                                    SetToFirestore.shared.updateProfileImages(currentUser: userModel, pair: pairModel)
                                    dismiss()
                                }
                            }
                        } label: {
                            Text("登録する😀")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width-32, height: 50)
                                .background(registerButtonEnabled ? .pink.opacity(0.7): .gray.opacity(0.4))
                                .font(.system(size: 16,weight: .bold))
                                .cornerRadius(10)
                                .padding(.top, 56)
                        }
                        .disabled(!registerButtonEnabled)
                    }
                }
                .sheet(item: $sheetItem) { item in
                    switch item {
                    case .mainImage: ImagePicker(selectedImage: $selectedImage)
                        
                    case .subImages: SubImagePicker(index: subImagesIndex, selectedImages: $subImages)
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
                            previewModal = true
                        }, label: {
                            Text("プレビュー")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.customBlack)
                        }
                    )
                }
            }
            .sheet(isPresented: $previewModal) {
                ImagePreviewView(previewImages: $allImages)
                    .onAppear {
                        subImages.insert(selectedImage!, at: 0)
                        allImages = subImages
                        subImages.removeFirst()
                    }
            }
            .onAppear {
                userModel.subProfileImageURL.forEach { urlString in
                    getImageFromURLString(urlString: urlString) { image in
                        guard let image = image else { return }
                        subImages.append(image)
                    }
                }
                getImageFromURLString(urlString: userModel.profileImageURL) { image in
                    guard let image = image else { return }
                    selectedImage = image
                }
            }
        }
    }
}
