//
//  ChangeImageView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/01.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

enum SheetItem: Identifiable {
    case mainImage
    case subImages
    var id: Int {
        hashValue
    }
}

struct ChangeImageView: View {
    
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
    
    @EnvironmentObject var userModel: UserObservableModel
    @Environment (\.dismiss) var dismiss
    @State var checkSelectedMainImage: UIImage?
    @State var checkSubImages:[UIImage] = []
    @State var selectedMainImage: UIImage?
    @State var subImages: [UIImage] = []
    @State var subImagesIndex: Int = 0
    @State var sheetItem: SheetItem?
    @State var loading: Bool = false
    @State var showCheckBox: Bool = false
    
    var enabledButton: Bool {
        return selectedMainImage == checkSelectedMainImage && subImages == checkSubImages
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ScrollView {
                    HStack {
                        VStack(alignment: .leading){
                            Text("プロフィール画像の追加")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .foregroundColor(Color.customBlack)
                                .padding(.top, 16)
                                .padding(.leading, 16)
                            
                            Text("画像を一枚以上追加してください。")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                                .font(.system(size: 13))
                        }
                        Spacer()
                    }
                    Button {
                        sheetItem = .mainImage
                    } label: {
                        ZStack {
                            if selectedMainImage != nil {
                                Image(uiImage: selectedMainImage!)
                                    .resizable()
                                    .frame(width: 340, height: 340)
                                    .cornerRadius(10)
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 340, height: 340)
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                            VStack {
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                Text("編集")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                            .background(
                                Circle()
                                    .foregroundColor(.gray.opacity(0.8))
                                    .frame(width: 100, height: 100)
                            )
                        }
                        
                    }
                    HStack {
                        ForEach(0..<4){ index in
                            Button {
                                subImagesIndex = index
                                sheetItem = .subImages
                            } label: {
                                VStack {
                                    ZStack {
                                        if subImages.count <= index {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: (UIScreen.main.bounds.width/4)-10, height: (UIScreen.main.bounds.width/4)-10)
                                                .foregroundColor(.gray.opacity(0.3))
                                        } else {
                                            Image(uiImage: subImages[index])
                                                .resizable()
                                                .frame(width: (UIScreen.main.bounds.width/4)-10, height: (UIScreen.main.bounds.width/4)-10)
                                        }
                                        VStack {
                                            Image(systemName: "camera")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width:20, height: 20)
                                                .foregroundColor(.white)
                                        }
                                        .background(
                                            Circle()
                                                .foregroundColor(.gray.opacity(0.8))
                                                .frame(width: 50, height: 50)
                                        )
                                    }
                                    if showCheckBox {
                                        CheckBoxView()
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button {
                    if let selectedMainImage = selectedMainImage {
                        loading = true
                        RegisterStorage().registerImageToStorage(folderName: "UserProfile", profileImage: selectedMainImage) { imageURLString in
                            userModel.profileImageURL = imageURLString
                            RegisterStorage().registerConcurrentImageToStorage(folderName: "SubImage", images: subImages) { urlStrings in
                                userModel.subProfileImageURL = urlStrings
                                SetToFirestore.shared.updateProfileImages(uid: userModel.uid, profileImageURL: userModel.profileImageURL, subImageURLs: userModel.subProfileImageURL)
                                loading = false
                                dismiss()
                            }
                        }
                    }
                } label: {
                    Text("保存する")
                        .frame(width: UIScreen.main.bounds.width-32, height: 50)
                        .background(enabledButton ? Color.gray.opacity(0.7): Color.red.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .disabled(enabledButton)
            }
            .overlay {
                if loading {
                    Color.black.opacity(0.4).ignoresSafeArea()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
            }
            if loading {
                LottieView(animationResourceName: "loading")
                    .frame(width: 100, height:100)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
        .onAppear {
            userModel.subProfileImageURL.forEach { urlString in
                getImageFromURLString(urlString: urlString) { image in
                    guard let image = image else { return }
                    subImages.append(image)
                    checkSubImages.append(image)
                }
            }
            getImageFromURLString(urlString: userModel.profileImageURL) { image in
                guard let image = image else { return }
                selectedMainImage = image
                checkSelectedMainImage = image
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .mainImage:
                ImagePicker(selectedImage: $selectedMainImage)
            case .subImages:
                SubImagePicker(
                    index: subImagesIndex,
                    selectedImages: $subImages)
            }
        }
    }
}

struct ChangeImageView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeImageView()
    }
}
