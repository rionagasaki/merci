// swiftlint:disable all
import Amplify
import Foundation

public struct Message: Model {
  public let id: String
  public var text: String
  public var createdAt: String
  public var user: String
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      text: String,
      createdAt: String,
      user: String) {
    self.init(id: id,
      text: text,
      createdAt: createdAt,
      user: user,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      text: String,
      createdAt: String,
      user: String,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.text = text
      self.createdAt = createdAt
      self.user = user
      self.updatedAt = updatedAt
  }
}