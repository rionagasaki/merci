//
//  BirthDateView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BirthDateView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @State var date = Date()
    @Environment(\.dismiss) var dismiss
    @Binding var presentationMode: PresentationMode
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .year, value: -30, to: Date())!
        let end = calendar.date(byAdding: .year, value: -18, to: Date())!
        return start...end
    }()
    
    var df:DateFormatter{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP")
        return df
    }
    
    var body: some View {
        VStack(alignment: .leading){
            ScrollView {
                Text("生年月日を\n入力してください")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(Color.customBlack)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                DatePicker(selection: $date, in: dateRange, displayedComponents: [.date]) {
                    Text("\(date)")
                }
                .labelsHidden()
                .datePickerStyle(.wheel)
                .foregroundColor(.customBlack)
                .font(.system(size: 25))
                .padding(.vertical, 16)
                .padding(.horizontal, 4)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .onChange(of: date) { newValue in
                    userModel.birthDate = "\(df.string(from: date))"
                }
                
                Text("\(df.string(from: date))")
                    
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(height: 2)
                    .padding(.horizontal, 16)
                    .padding(.top, -8)
                
                VStack(alignment: .leading){
                    Text("※誤った生年月日を入力されますと、メッセージのやり取り等に制限が生まれる場合がございますので、ご注意ください")
                    Text("※生年月日の編集は登録時のみ可能です。一度登録された生年月日は変更できませんので、あらかじめご了承ください")
                }
                .foregroundColor(.gray)
                .padding(.horizontal, 16)
                .font(.system(size: 13))
            }
            Spacer()
            NavigationLink {
                MainImageView(presentationMode: $presentationMode)
            } label: {
                NextButtonView()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                )
            }
        }
    }
}
