//
//  ChatRoomRequirementsView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/10.
//
import SwiftUI

struct ChatRoomRequirementsView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("未達成の条件があります\n条件をクリアして\nやり取りを始めよう")
                .foregroundColor(Color.customBlack)
                .multilineTextAlignment(.center)
                .font(.system(size: 28, weight: .bold))
            Text("以下の条件をクリアすると、やり取りを始めることができます。達成してやり取りを始めましょう！")
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .light))
                .padding(.horizontal, 16)
            HStack {
                Spacer()
                if userModel.user.coins >= 100{
                    ClearView(title: "ポイント", buttonTitle: "追加済み", systemImage: "p.circle.fill")
                } else {
                    UnClearView(title: "ポイント", buttonTitle: "追加する", systemImage: "p.circle.fill"){
                        PointPurchaseView()
                    }
                }
                Spacer()
                if !userModel.user.pairUid.isEmpty {
                    ClearView(title: "ペア", buttonTitle: "追加済み", systemImage: "person.2")
                } else {
                    UnClearView(title: "ペア", buttonTitle: "追加する", systemImage: "person.2"){
                        PairSettingView()
                    }
                }
                
                Spacer()
            }
            .padding(.top, 16)
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.customBlack)
                }
            }
        }
    }
}

struct ChatRoomRequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomRequirementsView()
    }
}

struct ClearView: View {
    let title: String
    let buttonTitle: String
    let systemImage: String
    var body: some View {
        ZStack(alignment: .topTrailing){
            VStack {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text(title)
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .bold))
                
                Text(buttonTitle)
                    .foregroundColor(.gray)
                    .font(.system(size: 13, weight: .bold))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
            }
            .frame(width: 120, height: 140)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .background(Color.white)
                .foregroundColor(.green)
                .clipShape(Circle())
                .offset(x: 8, y: -8)
        }
    }
}

struct UnClearView<Content: View>: View {
    let title: String
    let buttonTitle: String
    let systemImage: String
    let content: () -> Content
    var body: some View {
        NavigationLink {
            content()
        } label: {
            VStack {
                LinearGradient(colors: [.pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(width: 50, height: 50)
                    .mask {
                        Image(systemName: systemImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            
                    }
                LinearGradient(colors: [.pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 16)
                    .mask {
                        Text(title)
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .bold))
                    }
                Text(buttonTitle)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .bold))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .background(Color.pink)
                    .cornerRadius(20)
            }
            .frame(width: 120, height: 140)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 3)
        }
    }
}
