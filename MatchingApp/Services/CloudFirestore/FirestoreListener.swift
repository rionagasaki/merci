//
//  FirestoreListener.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/03.
//

import Foundation
import FirebaseFirestore

final class FirestoreListener {
    static let shared = FirestoreListener()
    
    private init(){}
    
    var userListener: ListenerRegistration? = nil
    var pairListener: ListenerRegistration? = nil
    var chatListener: ListenerRegistration? = nil
    var chatRoomListener: ListenerRegistration? = nil
    var callListener: ListenerRegistration? = nil
}
