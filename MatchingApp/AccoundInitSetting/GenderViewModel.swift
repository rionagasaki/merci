//
//  GenderViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import Foundation

class GenderViewModel: ObservableObject {
    let gender = ["男性", "女性"]
    @Published var selectedGender: String = ""
}
