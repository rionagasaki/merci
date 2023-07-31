//
//  Network.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/08.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    @Published var path: NWPath?
    @Published var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitor")
       
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.path = path
                switch path.status {
                case .satisfied:
                    self.isConnected = true
                    
                case .requiresConnection:
                    self.isConnected = false
                case .unsatisfied:
                    self.isConnected = false
                @unknown default:
                    self.isConnected = false
                }
            }
        }

        monitor.start(queue: queue)
    }
}
