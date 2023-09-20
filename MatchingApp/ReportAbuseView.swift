//
//  ReportAbuseView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/10.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReportAbuseView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @StateObject var viewModel = ReportAbuseViewModel()
    let user: UserObservableModel
    var body: some View {
        NavigationView {
            VStack {
                WebImage(url: URL(string: user.user.profileImageURLString))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Text("報告内容の詳細を教えてください")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 32)
                Text("「やり取りしているときに○○と言われた。」「自己紹介に○○と書いてあった。」などできるだけ具体的にご記入ください。")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 14))
                Text("※この記入欄にお客様の個人情報を記入しないでください")
                    .foregroundColor(.pink)
                    .font(.system(size: 14))
                NavigationLink {
                    ReportTextView(reportText: $viewModel.reportText)
                } label: {
                    if viewModel.reportText.isEmpty {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: UIScreen.main.bounds.width-32, height: 200)
                                .foregroundColor(.gray.opacity(0.1))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray.opacity(0.6), lineWidth: 1)
                                }
                            VStack {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.customBlack)
                                Text("回答する")
                                    .foregroundColor(.customBlack)
                                    .font(.system(size: 14, weight: .medium))
                            }
                        }
                        
                    } else {
                        ZStack(alignment: .topLeading){
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: UIScreen.main.bounds.width-32, height: 200)
                                .foregroundColor(.white)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray.opacity(0.6), lineWidth: 1)
                                }
                            Text(viewModel.reportText)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                                .padding(8)
                        }
                    }
                }
                Spacer()
                Button {
                    viewModel.report(reportUserID: userModel.user.uid)
                } label: {
                    Text("回答する")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 50)
                        .background(Color.pink)
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal, 16)
            .navigationTitle("問題を報告する")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
