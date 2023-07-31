//
//  AgoraViewController.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/29.
//

import Foundation
import AgoraRtcKit

class AgoraViewController: UIViewController {
    var agoraKit: AgoraRtcEngineKit?
    var agoraDelegate: AgoraRtcEngineDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAgoraEngine()
        joinChannnel()
    }
    
    override func  viewWillDisappear(_ animated: Bool) {
        leaveChannnel()
        destroyInstance()
    }
    
    func initializeAgoraEngine(){
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "1d8d13868f1b44d2a6d78b4d99a119ac", delegate: agoraDelegate)
    }
    
    func joinChannnel(){
        agoraKit?.joinChannel(byToken: "007eJxTYAjusbu3f2+Ujlvr3vmNU2a3H5titK9Egm/PJb5Nk++uWHFQgcEwxSLF0NjCzCLNMMnEJMUo0SzF3CLJJMXSMtHQ0DIxWUP9aEpDICMD/8+zzIwMEAjiczOEpBaXOGck5uWl5jAwAACj0iNz", channelId: "TestChannel", info: nil, uid: 0){ _,_,_ in
            
        }
    }
    
    func leaveChannnel(){
        agoraKit?.leaveChannel()
    }
    
    func destroyInstance(){
        AgoraRtcEngineKit.destroy()
    }
}
