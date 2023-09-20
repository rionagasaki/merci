//
//  PointPurchaseViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/09.
//

import Foundation
import Combine
import StoreKit

class PointPurchaseViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var subProducts:[Product] = []
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func fetchProduct(){
        Future<[Product], AppError> { promise in
            Task.init {
                do {
                    let products = try await Product.products(for: [
                        "com.temporary.message_ticket_1000",
                        "com.temporary.message_ticket_2000",
                        "com.temporary.message_ticket_5000"
                    ])
                    promise(.success(products))
                } catch let error as NSError {
                    if error.domain == NSURLErrorDomain {
                        promise(.failure(.other(.netWorkError)))
                    } else {
                        if let skError = error as? SKError {
                            promise(.failure(.storekit(skError)))
                        }
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                print("products data successfully fetch!")
            case .failure(let error):
                print(error)
            }
        } receiveValue: { products in
            self.products = products
        }
        .store(in: &self.cancellable)

    }
    
    func purchase(product: Product, uid: String, givenPoint: Int){
        Future<Void, AppError> { promise in
            Task.init {
                do {
                    let result = try await product.purchase()
                    switch result {
                    case .success(let vertification):
                        switch vertification {
                        case .verified:
                            promise(.success(()))
                            break
                        case .unverified:
                            promise(.failure(.other(.verificationError)))
                        }
                    case .userCancelled:
                        break
                    case .pending:
                        break
                    @unknown default:
                        break
                    }
                } catch {
                    promise(.failure(.storekit(error)))
                }
            }
        }
        .flatMap { _ -> AnyPublisher<Void, AppError> in
            self.userService.updateUserInfo(
                currentUid: uid, key: "coins",
                value: givenPoint)
        }
        .sink { completion in
            switch completion {
            case .finished:
                print("successfully add point!")
            case .failure(let error):
                self.isErrorAlert = true
                self.errorMessage = error.errorMessage
            }
        } receiveValue: { _ in
            print("recieve value")
        }
        .store(in: &self.cancellable)
    }
    
    func restorePurchase(){
        
    }
}
