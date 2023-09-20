//
//  MovieCollectionViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/04.
//

import Foundation

class MovieCollectionViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private var apiService: APIService
    private var loadDataTask: Task<Void, Never>?
    
    init(apiService: APIService = API()){
        self.apiService = apiService
    }
    
    func fetchMovie() {
        loadDataTask = Task {
            do {
                let nowPlayingMovieRequest = APIModel.NowPlayingMovieAPI()
                let popularMovieRequest = APIModel.PopularMovieAPI()
                
                async let nowPlayingMovies: MoviePageableList = apiService.request(nowPlayingMovieRequest)
                
                // 2つのAPIリクエストの結果を待つ
                let fetchedNowPlayingMovies = try await nowPlayingMovies
                
                DispatchQueue.main.async {
                    print(fetchedNowPlayingMovies.results)
                    self.movies = fetchedNowPlayingMovies.results
                }
            } catch {
                print("Error!:",error)
            }
        }
    }
    
    func cancel(){
        loadDataTask?.cancel()
    }
}
