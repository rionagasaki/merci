//
//  FilterlingChatmateViewModel.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/15.
//

import Foundation
import SwiftUI

class FilterlingChatmateViewModel: ObservableObject {
    var chatmateBinding: Binding<[UserObservableModel]>
    var chatmateKind: Binding<ChatmateKind>
    init(chatmateBinding: Binding<[UserObservableModel]>, chatmateKind: Binding<ChatmateKind>){
        self.chatmateBinding = chatmateBinding
        self.chatmateKind = chatmateKind
    }
    
    func filter(user: UserObservableModel, allChatmate:[UserObservableModel]) {
        switch chatmateKind.wrappedValue {
        case .all:
            self.chatmateBinding.wrappedValue = allChatmate
        case .friend:
            self.chatmateBinding.wrappedValue = allChatmate.filter { user.user.friendUids.contains($0.user.uid) }
        case .exceptFriend:
            self.chatmateBinding.wrappedValue = allChatmate.filter { !user.user.friendUids.contains($0.user.uid) }
        }
    }
}
