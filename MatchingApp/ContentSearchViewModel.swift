//
//  ContentSearchViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/09.
//

import Foundation

class ContentSearchViewModel: ObservableObject {
    @Published var nowPlayingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var searchQuery: String = ""
    @Published var searchResult:[Movie] = []
    @Published var selectedCategory: Int = 0
    @Published var onSubmit: Bool = false
    @Published var selection: Int = 0
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
                async let popularMovies: MoviePageableList = apiService.request(popularMovieRequest)
                
                // 2つのAPIリクエストの結果を待つ
                let fetchedNowPlayingMovies = try await nowPlayingMovies
                let fetchedPopularMovies = try await popularMovies
                
                DispatchQueue.main.async {
                    self.nowPlayingMovies = fetchedNowPlayingMovies.results
                    self.popularMovies = fetchedPopularMovies.results
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
