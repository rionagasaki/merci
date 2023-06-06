//
//  Tab.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//
import Foundation

struct TabBar: Identifiable{
    var id = UUID()
    var menuTitle:String
    var menuImage:String
    var selectedMenuImage: String
    var tab:Tab
}

var tabItems = [
    TabBar(menuTitle: "ホーム", menuImage: "house",selectedMenuImage: "house.fill", tab: Tab.home),
    TabBar(menuTitle: "メッセージ", menuImage: "message", selectedMenuImage: "message.fill", tab: Tab.message),
    TabBar(menuTitle: "マイページ", menuImage:"person", selectedMenuImage: "person.fill", tab: Tab.profile)
]

enum Tab:String{
    case home = "home"
    case message = "message"
    case profile = "profile"
}
