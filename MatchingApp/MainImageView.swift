//
//  MainImageView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/25.
//

import SwiftUI

struct MainImageView: View {
    @State var pictureSelectedViewVisible:Bool = false
    @State var selectedImage: UIImage?
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @Binding var presentationMode: PresentationMode
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack {
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
                Button {
                    self.pictureSelectedViewVisible = true
                } label: {
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .frame(width: 300, height: 300)
                            .cornerRadius(20)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 300, height: 300)
                                .foregroundColor(.gray.opacity(0.3))
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
                }
                Button {
                    guard let selectedImage = selectedImage else { return }
                    RegisterStorage().registerImageToStorage(folderName: "UserProfile", profileImage: selectedImage){ imageURLString in
                        userModel.profileImageURL = imageURLString
                        userModel.email = Authentication().currentUid
                        userModel.email = Authentication().userEmail
                        SetToFirestore.shared.registerUserInfoFirestore(uid: Authentication().currentUid, nickname: userModel.nickname, email: Authentication().userEmail, profileImageURL: userModel.profileImageURL, gender: userModel.gender, activityRegion: userModel.activeRegion, birthDate: userModel.birthDate) {
                            presentationMode.dismiss()
                            appState.isLogin = true
                        }
                    }
                } label: {
                    Text("登録する")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 60)
                        .background(Color.pink.opacity(0.5))
                        .cornerRadius(20)
                        .padding(.top, 56)
                }
            }
            .sheet(isPresented: $pictureSelectedViewVisible) {
                ImagePicker(selectedImage: $selectedImage)
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
        }
    }
}
