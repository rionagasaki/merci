//
//  SettingCallTopicViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/05.
//

import Foundation
import Combine
import AmazonChimeSDK

class CreateCallViewModel: ObservableObject {
    
    @Published var channelId: String = ""
    @Published var channelTags: [String] = []
    @Published var isCallModal = false
    @Published var isErrorAlert: Bool = false
    @Published var session: DefaultMeetingSession?
    @Published var errorMessage: String = ""
    
    func generateUID() -> UInt {
        return UInt(arc4random_uniform(UInt32.max))
    }
}
