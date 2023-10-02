//
//  RealTimeDatabaseManager.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/28.
//

import Foundation
import FirebaseDatabase

class RealTimeDatabaseManager {
    let database = Database.database()
    let auth = AuthenticationManager.shared
    func managedUsersConnection(){
        guard let user = auth.user else { return }
        Database.database().reference(withPath: ".info/connected").observe(.value, with: { snap in
            let connected = snap.value as? Bool ?? false
            if !connected {
                return
            }
            let statusRef = self.database.reference().child("status").child(user.uid)
            
            statusRef.onDisconnectSetValue([
                "state": "offline",
                "lastChanged": ServerValue.timestamp()
            ] as [String : Any]){ error, _ in
                
                statusRef.setValue([
                    "state": "online",
                    "lastChanged": ServerValue.timestamp()
                ] as [String : Any])
            }
        })
    }
}

