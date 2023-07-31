//
//  UserProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI
import SDWebImageSwiftUI
import AudioToolbox
import Combine


struct UserPairProfileView: View {
    enum UserModelState {
        case noPair
        case insufficientCoins
        case readyToChat
    }
    
    @StateObject var viewModel = UserPairProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    @Namespace var namespace
    
    @State var offset: CGFloat = 0
    let pair:PairObservableModel
    var userModelState: UserModelState {
        if userModel.user.pairUid.isEmpty {
            return .noPair
        } else if userModel.user.coins < 100 {
            return .insufficientCoins
        } else {
            return .readyToChat
        }
    }
    
    struct ActionableTextButton<Content>: View where Content: View {
        let color: Color
        let geometry: GeometryProxy
        let content: () -> Content
        
        var body: some View {
            NavigationLink {
                content()
            } label: {
                Text("メッセージを送る")
                    .frame(width: geometry.frame(in: .global).width - 90, height: 50)
                    .background(color)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .cornerRadius(30)
                    .padding(.trailing, 16)
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    ForEach(viewModel.userProfiles.indices, id: \.self) { index in
                        Button {
                            withAnimation {
                                viewModel.selectedImageIndex = index
                            }
                        } label: {
                            UserThumbnailView(
                                nickname: viewModel.userProfiles[index].user.nickname,
                                profileImageURL: viewModel.userProfiles[index].user.profileImageURL,
                                activeRegion: viewModel.userProfiles[index].user.activeRegion,
                                birthDate: viewModel.userProfiles[index].user.birthDate,
                                selection: viewModel.selectedImageIndex,
                                selfNum: index,
                                namespace: namespace
                            )
                        }
                    }
                }
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.8))
                        .frame(width: UIScreen.main.bounds.width, height: 2)
                    Rectangle()
                        .foregroundColor(.pink.opacity(0.7))
                        .frame(width: (UIScreen.main.bounds.width/2), height: 2)
                        .offset(x: viewModel.offset)
                }
            }
            .frame(height: 80)
            
            TabView(selection: $viewModel.selectedImageIndex){
                ForEach(viewModel.userProfiles.indices, id: \.self) { index in
                    DetailedUserProfileView(user: viewModel.userProfiles[index], offset: $offset)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer()
            HStack {
                GeometryReader { geometry in
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            DismissButtonView()
                        }
                        .padding(.leading, 16)
                        Spacer()
                        switch userModelState {
                        case .noPair:
                            ActionableTextButton(color: .customRed, geometry: geometry){
                                ChatRoomRequirementsView()
                            }
                        case .insufficientCoins:
                            ActionableTextButton(color: .customRed, geometry: geometry){
                                ChatRoomRequirementsView()
                            }
                        case .readyToChat:
                            ActionableTextButton(color: .customRed, geometry: geometry) {
                                ChatView(pair: pair)
                            }
                        }
                    }
                    .padding(.top, 16)
                }
                .background(.ultraThinMaterial)
                .frame(height: 70)
            }
        }
        .onAppear {
            viewModel.fetchUserInfo(pair: pair)
        }
        .onDisappear {
            viewModel.selectedImageIndex = 0
        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .sheet(isPresented: $viewModel.isReportAbuseModal){
            ReportAbuseView(pair: pair)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("相手のプロフィール")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("問題を報告する", action: { self.viewModel.isReportAbuseModal = true })
                } label: {
                    Image(systemName: "light.beacon.min")
                        .foregroundColor(.black)
                }
            }
        }
    }
}


struct DetailedUserProfileView: View {
    let user:UserObservableModel
    @Binding var offset: CGFloat
    @State var selection = 0
    @State var degree: Double = 0
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    let UIIFGeneratorError = UINotificationFeedbackGenerator()
    var allImages:[String] {
        return [user.user.profileImageURL] + user.user.subProfileImageURL
    }
    
    func generateWebImage() -> [WebImage] {
        var webImages: [WebImage] = []
        allImages.forEach { image in
            webImages.append(WebImage(url: URL(string: image)))
        }
        return webImages
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero){
                ZStack(alignment: .bottom){
                    generateWebImage()[selection]
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width-30, height: UIScreen.main.bounds.width-30)
                        .scaledToFit()
                        .cornerRadius(10)
                        .rotation3DEffect(.degrees(degree),axis: (x: 0, y: 1, z: 0))
                    HStack(spacing: .zero){
                        Button {
                            if 0 < selection {
                                UIIFGeneratorMedium.impactOccurred()
                                selection -= 1
                            } else {
                                UIIFGeneratorError.notificationOccurred(.warning)
                                withAnimation {
                                    degree = -40
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                    withAnimation {
                                        degree = 0
                                    }
                                }
                            }
                        } label: {
                            Rectangle()
                                .foregroundColor(.clear)
                        }
                        
                        Button {
                            if allImages.count - 1 > selection {
                                UIIFGeneratorMedium.impactOccurred()
                                selection += 1
                            } else {
                                UIIFGeneratorError.notificationOccurred(.warning)
                                withAnimation {
                                    degree = 40
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                    withAnimation {
                                        degree = 0
                                    }
                                }
                            }
                        } label: {
                            Rectangle()
                                .foregroundColor(.clear)
                        }
                    }
                    HStack {
                        ForEach(allImages.indices, id: \.self) { index in
                            if index == selection {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.white)
                            } else {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                if let age = CalculateAge.calculateAge(from: user.user.birthDate) {
                    HStack {
                        VStack(alignment: .leading, spacing: .zero){
                            Text(user.user.nickname)
                                .foregroundColor(.black)
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .padding(.top, 8)
                                .padding(.leading, 16)
                            Text("\(age)歳・\(user.user.activeRegion)")
                                .foregroundColor(.customBlack.opacity(0.8))
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                                .padding(.vertical, 2)
                                .padding(.leading, 16)
                        }
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                VStack {
                    VStack(alignment: .leading,spacing: 4){
                        Text("自己紹介")
                            .padding(.vertical, 8)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18, weight: .bold))
                        
                        Text(user.user.introduction)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 16))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 32)
                    .padding(.horizontal, 16)
                    
                    VStack(spacing: .zero){
                        Text("興味")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack {
                            TagViewGenerator.generateTags(UIScreen.main.bounds.width-32, tags: user.user.hobbies)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    
                    VStack {
                        Text("プロフィール")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18, weight: .bold))
                        
                        ForEach(ProfileDetailItem.allCases) { detailProfile in
                            ProfileAttributeView(user: user, selectedDetailProfile: detailProfile)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                }
            }
        }
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}


struct UserThumbnailView: View {
    let nickname: String
    let profileImageURL: String
    let activeRegion: String
    let birthDate: String
    let selection: Int
    let selfNum: Int
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                WebImage(url: URL(string: profileImageURL))
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(5)
                VStack(alignment: .leading){
                    Text(nickname)
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                    if let age = CalculateAge.calculateAge(from: birthDate) {
                        Text("\(age)歳・\(activeRegion)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    Spacer()
                }
            }
            .padding(.all, 8)
        }
    }
}
