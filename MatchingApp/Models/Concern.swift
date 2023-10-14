//
//  Concern.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/10/02.
//
import Foundation
import FirebaseFirestore

class Concern {
    var id: String
    var createdAt: Timestamp
    var concernText: String
    var concernKind: String
    var concernKindImageName: String
    var posterUid: String
    var posterNickname: String
    var posterProfileImageUrlStirng: String
    
    init(document: QueryDocumentSnapshot) {
        let concernDic = document.data()
        self.id = document.documentID
        self.createdAt = (concernDic["createdAt"] as? Timestamp ?? .init())
        self.concernText = (concernDic["concernText"] as? String).orEmpty
        self.concernKind = (concernDic["concernKind"] as? String).orEmpty
        self.concernKindImageName = (concernDic["concernKindImageName"] as? String).orEmpty
        self.posterUid = (concernDic["posterUid"] as? String).orEmpty
        self.posterNickname = (concernDic["posterNickName"] as? String).orEmpty
        self.posterProfileImageUrlStirng = (concernDic["posterProfileImageUrlString"] as? String).orEmpty
    }
    
    init(document: DocumentSnapshot) {
        let concernDic = document.data()
        self.id = document.documentID
        self.createdAt = (concernDic?["createdAt"] as? Timestamp ?? .init())
        self.concernText = (concernDic?["concernText"] as? String).orEmpty
        self.concernKind = (concernDic?["concernKind"] as? String).orEmpty
        self.concernKindImageName = (concernDic?["concernKindImageName"] as? String).orEmpty
        self.posterUid = (concernDic?["posterUid"] as? String).orEmpty
        self.posterNickname = (concernDic?["posterNickName"] as? String).orEmpty
        self.posterProfileImageUrlStirng = (concernDic?["posterProfileImageUrlString"] as? String).orEmpty
    }
    
    func adaptConcernObservableModel() -> ConcernObservableModel {
        return .init(
            createdAt: DateFormat.relativeDateFormat(date: self.createdAt.dateValue()),
            concernText: self.concernText,
            concernKind: self.concernKind,
            concernKindImageName: self.concernKindImageName,
            posterUid: self.posterUid,
            posterNickname: self.posterNickname,
            posterProfileImageUrlString: self.posterProfileImageUrlStirng
        )
    }
    
}

final class ConcernObservableModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: ConcernObservableModel, rhs: ConcernObservableModel) -> Bool {
        return (
            lhs.id == rhs.id &&
            lhs.createdAt == rhs.createdAt &&
            lhs.concernText == rhs.concernText &&
            lhs.concernKind == rhs.concernKind &&
            lhs.concernKindImageName == rhs.concernKindImageName &&
            lhs.posterUid == rhs.posterUid &&
            lhs.posterNickname == rhs.posterNickname &&
            lhs.posterProfileImageUrlString == rhs.posterProfileImageUrlString
        )
    }

    @Published var createdAt: String = ""
    @Published var concernText: String = ""
    @Published var concernKind: String = ""
    @Published var concernKindImageName: String = ""
    @Published var posterUid: String = ""
    @Published var posterNickname: String = ""
    @Published var posterProfileImageUrlString: String = ""
    
    init(
        createdAt: String = "",
        concernText: String = "",
        concernKind: String = "",
        concernKindImageName: String = "",
        posterUid: String = "",
        posterNickname: String = "",
        posterProfileImageUrlString: String = ""
    ){
       
        self.createdAt = createdAt
        self.concernText = concernText
        self.concernKind = concernKind
        self.concernKindImageName = concernKindImageName
        self.posterUid = posterUid
        self.posterNickname = posterNickname
        self.posterProfileImageUrlString = posterProfileImageUrlString
    }
}

