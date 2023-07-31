//
//  AgoraRep.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/29.
//

import Foundation
import SwiftUI
import AgoraRtcKit

struct AgoraRep: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let agoraViewController = AgoraViewController.init()
        agoraViewController.agoraDelegate = context.coordinator
        return agoraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator: NSObject, AgoraRtcEngineDelegate {
        var parent: AgoraRep
        init(_ agoraRep: AgoraRep) {
            parent = agoraRep
        }
    }
}
