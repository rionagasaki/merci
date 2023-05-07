//
//  SelectedPictureVie.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//

import SwiftUI

struct SelectedPictureView: View {
    var body: some View {
        VStack {
            Image("Person")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 40, height: 300)
            VStack {
                HStack {
                    Image("Person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width/2)-40, height:
                                100)
                    
                    Image("Person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width/2)-40, height:
                                100)
                    
                    
                }
                HStack {
                    Image("Person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width/2)-40, height:
                                100)
                    
                    Image("Person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width/2)-40, height:
                                100)
                    
                    
                }
                
            }
            Spacer()
            Button {
                print("保存する")
            } label: {
                Text("保存する")
                
                    .foregroundColor(.black
                    )
                    .frame(width: 300, height: 50)
                    .background(.yellow)
                    .cornerRadius(20)
            }
        }
    }
}

struct SelectedPictureView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPictureView()
    }
}
