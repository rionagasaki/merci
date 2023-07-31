//
//  DetailProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/07.
//

import SwiftUI
import Combine

struct ProfileAttributeSelectorView: View {
    
    let currentValue: String?
    let storedName: String?
    let fieldName: String?
    let pickerItems: Array<String>
    let description: String?
    let uid: String
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    @State var selected: Int = 0
    @StateObject var viewModel = ProfileAttributeSelectorViewModel()
    
    var body: some View {
        VStack(spacing: .zero){
            
            HStack {
                Button {
                    if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        windowScene.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }

                } label: {
                    Text("キャンセル")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                }
                Spacer()
                Button {
                    if let storedName = storedName, let currentValue = currentValue {
                        viewModel.storedProfileData(
                            uid: uid,
                            fieldName: storedName,
                            value: self.pickerItems[selected],
                            currentValue: currentValue
                        )
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            windowScene.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        }

                    }
                } label: {
                    Text("OK")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.pink)
                        .cornerRadius(20)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            if let fieldName = fieldName {
                Text(fieldName)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 26, weight: .bold))
                    .padding(.top, 24)
            }
            
            if let description = description {
                Text(description)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16))
                    .padding(.top, 8)
            }
            
            Picker(selection: $selected, label: Text("フルーツを選択")) {
                ForEach(0 ..< pickerItems.count, id: \.self) { index in
                    Text(self.pickerItems[index])
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 400)
            .padding(.top, 16)
            
            Spacer()
        }
    }
}

enum ProfileDetailItem: String, CaseIterable, Identifiable {
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
    
    func getUserModel(userModel: UserObservableModel) -> String {
        switch self {
        case .activeRegion:
            return userModel.user.activeRegion
        case .birthPlace:
            return userModel.user.birthPlace
        case .educationalBackground:
            return userModel.user.educationalBackground
        case .work:
            return userModel.user.work
        case .height:
            return userModel.user.height
        case .weight:
            return userModel.user.weight
        case .bloodType:
            return userModel.user.bloodType
        case .liquor:
            return userModel.user.liquor
        case .cigarettes:
            return userModel.user.cigarettes
        case .purpose:
            return userModel.user.purpose
        case .datingExpenses:
            return userModel.user.datingExpenses
        }
    }
    
    func generateProfileDetailCellData() -> ProfileDetailCellData {
        switch self {
        case .activeRegion:
            return .init(
                storeName: "activeRegion",
                title: "活動地域",
                description: "集まりやすい場所を教えてください",
                pickerItem: PickerItems.activeRegion
            )
        case .birthPlace:
            return .init(
                storeName: "birthPlace",
                title: "出身地",
                description: "出身地を教えてください" ,
                pickerItem: PickerItems.birthPlace
            )
        case .educationalBackground:
            return .init(
                storeName: "educationalBackground",
                title: "学歴",
                description: "あなたの学歴を教えてください",
                pickerItem: PickerItems.educationalBackground
            )
        case .work:
            return .init(
                storeName: "work",
                title: "仕事",
                description: "あなたの仕事について教えてください",
                pickerItem: PickerItems.work
            )
        case .height:
            return .init(
                storeName: "height",
                title: "身長",
                description: "身長を教えてください",
                pickerItem: PickerItems.heights
            )
        case .weight:
            return .init(
                storeName: "weight",
                title: "体型",
                description: "体型を教えてください",
                pickerItem: PickerItems.weights
            )
        case .bloodType:
            return .init(
                storeName: "bloodType",
                title: "血液型",
                description: "血液型を教えてください",
                pickerItem: PickerItems.bloodType
            )
        case .liquor:
            return .init(
                storeName: "liquor",
                title: "お酒",
                description: "お酒を飲みますか？",
                pickerItem: PickerItems.liquor
            )
        case .cigarettes:
            return .init(
                storeName: "cigarettes",
                title: "煙草",
                description: "煙草を吸いますか？",
                pickerItem: PickerItems.cigarettes
            )
        case .purpose:
            return .init(
                storeName: "purpose",
                title: "目的",
                description: "アプリを使う目的を教えてください",
                pickerItem: PickerItems.purpose
            )
        case .datingExpenses:
            return .init(
                storeName: "datingExpenses",
                title: "費用",
                description: "デート代はどちらが負担しますか？",
                pickerItem: PickerItems.datingExpenses
            )
        }
    }
}

extension ProfileDetailItem {
    var caseName: String {
        return "\(self)".split(separator: ".").map(String.init).last ?? ""
    }
}



struct SelectedProfileCellList {
    var detailProfile: ProfileDetailItem
    var selected: String
}
