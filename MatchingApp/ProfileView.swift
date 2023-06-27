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


struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pairModel: PairObservableModel
    @EnvironmentObject var userModel: UserObservableModel
    @State var showingAlert: Bool = false
    @State var halfModal: Bool = false
    @State var profileModal: Bool = false
    @State var detailProfile: DetailProfile?
    @State var settingScreen: Bool = false
    @State var myProfileScreen: Bool = false
    @Binding var noPairPopup: Bool
    var isPresented: Binding<Bool> {
        Binding<Bool>(
            get: { self.detailProfile != nil },
            set: { newValue in
                if !newValue {
                    self.detailProfile = nil
                }
            }
        )
    }
    let detailProfiles:[DetailProfile] = DetailProfile.allCases
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    @StateObject var viewModel = ProfileViewModel()
    
    
    var body: some View {
        ScrollView {
            VStack {
                MyMainInfoView(userModel: userModel)
                
                NavigationLink {
                    DetailUserIntroductionView()
                        .onAppear {
                            UIIFGeneratorMedium.impactOccurred()
                        }
                } label: {
                    VStack(alignment: .leading, spacing: .zero) {
                        HStack {
                            Text("自己紹介")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 24))
                                .bold()
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        
                        if userModel.introduction == "" {
                            Text("未設定")
                                .foregroundColor(.gray.opacity(0.8))
                                .fontWeight(.light)
                                .font(.system(size: 18))
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(userModel.introduction)
                                .foregroundColor(.customBlack)
                                .padding(.horizontal, 16)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 18))
                        }
                    }
                }
                NavigationLink {
                    HobbiesView()
                        .onAppear {
                            UIIFGeneratorMedium.impactOccurred()
                        }
                } label: {
                    VStack(spacing: .zero){
                        Text("興味")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 24, weight: .bold))
                        
                        HStack {
                            GenerateTags.generateTags(UIScreen.main.bounds.width-32, tags: userModel.hobbies)
                            Spacer()
                        }
                    }
                    .padding(.leading, 16)
                }
                CustomDivider()
                FriendsSectionView()
                HStack {
                    Text("今のペア")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 24))
                        .bold()
                    Spacer()
                    Button {
                        UIIFGeneratorMedium.impactOccurred()
                        // ペアが存在する場合
                        if userModel.pairUid != "" {
                            profileModal = true
                        }
                        // 存在しない場合
                        else {
                            withAnimation {
                                noPairPopup = true
                            }
                        }
                    } label: {
                        ZStack {
                            Text("ペアプロフィール確認")
                                .foregroundColor(.white)
                                .padding(.all, 8)
                                .background(Color.pink.opacity(0.7))
                                .font(.system(size: 14, weight: .bold))
                                .cornerRadius(5)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                NavigationLink {
                    if userModel.pairUid == "" {
                        PairRequestWayView()
                    } else {
                        UserProfileView(user: appState.pairUserModel)
                    }
                } label: {
                    if userModel.pairUid == "" {
                        Text("未設定")
                            .foregroundColor(.gray.opacity(0.8))
                            .fontWeight(.light)
                            .font(.system(size: 14))
                            .padding(.leading, 16)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        if pairModel.pair.pair_1_uid == userModel.pairUid {
                            HStack {
                                WebImage(url: URL(string: pairModel.pair.pair_1_profileImageURL))
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                                
                                Text(pairModel.pair.pair_1_nickname)
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .light))
                                    .padding(.leading, 8)
                                Spacer()
                            }
                            .padding(.leading, 16)
                        } else {
                            HStack {
                                WebImage(url: URL(string: pairModel.pair.pair_2_profileImageURL))
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                                Text(pairModel.pair.pair_2_nickname)
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .light))
                                    .padding(.leading, 8)
                                Spacer()
                            }
                            .padding(.leading, 16)
                        }
                    }
                    
                }
                CustomDivider()
                Group {
                    Text("プロフィール")
                        .padding(.leading, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.customBlack)
                        .font(.system(size: 24, weight: .bold))
                    
                    ForEach(detailProfiles) { detailProfile in
                        Button {
                            self.detailProfile = detailProfile
                            halfModal = true
                        } label: {
                            DetailProfileCellView(user: userModel, selectedDetailProfile: detailProfile)
                        }
                    }
                    
                    CustomDivider()
                    Button {
                        SignOut.shared.signOut {
                            UIIFGeneratorMedium.impactOccurred()
                            appState.messageListViewInit = true
                            appState.notLoggedInUser = true
                            // SignOut時は全てをリセットする。
                            FetchFromFirestore().deleteListener()
                            self.userModel.uid = ""
                            self.userModel.nickname = ""
                            self.userModel.email = ""
                            self.userModel.gender = ""
                            self.userModel.activeRegion = ""
                            self.userModel.birthPlace = ""
                            self.userModel.educationalBackground = ""
                            self.userModel.work = ""
                            self.userModel.height = ""
                            self.userModel.weight = ""
                            self.userModel.bloodType = ""
                            self.userModel.liquor = ""
                            self.userModel.cigarettes = ""
                            self.userModel.purpose = ""
                            self.userModel.datingExpenses = ""
                            self.userModel.friendUids = []
                            self.userModel.birthDate = ""
                            self.userModel.profileImageURL = ""
                            self.userModel.subProfileImageURL = []
                            self.userModel.introduction = ""
                            self.userModel.requestUids = []
                            self.userModel.requestedUids = []
                            self.userModel.pairRequestUid = ""
                            self.userModel.pairRequestedUids = []
                            self.userModel.pairUid = ""
                            self.userModel.hobbies = []
                            self.userModel.pairID = ""
                            self.userModel.chatUnreadNum = [:]
                        }
                    } label: {
                        Text("ログアウト")
                            .foregroundColor(.red)
                            .padding(.vertical, 16)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $settingScreen){
            SettingView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                VStack {
                    Button {
                        UIIFGeneratorMedium.impactOccurred()
                        settingScreen = true
                    } label: {
                        Image(systemName: "gearshape.fill")
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
                        myProfileScreen = true
                    } label: {
                        Image(systemName: "person.text.rectangle")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .partialSheet(isPresented: isPresented){
            if detailProfile == .activeRegion {
                DetailProfilePickerView(
                    fieldName: "activityRegion" ,
                    pickerItems: PickerItems.activeRegion,
                    selectedValue: $viewModel.activeRegion,
                    detailProfile: $detailProfile
                )
            } else if detailProfile == .birthPlace {
                DetailProfilePickerView(
                    fieldName: "birthPlace",
                    pickerItems: PickerItems.birthPlace,
                    selectedValue: $viewModel.birthPlace,
                    detailProfile: $detailProfile)
            } else if detailProfile == .educationalBackground {
                DetailProfilePickerView(
                    fieldName: "educationalBackground",
                    pickerItems: PickerItems.educationalBackground,
                    selectedValue: $viewModel.educationalBackground,
                    detailProfile: $detailProfile)
            } else if detailProfile == .work {
                DetailProfilePickerView(
                    fieldName: "work",
                    pickerItems: PickerItems.work,
                    selectedValue: $viewModel.educationalBackground,
                    detailProfile: $detailProfile)
            } else if detailProfile == .height {
                DetailProfilePickerView(
                    fieldName: "height",
                    pickerItems: PickerItems.heights,
                    selectedValue: $viewModel.height,
                    detailProfile: $detailProfile)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("プロフィール")
                    .foregroundColor(.black)
                    .font(.system(size: 22, weight: .bold))
            }
        }
//        (item: $detailProfile){ item in
//            switch item {
//            case .activeRegion: DetailProfilePickerView(
//                fieldName: "activityRegion" ,
//                pickerItems: PickerItems.activeRegion,
//                selectedValue: $viewModel.activeRegion,
//                detailProfile: $detailProfile
//            )
//            case .birthPlace: DetailProfilePickerView(
//                fieldName: "birthPlace",
//                pickerItems: PickerItems.birthPlace,
//                selectedValue: $viewModel.birthPlace,
//                detailProfile: $detailProfile)
//            case .educationalBackground: DetailProfilePickerView(
//                fieldName: "educationalBackground",
//                pickerItems: PickerItems.educationalBackground,
//                selectedValue: $viewModel.educationalBackground,
//                detailProfile: $detailProfile)
//            case .work: DetailProfilePickerView(
//                fieldName: "work",
//                pickerItems: PickerItems.work,
//                selectedValue: $viewModel.educationalBackground,
//                detailProfile: $detailProfile)
//            case .height: DetailProfilePickerView(
//                fieldName: "height",
//                pickerItems: PickerItems.heights,
//                selectedValue: $viewModel.height,
//                detailProfile: $detailProfile)
//            case .weight: DetailProfilePickerView(
//                fieldName: "weight",
//                pickerItems: PickerItems.weights,
//                selectedValue: $viewModel.weight,
//                detailProfile: $detailProfile)
//            case .bloodType: DetailProfilePickerView(
//                fieldName: "bloodType",
//                pickerItems: PickerItems.bloodType,
//                selectedValue: $viewModel.bloodType,
//                detailProfile: $detailProfile)
//            case .liquor: DetailProfilePickerView(
//                fieldName: "liquor",
//                pickerItems: PickerItems.liquor,
//                selectedValue: $viewModel.liquor,
//                detailProfile: $detailProfile)
//            case .cigarettes: DetailProfilePickerView(
//                fieldName: "cigarettes",
//                pickerItems: PickerItems.cigarettes,
//                selectedValue: $viewModel.cigarettes,
//                detailProfile: $detailProfile)
//            case .purpose: DetailProfilePickerView(
//                fieldName: "purpose",
//                pickerItems: PickerItems.purpose,
//                selectedValue: $viewModel.cigarettes,
//                detailProfile: $detailProfile)
//            case .datingExpenses: DetailProfilePickerView(
//                fieldName: "datingExpenses",
//                pickerItems: PickerItems.datingExpenses,
//                selectedValue: $viewModel.datingExpenses,
//                detailProfile: $detailProfile)
//            }
//        }
        .fullScreenCover(isPresented: $profileModal) {
            ModalGroupProfileView(pair: pairModel)
        }
    }
}

struct DetailProfileInfo: Hashable, Identifiable {
    var id = UUID()
    var title: String
    var detailProfile: DetailProfile
}


enum DetailProfile: String, CaseIterable, Identifiable {
    var id: Int {
        hashValue
    }
    case activeRegion = "活動地域"
    case birthPlace = "出身地"
    case educationalBackground = "学歴"
    case work = "仕事"
    case height = "身長"
    case weight = "体型"
    case bloodType = "血液型"
    case liquor = "お酒"
    case cigarettes = "煙草"
    case purpose = "目的"
    case datingExpenses = "費用"
}
