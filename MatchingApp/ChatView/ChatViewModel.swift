//
//  ChatViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var trigger: Bool?
    @Published var chatList:[ChatObservableModel] = []
    func fetchMessage() async {
        
    }
    
    func subscribeMessage() {
        
    }
    
    func tappedSendButton() async {
       
    }
}


