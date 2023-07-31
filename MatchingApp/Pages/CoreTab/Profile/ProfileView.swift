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

struct ProfileDetailCellData: Hashable, Identifiable {
    static func == (lhs: ProfileDetailCellData, rhs: ProfileDetailCellData) -> Bool {
        return lhs.id == rhs.id
    }
    var id = UUID()
    var storeName: String
    var title: String
    var description: String
    var pickerItem: Array<String>
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pairModel: PairObservableModel
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    @Binding var noPairPopup: Bool
    
    
    func computeNumberOfSetProfileItems() -> Int {
        let profileItems = [userModel.user.activeRegion, userModel.user.birthDate, userModel.user.birthPlace, userModel.user.bloodType, userModel.user.cigarettes, userModel.user.datingExpenses, userModel.user.educationalBackground, userModel.user.height, userModel.user.liquor]
        return profileItems.filter { !$0.isEmpty }.count
    }
    
    let detailProfiles:[ProfileDetailItem] = ProfileDetailItem.allCases
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    @StateObject var viewModel = ProfileViewModel()
    @State var cancellable = Set<AnyCancellable>()
    
    var body: some View {
        ScrollView {
            GeometryReader { geometryProxy in
                Color.clear.preference(key: ViewOffsetKey.self ,value: geometryProxy.frame(in: .named("scrollView")).minY)
            }
            .frame(height: 0)
            VStack {
                NavigationLink {
                    PairSettingView()
                } label: {
                    ProfileHeaderTopView()
                }
                
                
                UserBasicProfileView(userModel: userModel)
                
                NavigationLink {
                    UserIntroductionEditorView()
                        .onAppear {
                            UIIFGeneratorMedium.impactOccurred()
                        }
                } label: {
                    VStack(alignment: .leading, spacing: .zero) {
                        HStack {
                            Text("自己紹介")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 20))
                                .bold()
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        
                        if userModel.user.introduction.isEmpty {
                            Text("未設定")
                                .foregroundColor(.gray.opacity(0.8))
                                .fontWeight(.light)
                                .font(.system(size: 18))
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(userModel.user.introduction.replacingOccurrences(of: "\n", with: " "))
                                .foregroundColor(.customBlack)
                                .padding(.horizontal, 16)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 18))
                        }
                    }
                }
                NavigationLink {
                    UserHobbiesEditorView()
                        .onAppear {
                            UIIFGeneratorMedium.impactOccurred()
                        }
                } label: {
                    VStack(spacing: .zero){
                        Text("興味")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                        
                        HStack {
                            TagViewGenerator.generateTags(UIScreen.main.bounds.width-32, tags: userModel.user.hobbies)
                            Spacer()
                        }
                    }
                    .padding(.leading, 16)
                }
                CustomDivider()
                FriendsSectionView(snsShareHalfSheet: $viewModel.snsShareHalfSheet)
                VStack {
                    Text("プロフィール")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.customBlack)
                        .font(.system(size: 20, weight: .bold))
                    
                    ForEach(self.detailProfiles) { profile in
                        Button {
                            self.viewModel.detailProfileInfo = profile
                        } label: {
                            ProfileAttributeEditorView(user: userModel, selectedDetailProfile: profile)
                        }

                    }
                }
                .padding(.horizontal, 16)
                
            }
            .halfModal(isPresented: $viewModel.isShowProfileDetailEditor) {
                ProfileAttributeSelectorView(
                    currentValue: viewModel.detailProfileInfo?.getUserModel(userModel: userModel),
                    storedName: viewModel.detailProfileInfo?.generateProfileDetailCellData().storeName,
                    fieldName: viewModel.detailProfileInfo?.generateProfileDetailCellData().title,
                    pickerItems: viewModel.detailProfileInfo?.generateProfileDetailCellData().pickerItem ?? [],
                    description: viewModel.detailProfileInfo?.generateProfileDetailCellData().description,
                    uid: userModel.user.uid
                )
            }
            .halfModal(isPresented: $viewModel.snsShareHalfSheet){
                SNSShareView()
            }
        }
        
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ViewOffsetKey.self) { offset in
            viewModel.scrollOffset = -offset
        }
        .fullScreenCover(isPresented: $viewModel.isSettingScreen){
            SettingView()
                .environmentObject(appState)
        }
        .fullScreenCover(isPresented: $viewModel.isNotificationScreen){
            NotificationView()
        }
        .fullScreenCover(isPresented: $appState.notLoggedInUser) {
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
            ToolbarItem(placement: .navigationBarTrailing) {
                VStack {
                    Button {
                        UIIFGeneratorMedium.impactOccurred()
                        viewModel.isSettingScreen = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size:18, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                WebImage(url: URL(string: userModel.user.profileImageURL))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .opacity(viewModel.scrollOffset/400)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("プロフィール")
                    .foregroundColor(.black)
                    .font(.system(size: 22, weight: .bold))
            }
        }
        .sheet(isPresented: $viewModel.isPairProfileScreen) {
            ModalGroupProfileView(pair: pairModel)
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
