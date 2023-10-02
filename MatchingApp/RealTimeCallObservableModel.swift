//
//  RealTimeCallObservableModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/11.
//

import SwiftUI

class RealTimeCallStatus: ObservableObject {
    static let shared = RealTimeCallStatus()
    private init(){}
    
    private let callService = CallFirestoreService()
    private let userService = UserFirestoreService()
    
    @Published var channelId: String = ""
    @Published var scores: [String: Double] = [:]
    @Published var isHostUid: String = ""
    @Published var isUserMutedStatus: [String: Bool] = [:]
    @Published var callingUser: [String] = []
    @Published var leaveUser: [String] = []
    @Published var dropUser: [String] = []
    
    func initial(){
        self.channelId = ""
        self.scores = [:]
        self.isUserMutedStatus = [:]
        self.callingUser = []
        self.leaveUser = []
        self.dropUser = []
    }
}
