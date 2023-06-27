//
//  ProfileViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/07.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var activeRegion: String = ""
    @Published var birthPlace: String = ""
    @Published var educationalBackground: String = ""
    @Published var work: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var bloodType: String = ""
    @Published var liquor: String = ""
    @Published var cigarettes: String = ""
    @Published var purpose: String = ""
    @Published var datingExpenses:String = ""
}
