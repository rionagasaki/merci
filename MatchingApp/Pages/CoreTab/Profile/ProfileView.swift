//
//  ProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import SDWebImageSwiftUI
import PopupView
import PartialSheet
import Combine

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject var authManager = AuthenticationManager.shared
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    @StateObject var viewModel = ProfileViewModel()
    @State var cancellable = Set<AnyCancellable>()
    
    var body: some View {
        ScrollView {
            VStack {
                UserBasicProfileView(userModel: userModel)
                
                FriendsSectionView(snsShareHalfSheet: $viewModel.snsShareHalfSheet)
                Button {
                    self.viewModel.webUrlString = "https://bow-elm-3dc.notion.site/merci-b6582adddfa346528d17bf0b76c5ec06?pvs=4"
                    self.viewModel.isWebView = true
                } label: {
                    ZStack {
                        Image("Banner1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width-32, height: 72)
                            .cornerRadius(10)
                        Label {
                            Text("サービス内容はこちらから")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 18, weight: .medium))
                        } icon: {
                            Image("Kamishibai")
                                .resizable()
                                .scaledToFit()
                                .frame(width:48, height: 48)
                        }
                        
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customLightGray, lineWidth: 2)
                    }
                }
                .padding(.top, 16)
                HStack {
                    ProfileHeaderBottom(imageName: "Banner2", text: "⚙️追加機能のリクエスト", textColor: .customBlack){
                        
                    }
                    ProfileHeaderBottom(imageName: "Banner3", text: "ヘルプ・お困りごと", textColor: .customBlack){
                        self.viewModel.webUrlString = "https://bow-elm-3dc.notion.site/332b4fcf752142e79f3bc9677b301f85?pvs=4"
                        self.viewModel.isWebView = true
                    }
                }
                .padding(.horizontal, 16)
                VStack {
                    Image("Entrance")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72)
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                }
                .padding(.vertical, 36)
            }
            .halfModal(isPresented: $viewModel.snsShareHalfSheet){
                SNSShareView()
            }
            
            .fullScreenCover(isPresented: $viewModel.isSettingScreen){
                SettingView()
                    .environmentObject(appState)
            }
            .fullScreenCover(isPresented: $viewModel.isNotificationScreen){
                
            }
            .fullScreenCover(isPresented: Binding(get: { authManager.user == nil }, set: { _ in })) {
                EntranceView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    VStack {
                        Button {
                            UIIFGeneratorMedium.impactOccurred()
                            viewModel.isNotificationScreen = true
                        } label: {
                            Image(systemName: "bell")
                                .font(.system(size:18, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    VStack(spacing: 2){
                        Text("プロフィール")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 24, weight: .bold))
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.customBlue.opacity(0.5))
                            .frame(height: 3)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isWebView) {
            if let url = URL(string: viewModel.webUrlString){
                WebView(loadUrl: url)
            }
        }
    }
}
