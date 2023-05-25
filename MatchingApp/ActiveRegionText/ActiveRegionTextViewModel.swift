//
//  ActiveRegionTextViewModel.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/08.
//
import Foundation

class ActiveRegionTextViewModel: ObservableObject {
    @Published var selectedActiveRegion = ""
    let tokyo23Wards = ["千代田区", "中央区", "港区", "新宿区", "文京区", "台東区", "墨田区", "江東区", "品川区", "目黒区", "大田区", "世田谷区", "渋谷区", "中野区", "杉並区", "豊島区", "北区", "荒川区", "板橋区", "練馬区", "足立区", "葛飾区", "江戸川区"]
    
}
