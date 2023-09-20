//
//  JoinCallViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/06.
//

import Foundation
import AmazonChimeSDK

class JoinCallViewModel: ObservableObject {
    @Published var isCallDetailModal: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var isActive: Bool = false
    // ここにSessionを持たせておく
    @Published var meetingSession: DefaultMeetingSession?
}
