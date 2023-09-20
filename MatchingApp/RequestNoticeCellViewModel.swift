//
//  RequestNoticeCellViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/04.
//

import Foundation
import Combine

class RequestNoticeCellViewModel: ObservableObject {
    @Published var userService = UserFirestoreService()
}
