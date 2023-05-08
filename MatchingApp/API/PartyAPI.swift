//
//  PartyAPI.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/08.
//

import Foundation

class PartyAPI {
    static let shared = PartyAPI()
    
    func fetchPartyData(completion: @escaping ([String: Any]?, Error?) -> Void){
        guard let url = URL(string: "")?.appendingPathComponent("parties", conformingTo: .json) else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let party = try decoder.decode(Party.self, from: data)
                
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func postPartyData(){
        
    }
}
