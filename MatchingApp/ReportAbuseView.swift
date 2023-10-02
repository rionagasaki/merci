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
    @Environment(\.presentationMode) var presentationMode
    private let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    let user: UserObservableModel
    var body: some View {
        NavigationView {
            VStack {
                Image(user.user.profileImageURLString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .padding(.all, 14)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
                
                Text(user.user.nickname)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .medium))
                
                Text("報告内容の詳細を教えてください")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 16)
                Text("「やり取りしているときに○○と言われた。」「自己紹介に○○と書いてあった。」などできるだけ具体的にご記入ください。")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 14))
                Text("※通報をされたユーザーにはプロフィールにペナルティが追加されます。適切でない通報な場合、通報者にもペナルティがつく可能性があります。ご了承ください。")
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
                    viewModel.report(reportUserID: userModel.user.uid, reportedUserID: user.user.uid)
                } label: {
                    Text("報告する")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 56)
                        .background(viewModel.reportText.isEmpty ? Color.gray.opacity(0.4): Color.customBlue.opacity(0.8))
                        .cornerRadius(10)
                }
                .disabled(viewModel.reportText.isEmpty)
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("キャンセル")
                        .foregroundColor(.customBlue.opacity(0.8))
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 56)
                        .background(Color.white)
                }

            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(viewModel.$isReportSuccess){
                if $0 {
                    UIIFGeneratorMedium.impactOccurred()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text("問題を報告する")
                        .foregroundColor(.customBlack)
                        .bold()
                }
            }
        }
    }
}
