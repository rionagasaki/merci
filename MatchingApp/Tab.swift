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
    TabBar(menuTitle: "募集する", menuImage: "plus",selectedMenuImage: "plus", tab: Tab.search),
    TabBar(menuTitle: "マイページ", menuImage:"person", selectedMenuImage: "person.fill", tab: Tab.profile)
]

enum Tab:String{
    case home = "home"
    case search = "search"
    case profile = "profile"
    case message = "message"
}
