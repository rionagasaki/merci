//
//  ReportPostViewModel.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/10/11.
//

import Foundation

@MainActor
final class ReportPostViewModel: ObservableObject {
    @Published var reportText: String = ""
    @Published var isSuccessPostReport: Bool = false
    @Published var isLoading: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let postService = PostFirestoreService()
    
    private func handleError(error: Error) {
        if let error = error as? AppError {
            self.errorMessage = error.errorMessage
        } else {
            self.errorMessage = error.localizedDescription
        }
        self.isErrorAlert = true
    }
    
    public func addReportToPost(from fromUserID: String, to toUserID: String, postID: String, postText: String) async {
        do {
            self.isLoading = true
            try await self.postService.addReportToPost(fromUserID: fromUserID, toUserID: toUserID, postID: postID, postText: postText, reportText: self.reportText)
            self.isSuccessPostReport = true
            self.isLoading = false
        } catch {
            self.handleError(error: error)
        }
    }
}
