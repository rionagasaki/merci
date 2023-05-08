//
//  UserAPI.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/08.
//

import Foundation

class UserAPI {
    static let shared = UserAPI()
    
    func fetchUserData(completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        guard let url = URL(string: apiGatewayURL)?.appendingPathComponent("users", conformingTo: .url) else {
            print("Error: Invalid URL")
            return
        }
        print("URL:\(url)")
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                print(user.user_id)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func postUserData(){
        let data: [String: Any] = [
            "party_id": "",
            "": "",
            "": "",
        ]
        
        guard let url = URL(string: apiGatewayURL)?.appendingPathComponent("users", conformingTo: .url) else {
            print("Error: Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: [])
                print(object)
            } catch let error {
                print(error)
            }
        }
    }
}
