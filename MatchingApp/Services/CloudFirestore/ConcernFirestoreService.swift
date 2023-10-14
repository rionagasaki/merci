//
//  ConcernFirestoreService.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/10/02.
//

import Foundation
import FirebaseFirestore

class ConcernFirestoreService {
    
    let concernPath = "Concern"
    let db = Firestore.firestore()
    let orderBy: String = "createdAt"
    private var lastLoadedDocument: DocumentSnapshot?
    
    func getConcern(after lastLoadedDocument:DocumentSnapshot? = nil) async throws -> [Concern] {
        let query = db.collection(self.concernPath).order(by: self.orderBy, descending: true).limit(to: 20)
        
        if let lastLoadedDocument = self.lastLoadedDocument {
            query.start(afterDocument: lastLoadedDocument)
        }
        
        let querySnapshots = try await query.getDocuments()
        let concerns = querySnapshots.documents.map { document in
            let concern = Concern(document: document)
            return concern
        }
        if concerns.count < 20 {
            self.lastLoadedDocument = nil
        } else {
            self.lastLoadedDocument = querySnapshots.documents.last
        }
        print("Concern: \(concerns)")
        return concerns
    }
    
    func getNextConcern() async throws -> [Concern] {
        let concerns = try await getConcern(after: self.lastLoadedDocument)
        return concerns
    }
    
    func addConcernPost(
        text concernText: String,
        kind concernKind: String,
        image concernKindImageName: String,
        posterUser: UserObservableModel) async throws -> Void {
            let concernUUID = UUID().uuidString
            try await db.collection(self.concernPath).document(concernUUID).setData([
                "createdAt": Date.init(),
                "concernText": concernText,
                "concernKind": concernKind,
                "concernKindImageName": concernKindImageName,
                "posterUid": posterUser.user.uid,
                "posterNickName": posterUser.user.nickname,
                "posterProfileImageUrlString": posterUser.user.profileImageURLString
            ])
        }
}
