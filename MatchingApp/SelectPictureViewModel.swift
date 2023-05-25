//
//  SelectPictureViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/11.
//

import Foundation
import UIKit

class SelecPictureViewModel: ObservableObject {
    @Published var showingImage: Bool = false
    @Published var mainImageIcon: UIImage? = nil
}

