//
//  UserProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @StateObject var viewModel = UserProfileViewModel()
    
    let currentUserID: String
    let userID: String
    let nickname: String
    let profileImageURL: String
    let birthDate: String
    let activeRegion: String
    var age: Int  {
        guard let age = CalculateAge().calculateAge(from: birthDate) else { return 99 }
        return age
    }
    
    var body: some View {
        VStack{
            ScrollView {
                VStack {
                    WebImage(url: URL(string: profileImageURL))
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width-64, height:UIScreen.main.bounds.width-64)
                        .cornerRadius(10)
                        .padding(.top, 32)
                    VStack {
                        Text(nickname)
                            .foregroundColor(.black)
                            .bold()
                            .font(.system(size: 22))
                        Text("\(age)歳・\(activeRegion)")
                            .foregroundColor(.gray)
                            .fontWeight(.light)
                            .font(.system(size: 18))
                    }
                    .padding(.top, 16)
                    
                    VStack(alignment: .leading) {
                        Text("興味")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                        Text("基本情報")
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 32)
                }
                Button {
                    print("currentUserID \(currentUserID)")
                    print("userID \(userID)")
                    viewModel.pairRequest(currentUserID: currentUserID , userID: userID)
                } label: {
                    Text("ペアリクエスト")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width-40, height: 60)
                        .background(Color.customGreen)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            
        }
    }
}
