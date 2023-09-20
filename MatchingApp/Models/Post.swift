//
//  Post.swift
//  SNSTictok
//
//  Created by Rio Nagasaki on 2023/06/29.
//

import Foundation
import FirebaseFirestore

class Post {
    var id: String
    var createdAt: Timestamp
    var posterUid: String
    var posterNickName: String
    var posterProfileImageUrlString: String
    var text: String
    var contentImageUrlStrings: [String] = []
    var likes: [String: String]
    var replys: [String: String]
    var mentionUserNickName: String
    var mentionUserUid: String
    var parentPosts: [String]
    var childPosts: [String]
    
    init(document: QueryDocumentSnapshot) {
        let postDic = document.data()
        self.id = document.documentID
        self.createdAt = (postDic["createdAt"] as? Timestamp ?? .init())
        self.posterUid = (postDic["posterUid"] as? String).orEmpty
        self.posterNickName = (postDic["posterNickName"] as? String).orEmpty
        self.posterProfileImageUrlString = (postDic["posterProfileImageUrlString"] as? String).orEmpty
        self.text = (postDic["text"] as? String).orEmpty
        self.contentImageUrlStrings = (postDic["contentImageUrlStrings"] as? [String]).orEmptyArray
        self.likes = (postDic["likes"] as? [String: String] ?? [:])
        self.replys = (postDic["replys"] as? [String: String] ?? [:])
        self.mentionUserNickName = (postDic["mentionUserNickName"] as? String).orEmpty
        self.mentionUserUid = (postDic["mentionUserUid"] as? String).orEmpty
        self.parentPosts = (postDic["parentPosts"] as? [String]).orEmptyArray
        self.childPosts = (postDic["childPosts"] as? [String]).orEmptyArray
    }
    
    init(document: DocumentSnapshot) {
        let postDic = document.data()
        self.id = document.documentID
        self.createdAt = (postDic?["createdAt"] as? Timestamp ?? .init())
        self.posterUid = (postDic?["posterUid"] as? String).orEmpty
        self.posterNickName = (postDic?["posterNickName"] as? String).orEmpty
        self.posterProfileImageUrlString = (postDic?["posterProfileImageUrlString"] as? String).orEmpty
        self.text = (postDic?["text"] as? String).orEmpty
        self.contentImageUrlStrings = (postDic?["contentImageUrlStrings"] as? [String]).orEmptyArray
        self.likes = (postDic?["likes"] as? [String: String] ?? [:])
        self.replys = (postDic?["replys"] as? [String: String] ?? [:])
        self.mentionUserNickName = (postDic?["mentionUserNickName"] as? String).orEmpty
        self.mentionUserUid = (postDic?["mentionUserUid"] as? String).orEmpty
        self.parentPosts = (postDic?["parentPosts"] as? [String]).orEmptyArray
        self.childPosts = (postDic?["childPosts"] as? [String]).orEmptyArray
    }
    
    func adaptPostObservableModel() -> PostObservableModel {
        return .init(
            id: self.id,
            createdAt: DateFormat.relativeDateFormat(date: self.createdAt.dateValue()),
            posterUid: self.posterUid,
            posterNickName: self.posterNickName,
            posterProfileImageUrlString: self.posterProfileImageUrlString,
            text: self.text,
            contentImageUrlStrings: self.contentImageUrlStrings,
            likes: self.likes,
            replys: self.replys,
            mentionUserNickName: self.mentionUserNickName,
            mentionUserUid: self.mentionUserUid,
            parentPosts: self.parentPosts,
            childPosts: self.childPosts
        )
    }
}


// Post情報を管理するObservableObject
final class PostObservableModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: PostObservableModel, rhs: PostObservableModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.createdAt == rhs.createdAt &&
               lhs.posterUid == rhs.posterUid &&
               lhs.posterNickName == rhs.posterNickName &&
               lhs.posterProfileImageUrlString == rhs.posterProfileImageUrlString &&
               lhs.text == rhs.text &&
               lhs.contentImageUrlStrings == rhs.contentImageUrlStrings &&
               lhs.likes == rhs.likes &&
               lhs.replys == rhs.replys &&
               lhs.mentionUserNickName == rhs.mentionUserNickName &&
               lhs.mentionUserUid == rhs.mentionUserUid &&
               lhs.parentPosts == rhs.parentPosts &&
               lhs.childPosts == rhs.childPosts
    }

    @Published var id: String = ""
    @Published var createdAt: String = ""
    @Published var posterUid: String = ""
    @Published var posterNickName: String = ""
    @Published var posterProfileImageUrlString = ""
    @Published var text: String = ""
    @Published var contentImageUrlStrings:[String] = []
    @Published var likes:[String: String] = [:]
    @Published var replys: [String: String] = [:]
    @Published var mentionUserNickName: String = ""
    @Published var mentionUserUid: String = ""
    @Published var parentPosts: [String] = []
    @Published var childPosts:[String] = []
    
    init(
        id: String = "",
        createdAt: String = "",
        posterUid: String = "",
        posterNickName: String = "",
        posterProfileImageUrlString: String = "",
        text: String = "",
        contentImageUrlStrings: [String] = [],
        likes: [String: String] = [:],
        replys: [String: String] = [:],
        mentionUserNickName: String = "",
        mentionUserUid: String = "",
        parentPosts: [String] = [],
        childPosts:[String] = []
    ){
        self.id = id
        self.createdAt = createdAt
        self.posterUid = posterUid
        self.posterNickName = posterNickName
        self.posterProfileImageUrlString = posterProfileImageUrlString
        self.text = text
        self.contentImageUrlStrings = contentImageUrlStrings
        self.likes = likes
        self.replys = replys
        self.mentionUserNickName = mentionUserNickName
        self.mentionUserUid = mentionUserUid
        self.parentPosts = parentPosts
        self.childPosts = childPosts
    }
}
