//
//  CreateMovieView.swift
//  MovieShare
//
//  Created by Rio Nagasaki on 2023/07/24.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI
import AlertToast


struct ConcernCategory {
    let name: String
    let imageName: String
}

enum ConcernKind: CaseIterable {
    case study
    case work
    case love
    case health
    case family
    
    var category: ConcernCategory {
        switch self {
        case .study:
            return ConcernCategory(name: "勉強の悩み", imageName: "Study")
        case .work:
            return ConcernCategory(name: "仕事の悩み", imageName: "Work")
        case .love:
            return ConcernCategory(name: "恋愛の悩み", imageName: "Couple")
        case .health:
            return ConcernCategory(name: "健康の悩み", imageName: "Trust")
        case .family:
            return ConcernCategory(name: "家族の悩み", imageName: "Family")
        }
    }
}


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
                    
                    if viewModel.isConcern { Divider() }
                    
                    VStack(alignment: .leading){
                        if viewModel.isConcern {
                            Menu {
                                ForEach(ConcernKind.allCases, id: \.self) { kind in
                                    Button {
                                        self.viewModel.concernKind = kind
                                    } label: {
                                        Label {
                                            Text(kind.category.name)
                                        } icon: {
                                            Image(kind.category.imageName)
                                        }

                                    }
                                }
                            } label: {
                                if let concernKind = viewModel.concernKind {
                                    HStack {
                                        Text(concernKind.category.name)
                                            .foregroundColor(.customBlack)
                                            .font(.system(size: 16, weight: .medium))
                                        Image(concernKind.category.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 16, height: 16)
                                            .padding(.all, 8)
                                            .background(Color.customLightGray)
                                            .clipShape(Circle())
                                    }
                                } else {
                                    Label {
                                        Text("相談したいお悩みの種類を選択してね")
                                            .font(.system(size: 16))
                                    } icon: {
                                        Image(systemName: "line.horizontal.3.decrease")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 10, height: 10)
                                    }
                                    .foregroundColor(.customBlack)
                                }
                            }
                            .padding(.leading, 16)
                        }
                    
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
                                Text("とめどなくつぶやきたい気分...")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .padding(.top, 23)
                                    .padding(.leading, 13)
                            }
                        }
                        if !viewModel.contentImages.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack {
                                    ForEach(viewModel.contentImages.indices, id: \.self) { index in
                                        ZStack(alignment: .topTrailing){
                                            Image(uiImage: viewModel.contentImages[index])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    
                                                }
                                            Image(systemName: "xmark.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
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
                HStack {
                    Spacer()
                    
                    VStack(spacing: 2){
                        Text("お悩み投稿\(viewModel.isConcern ? "オン": "オフ")")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 12, weight: .medium))
                        
                        Toggle("お悩みカテゴリー", isOn: Binding(
                            get: { viewModel.isConcern },
                            set: { newValue in
                                withAnimation {
                                    viewModel.isConcern = newValue
                                }
                            }
                        ))
                        .labelsHidden()
                    }
                    .padding(.trailing, 16)
                    PhotosPicker(
                        selection: $viewModel.photoPickerItem,
                        maxSelectionCount: 2,
                        selectionBehavior: .ordered,
                        matching: .images,
                        preferredItemEncoding: .current,
                        photoLibrary: .shared()) {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                                .padding(.all, 16)
                                .background(Color.customBlue.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding(.bottom, 16)
                        .padding(.trailing, 16)
                        .onChange(of: viewModel.photoPickerItem) { photoPickerItems in
                            Task {
                                do {
                                    try await viewModel.photoPickerChanged(photoPickerItems: photoPickerItems)
                                } catch {
                                    viewModel.errorMessage = error.localizedDescription
                                    viewModel.isErrorAlert = true
                                }
                            }
                        }
                }
            }
            .padding(.leading, 8)
            .padding(.top, 8)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .onAppear {
                self.focus = true
            }
            .onReceive(viewModel.$isPostSuccess){
                if $0 { dismiss() }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        Task {
                            UIIFGeneratorMedium.impactOccurred()
                            
                            if viewModel.isConcern {
                                await viewModel.addConcernPost(user: user)
                            } else {
                                await viewModel.addPost(userModel: user)
                            }
                            self.reloadPost.isRequiredReload = true
                        }
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
                                .background(viewModel.text.isEmpty || viewModel.isLoading ? Color.gray.opacity(0.3): Color.customRed)
                                .cornerRadius(25)
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.text.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
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
            }
            .alert(isPresented: $viewModel.isErrorAlert) {
                Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
            }
            .toast(isPresenting: $viewModel.isCreateConcerAlert) {
                AlertToast(displayMode: .banner(.pop), type: .complete(Color.green), title: "みんなからのメッセージを待とう🎵", subTitle: "一覧画面には表示されないよ。")
            }
        }
    }
}


