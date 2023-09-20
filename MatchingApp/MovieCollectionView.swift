//
//  MovieCollectionView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/03.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreMotion

struct MovieCollectionView: View {
    @StateObject var viewModel = MovieCollectionViewModel()
    var body: some View {
        VStack(alignment: .leading, spacing: .zero){
            Text("好きな映画")
                .foregroundColor(.customBlack)
                .font(.system(size: 24, weight: .bold))
                .padding(.leading, 8)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: Array(repeating: .init(.fixed((UIScreen.main.bounds.width / 4) * 1.5), spacing: 16), count: 2)) {
                    ForEach(viewModel.movies, id: \.self) { movie in
                        NavigationLink {
                            EmptyView()
                        } label: {
                            WebImage(url: URL(string: movie.posterPath.movieImageURLString))
                                .resizable()
                                .scaledToFill()
                                .frame(width: (UIScreen.main.bounds.width)/4)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.all, 8)
            }
        }
        .onAppear() {
            viewModel.fetchMovie()
        }
    }
}

struct MovieCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCollectionView()
    }
}

