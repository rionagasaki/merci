//
//  SwiftUIView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/21.
//

import SwiftUI

struct FriendsSectionView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @State var isShareSNSModal: Bool = false
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    private var photo: Photo {
        Photo(image: Image(userModel.user.profileImageURLString), caption: "merciを共有するよ🐧")
    }
    private let dynamicLink = DynamicLink.init()
    @State var applicationDynamicLink: URL?
    @State var isErrorAlert: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink {
                    PairSettingView()
                } label: {
                    VStack {
                        Text("ユーザー検索")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                        
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 50)
                            .foregroundColor(.customBlue)
                    }
                    .frame(width: (UIScreen.main.bounds.width/2)-16, height: 120)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                }
                
                NavigationLink {
                    ProfileChangeView()
                } label: {
                    VStack {
                        Text("プロフ編集")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                        
                        Image(systemName: "person.text.rectangle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.customRed)
                    }
                    .frame(width: (UIScreen.main.bounds.width/2)-16, height: 120)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                }
                
            }
            HStack {
                NavigationLink {
                    SettingView()
                } label: {
                    VStack {
                        Text("設定")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                        
                        Image(systemName: "gearshape")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 50)
                            .foregroundColor(.purple)
                    }
                    
                    .frame(width: (UIScreen.main.bounds.width/2)-16, height: 120)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                }
                
                if let applicationDynamicLink = self.applicationDynamicLink {
                    ShareLink(item: self.applicationDynamicLink!) {
                        VStack {
                            Text("アプリを共有")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 20, weight: .bold))
                            
                            Image(systemName: "link")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.orange)
                        }
                        .frame(width: (UIScreen.main.bounds.width/2)-16, height: 120)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                    }
                } else {
                    VStack {
                        Text("アプリを共有")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                        
                        Image(systemName: "link")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                    }
                    .frame(width: (UIScreen.main.bounds.width/2)-16, height: 120)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .onTapGesture {
                        self.isErrorAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $isErrorAlert){
            Alert(title: Text("少し待ってね"), message: Text("アプリのリンクを読み込んでいます..."))
        }
        .onAppear {
            dynamicLink.createDynamicLink { result in
                switch result {
                case .success(let url):
                    self.applicationDynamicLink = url
                case .failure(_):
                    self.isErrorAlert = true
                }
            }
        }
    }
}

