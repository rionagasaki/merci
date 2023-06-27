//
//  SendNotification.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/12.
//

import Foundation
import UserNotifications
import Intents

func sendNotification(imageName: String) {
    var content = UNMutableNotificationContent()
    content.title = "Title"
    content.body = "Body"
    content.sound = .default
    
    guard let url = URL(string: "") else { return }
    let avatar = INImage(url: url)
    
    var personNameComponents = PersonNameComponents()
    personNameComponents.nickname = ""
    let senderPerson = INPerson(
        personHandle: INPersonHandle(value: "value", type: .unknown),
        nameComponents: personNameComponents,
        displayName: "Sender Name",
        image: avatar,
        contactIdentifier: nil,
        customIdentifier: nil,
        isMe: false,
        suggestionType: .none
    )
    
    let intent = INSendMessageIntent(
        recipients: nil,
        outgoingMessageType: .outgoingMessageText,
        content: nil, speakableGroupName: INSpeakableString(spokenPhrase: "Group Name"),
        conversationIdentifier: "conversationId",
        serviceName: nil,
        sender: senderPerson,
        attachments: nil
    )
    
    do {
         content = try content.updating(from: intent) as! UNMutableNotificationContent
     } catch {
         print(error.localizedDescription)
     }

     let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
     let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
     UNUserNotificationCenter.current().add(request)
}
