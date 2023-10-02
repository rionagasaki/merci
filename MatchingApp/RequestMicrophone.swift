//
//  RequestMicrophone.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/09.
//

import Foundation
import AVFoundation

class RequestMicrophone {
    
    func requestMicrophonePermission(completionHandler: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted {
                completionHandler(true)
                print("マイクへのアクセス許可が与えられました")
            } else {
                completionHandler(false)
                print("マイクへのアクセス許可が拒否されました")
            }
        }
    }
    
    func checkForPermissions() async -> Bool {
        let hasPermissions = await avAuthorization(mediaType: .audio)
        return hasPermissions
    }

    private func avAuthorization(mediaType: AVMediaType) async -> Bool {
        let mediaAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch mediaAuthorizationStatus {
        case .denied, .restricted: return false
        case .authorized: return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default: return false
        }
    }
}
