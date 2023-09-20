//
//  SecretChat.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/22.
//
import Foundation
import FirebaseFirestore

class SecretChat {
    var message: String
    
    
    init(document: QueryDocumentSnapshot){
        let chatDic = document.data()
        self.message = (chatDic["message"] as? String).orEmpty
    }
    
    init(document: DocumentSnapshot){
        let chatDic = document.data()
        self.message = (chatDic?["message"] as? String).orEmpty
    }
}


// User情報を管理するObservableObject
final class SecretChatObservableModel: ObservableObject, Identifiable {
    var id = UUID()
    @Published var message: String = ""
    
    init(message: String = ""){
        self.message = message
    }
}

