//
//  CallDetailModalViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/06.
//

import Foundation
import Combine
import AmazonChimeSDK

class CallDetailModalViewModel: ObservableObject {
    private var cancellable = Set<AnyCancellable>.init()
    private let functions: CloudFunctionsService
    @Published var isCallModal = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    init(functions: CloudFunctionsService = CloudFunctions()){
        self.functions = functions
    }
}
