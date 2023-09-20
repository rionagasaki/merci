//
//  CreateMovieView.swift
//  MovieShare
//
//  Created by Rio Nagasaki on 2023/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreatePostView: View {
    @StateObject var viewModel = CreatePostViewModel()
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    @Environment(\.dismiss) var dismiss
    @ObservedObject var reloadPost = ReloadPost.shared
    let user: UserObservableModel
    
    @FocusState var focus: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top){
                    Image(user.user.profileImageURLString)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 28, height: 28)
                        .padding(.all, 4)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack {
                        ZStack(alignment: .topLeading){
                            TextEditor(text: $viewModel.text)
                                .frame(width: UIScreen.main.bounds.width/1.3, height: 200)
                                .scrollContentBackground(.hidden)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 18))
                                .focused($focus)
                                .padding(.top, 16)
                                .padding(.leading, 8)
                            if viewModel.text.isEmpty {
                                Text("今日の給食は何だろう...")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .padding(.top, 23)
                                    .padding(.leading, 13)
                                
                            }
                        }
                        if !viewModel.contentImages.isEmpty {
                            ScrollView(.horizontal){
                                HStack {
                                    ForEach(viewModel.contentImages.indices, id: \.self) { index in
                                        ZStack(alignment: .topTrailing){
                                            Image(uiImage: viewModel.contentImages[index])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(20)
                                                .onTapGesture {
                                                    
                                                }
                                            
                                            Image(systemName: "xmark.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30, height: 30)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    withAnimation {
                                                        _ = viewModel.contentImages.remove(at: index)
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width/1.3)
                }
                Spacer()
            }
            .padding(.leading, 8)
            .padding(.top, 8)
            .onAppear {
                self.focus = true
            }
            .onReceive(viewModel.$isPostSuccess){
                if $0 { dismiss() }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        UIIFGeneratorMedium.impactOccurred()
                        viewModel.addPost(userModel: user)
                        self.reloadPost.isRequiredReload = true
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                            }
                            Text("投稿する")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .disabled(viewModel.text.isEmpty)
                                .background(viewModel.text.isEmpty || viewModel.isLoading ? Color.gray.opacity(0.3): Color.customRed)
                                .cornerRadius(25)
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.text.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        self.focus = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                            dismiss()
                        }
                    } label: {
                        Text("キャンセル")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                
                ToolbarItem(placement: .keyboard){
                    HStack {
                        Button {
                            UIIFGeneratorMedium.impactOccurred()
                            self.viewModel.isImagePickerModal = true
                        } label: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.customBlack)
                        }
                        
                        Button {
                            self.viewModel.isCameraModal = true
                        } label: {
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.customBlack)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "textformat")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.customBlack)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "pencil.tip")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.customBlack)
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isImagePickerModal){
                PostImagePicker(image: $viewModel.contentImages)
            }
        }
    }
}

