//
//  AppDelegate.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/19.
//
import UIKit
import SwiftUI
import Foundation
import FirebaseCore
import FirebaseMessaging
import Firebase
import UserNotifications
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    let setToFirestore = SetToFirestore()
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.isPersistenceEnabled = false
        db.settings = settings
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { authorized, error in
            if let error = error {
                print("Error=>UNUserNotificationCenter:\(error)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        Messaging.messaging().delegate = self
    
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print message ID.
        print(userInfo["fcm_options"])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            TokenData.shared.token = fcmToken
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        return [.badge, .banner, .list, .sound]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler()
    }
}

func registerForPushNotifications(completion: @escaping (String)-> Void) {
    Messaging.messaging().token { token, error in
        if let error = error {
            print("Error fetching FCM registration token: \(error)")
        } else if let token = token {
            print("FCM registration token: \(token)")
            completion(token)
            // TODO: Send the token to your server or save it to Firestore.
        }
    }
}
