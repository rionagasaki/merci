//
//  SubscribeUser.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/31.
//

import Foundation
import Supabase
import Realtime


class SubscribeUser {
    var client = RealtimeClient(endPoint: "https://orvbdnqleihkrbndhvow.supabase.co/realtime/v1/", params: ["apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ydmJkbnFsZWloa3JibmRodm93Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODU0NjM2MjMsImV4cCI6MjAwMTAzOTYyM30.vkJr0-XCye7AB9R38-OepzPAG3nCAPJ3poXyDfw6oTw"])
    
    init(){
        client.connect()
    }
    
    func subscribeUser(completion: @escaping(Any)-> Void){
        client.onOpen {
            let userChanges = self.client.channel(.column("id", value: "1234", table: "user", schema: "public"))
            userChanges.on(.update) { message in
                let userDic = message.payload["record"] as? [String: Any]
                print((userDic?["introduction"] as? String).orEmpty)
            }
            userChanges.subscribe()
        }
    }
}
