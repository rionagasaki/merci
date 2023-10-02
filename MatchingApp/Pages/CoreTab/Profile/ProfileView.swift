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
    @ObservedObject var authManager = AuthenticationManager.shared
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                if !viewModel.isNoticeAllow {
                    Text("🔔 みんなからのメッセージを見落とさないために、通知を許可してね")
                        .padding(.all, 8)
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: UIScreen.main.bounds.width-32, height: 70)
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(20)
                        .onTapGesture {
                            guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                }
                UserBasicProfileView(userModel: userModel)
                FriendsSectionView()
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .padding(.vertical, 36)
            }
            .fullScreenCover(isPresented: $viewModel.isSettingScreen){
                SettingView()
                    .environmentObject(appState)
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
        .fullScreenCover(isPresented: $viewModel.isNotificationScreen){
            NoticeView()
        }
        .fullScreenCover(isPresented: $viewModel.isWebView) {
            if let url = URL(string: viewModel.webUrlString){
                WebView(loadUrl: url)
            }
        }
        .onAppear {
            viewModel.checkNotificationAuthorizationStatus()
        }
    }
}
