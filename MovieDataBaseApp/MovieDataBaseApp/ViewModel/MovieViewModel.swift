//
//  MovieViewModel.swift
//  MovieDataBaseApp
//
//  Created by Vishal Manhas on 18/10/24.
//

import Foundation
class MovieViewModel {
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    init() {
        loadMovies()
    }
    
    private func loadMovies() {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                movies = try decoder.decode([Movie].self, from: data)
            } catch {
                print("Error loading movies: \(error)")
            }
        }
    }
    
    func searchMovies(with query: String) {
        filteredMovies = movies.filter { movie in
            movie.title?.lowercased().contains(query.lowercased()) ?? false ||
            movie.genre?.lowercased().contains(query.lowercased()) ?? false ||
            movie.director?.lowercased().contains(query.lowercased()) ?? false ||
            movie.actors?.lowercased().contains(query.lowercased()) ?? false
        }
    }
    
    func distinctYears() -> [String] {
        return Array(Set(movies.compactMap { $0.year })).sorted()
    }
    
    func distinctGenres() -> [String] {
        return Array(Set(movies.compactMap { $0.genre?.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) } ?? [] }).flatMap { $0 }).sorted()
    }
    
    func distinctDirectors() -> [String] {
        return Array(Set(movies.compactMap { $0.director })).sorted()
    }
    
    func distinctActors() -> [String] {
        return Array(Set(movies.compactMap { $0.actors?.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) } ?? [] }).flatMap { $0 }).sorted()
    }
    
    func movies(forYear year: String) -> [Movie] {
        return movies.filter { $0.year == year }
    }
    
    func movies(forGenre genre: String) -> [Movie] {
        return movies.filter { $0.genre?.contains(genre) ?? false }
    }
    
    func movies(forDirector director: String) -> [Movie] {
        return movies.filter { $0.director == director }
    }
    
    func movies(forActor actor: String) -> [Movie] {
        return movies.filter { $0.actors?.contains(actor) ?? false }
    }
}
