//
//  MainImageView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/25.
//

import SwiftUI

struct MainImageView: View {
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
    @Binding var presentationMode: PresentationMode
    
    @Environment(\.dismiss) var dismiss
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    var isEnabled: Bool {
        selectedImage != nil
    }
    
    @State var isLoading: Bool = false
    
    var body: some View {
        if !isLoading {
            VStack {
                ScrollView {
                    VStack {
                        VStack {
                            Text("プロフィール画像の追加")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .foregroundColor(Color.customBlack)
                                .padding(.top, 16)
                                .padding(.leading, 16)
                            
                            Text("画像を一枚以上追加してください。\nプロフィール画像はあとから変更できます。")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                                .font(.system(size: 13))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        BannerView()
                        
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
                                .foregroundColor(.pink)
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
                                                
                                                Image("Girl")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: (UIScreen.main.bounds.width)-32, height: (UIScreen.main.bounds.width)-32)
                                                    .cornerRadius(10)
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
                    }
                }
                .sheet(item: $sheetItem) { item in
                    switch item {
                    case .mainImage: ImagePicker(selectedImage: $selectedImage)
                    case .subImages: SubImagePicker(index: subImagesIndex, selectedImages: $subImages)
                    }
                }
                Spacer()
                if isEnabled {
                    Button {
                        isLoading = true
                        guard let selectedImage = selectedImage else { return }
                        RegisterStorage().registerImageToStorage(folderName: "UserProfile", profileImage: selectedImage){ imageURLString in
                            userModel.profileImageURL = imageURLString
                            guard let uid = AuthenticationManager.shared.uid else { return }
                            guard let email = AuthenticationManager.shared.email else { return }
                            userModel.uid = uid
                            userModel.email = email
                            RegisterStorage().registerConcurrentImageToStorage(folderName: "SubImages", images: subImages) { subProfileImageURLs in
                                SetToFirestore.shared.registerUserInfoFirestore(
                                    uid: userModel.uid,
                                    nickname: userModel.nickname,
                                    email: userModel.email,
                                    profileImageURL: userModel.profileImageURL,
                                    subProfileImageURLs: subProfileImageURLs,
                                    gender: userModel.gender,
                                    activityRegion: userModel.activeRegion,
                                    birthDate: userModel.birthDate,
                                    introduction: userModel.introduction,
                                    hobbies: userModel.hobbies
                                ) {
                                    isLoading = false
                                    UIIFGeneratorMedium.impactOccurred()
                                    presentationMode.dismiss()
                                    appState.notLoggedInUser = false
                                }
                            }
                        }
                    } label: {
                        Text("NiNiを始める")
                            .foregroundColor(.white)
                            .bold()
                            .frame(width: UIScreen.main.bounds.width-32, height: 50)
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                } else {
                    Text("NiNiを始める")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 50)
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(10)
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
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
            }
        } else {
            VStack {
                Spacer()
                LottieView(animationResourceName: "rabbit")
                    .navigationBarBackButtonHidden()
                Text("アカウントを作成中...")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 30, weight: .bold))
                Spacer()
            }
        }
    }
}


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
