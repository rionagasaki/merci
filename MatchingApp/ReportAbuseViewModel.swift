//
//  ReportAbuseViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/10.
//

import Foundation
import SwiftUI
import Combine

class ReportAbuseViewModel: ObservableObject {
    
    @Published var reportedUserID: [String] = []
    @Published var reportText: String = ""
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var isReportSuccess: Bool = false
    private let noticeService = NoticeFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func report(reportUserID: String){
        self.noticeService.createReport(reportUserID: reportUserID, reportedUserID: self.reportedUserID, reportText: self.reportText)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isReportSuccess = true
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
}
