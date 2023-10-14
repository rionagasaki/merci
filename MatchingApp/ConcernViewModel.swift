

import Foundation

@MainActor
final class ConcernViewModel: ObservableObject {
    @Published var concerns: [Concern] = []
    @Published var isLoading: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLastDocmentReload: Bool = false
    private let concernService = ConcernFirestoreService()
    
    func initConcern() async {
        self.isLoading = true
        
        // finish loading when go out of this scope.
        defer { self.isLoading = false }
        
        do {
            let concerns = try await self.concernService.getConcern()
            
            if concerns.count < 20 {
                self.isLastDocmentReload = true
            }
            
            self.concerns = concerns
            
        } catch {
            let appError = AppError.firestore(error)
            self.errorMessage = appError.errorMessage
            self.isErrorAlert = true
        }
    }
    
    func refreshLatestConcern() async {
        self.concerns = []
        do {
            let concerns = try await self.concernService.getConcern()
            
            if concerns.count < 20 {
                self.isLastDocmentReload = true
            }
            
            self.concerns = concerns
            
        } catch {
            let appError = AppError.firestore(error)
            self.errorMessage = appError.errorMessage
            self.isErrorAlert = true
        }
    }
    
    func getNextConcern() async {
        do {
            let newConceern = try await self.concernService.getNextConcern()
            self.concerns = self.concerns + newConceern
        } catch {
            let appError = AppError.firestore(error)
            self.errorMessage = appError.errorMessage
            self.isErrorAlert = true
        }
    }


}
