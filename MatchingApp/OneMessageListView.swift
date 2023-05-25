//
//  OneMessageListView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/17.
//

import SwiftUI

struct OneMessageListView: View {
    var body: some View {
        NavigationLink {
            ChatView()
        } label: {
            VStack(alignment: .leading){
                Divider()
                Text("居酒屋に行きたい")
                    .foregroundColor(.black)
                    .bold()
                    .padding(.leading, 16)
                HStack (spacing: .zero){
                    Spacer()
                    Image("Person")
                        .resizable()
                        .frame(width: 20, height:20)
                        .clipShape(Circle())
                        .overlay{
                            Circle()
                                .stroke(.black, lineWidth: 0.2)
                        }
                    Image("Person")
                        .resizable()
                        .frame(width:20, height:20)
                        .clipShape(Circle())
                        .overlay{
                            Circle()
                                .stroke(.black, lineWidth: 0.2)
                        }
                        .padding(.leading, -8)
                    Image("Person")
                        .resizable()
                        .frame(width:20, height:20)
                        .clipShape(Circle())
                        .overlay{
                            Circle()
                                .stroke(.black, lineWidth: 0.2)
                        }
                        .padding(.leading, -8)
                    Image("Person")
                        .resizable()
                        .frame(width:20, height:20)
                        .clipShape(Circle())
                        .overlay{
                            Circle()
                                .stroke(.black, lineWidth: 0.2)
                        }
                        .padding(.leading, -8)
                }
                .padding(.trailing, 16)
                Divider()
            }
        }

    }
}

struct OneMessageListView_Previews: PreviewProvider {
    static var previews: some View {
        OneMessageListView()
    }
}
