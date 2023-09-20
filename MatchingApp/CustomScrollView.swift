//
//  CustomScrollView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/09.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomScrollView: View {
    let menus:[String]
    @Binding var postFilter: PostFilter
    @Binding var selection: Int
    @State var openNotification: Bool = false
    @EnvironmentObject var userModel: UserObservableModel
    private let tabButtonSize: CGSize = CGSize(width: 100.0, height: 44.0)
    private func spacerWidth(_ viewOriginX: CGFloat) -> CGFloat {
        return (UIScreen.main.bounds.width - (viewOriginX * 2) - tabButtonSize.width) / 2
    }
    
    var body: some View{
        HStack{
            Button {
                withAnimation {
                    self.selection = 2
                }
            } label: {
                Image(userModel.user.profileImageURLString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 22, height: 22)
                    .padding(.all, 4)
                    .background(Color.customLightGray)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.customBlack, lineWidth: 1)
                    }
            }
            .padding(.leading,16)
            
            GeometryReader { geometryProxy in
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: .zero) {
                            Spacer()
                                .frame(width: spacerWidth(geometryProxy.frame(in: .global).origin.x))
                            ForEach(menus.reversed().indices, id: \.self) { index in
                                Button {
                                    selection = index
                                    withAnimation {
                                        scrollProxy.scrollTo(selection, anchor: .center)
                                    }
                                } label: {
                                    Text(menus[index])
                                        .font(.subheadline)
                                        .fontWeight(selection == index ? .semibold: .regular)
                                        .foregroundColor(selection == index ? .customBlack: .white)
                                        .padding(.bottom, 7)
                                        .id(index)
                                }
                                .frame(width: tabButtonSize.width, height: tabButtonSize.height)
                            }
                            Spacer()
                                .frame(width: spacerWidth(geometryProxy.frame(in: .global).origin.x)+8)
                        }.onChange(of: selection) { _ in
                            withAnimation {
                                scrollProxy.scrollTo(selection, anchor: .center)
                            }
                        }.onAppear{
                            withAnimation {
                                scrollProxy.scrollTo(selection, anchor: .center)
                            }
                        }
                    }
                }
            }
            
            Button {
                openNotification = true
            } label: {
                Image(systemName: "line.horizontal.3.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.customBlack)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .padding(.trailing,16)
        }
        .background(Color.customBlue.opacity(0.5))
        .sheet(isPresented: $openNotification) {
            FilterlingPostView(postFilter: $postFilter)
                .presentationDetents([.height(100)])
        }
    }
}

