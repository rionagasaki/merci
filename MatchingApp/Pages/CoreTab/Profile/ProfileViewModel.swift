//
//  ProfileViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/07.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var activeRegion: String = ""
    @Published var birthPlace: String = ""
    @Published var educationalBackground: String = ""
    @Published var work: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var bloodType: String = ""
    @Published var liquor: String = ""
    @Published var cigarettes: String = ""
    @Published var purpose: String = ""
    @Published var datingExpenses:String = ""
    @Published var isShowProfileDetailEditor:Bool = false
    
    @Published var snsShareHalfSheet: Bool = false
    @Published var isSettingScreen: Bool = false
    @Published var isNotificationScreen: Bool = false
    @Published var isPairProfileScreen: Bool = false
    
    @Published var detailProfileInfo: ProfileDetailItem? {
        didSet {
            isShowProfileDetailEditor = detailProfileInfo != nil
        }
    }
    
    @Published var scrollOffset: CGFloat = 0
    
    private var cancellable = Set<AnyCancellable>()
    
}
