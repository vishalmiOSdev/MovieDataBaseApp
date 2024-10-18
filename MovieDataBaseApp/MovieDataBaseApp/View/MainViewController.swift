//
//  ViewController.swift
//  MovieDataBaseApp
//
//  Created by Vishal Manhas on 18/10/24.
//

import UIKit
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var viewModel = MovieViewModel()
    var isSearching = false
    var isExpanded: [Int: Bool] = [:]
    var selectedMovies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupToolbar()
        self.title = "Movie Data Base"
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search a movie by title/actor/genere..."
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return viewModel.filteredMovies.count
        }

        let isExpandedSection = isExpanded[section] ?? false
        if isExpandedSection {
            switch section {
            case 0: return 1 + viewModel.distinctYears().count
            case 1: return 1 + viewModel.distinctGenres().count
            case 2: return 1 + viewModel.distinctDirectors().count
            case 3: return 1 + viewModel.distinctActors().count
            case 4: return 1 + viewModel.movies.count
            default: return 1
            }
        } else {
            return 1
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell

        if isSearching {
            let movie = viewModel.filteredMovies[indexPath.row]
            cell.titleLabel.text = movie.title ?? "Unknown Title"
        } else {
            let isExpandedSection = isExpanded[indexPath.section] ?? false

            if indexPath.row == 0 {
               
                switch indexPath.section {
                case 0: cell.titleLabel.text = "Year"
                case 1: cell.titleLabel.text = "Genre"
                case 2: cell.titleLabel.text = "Directors"
                case 3: cell.titleLabel.text = "Actors"
                case 4: cell.titleLabel.text = "All Movies"
                default: break
                }
            } else if isExpandedSection {
                switch indexPath.section {
                case 0:
                    cell.titleLabel.text = viewModel.distinctYears()[indexPath.row - 1]
                case 1:
                    cell.titleLabel.text = viewModel.distinctGenres()[indexPath.row - 1]
                case 2:
                    cell.titleLabel.text = viewModel.distinctDirectors()[indexPath.row - 1]
                case 3:
                    cell.titleLabel.text = viewModel.distinctActors()[indexPath.row - 1]
                case 4:
                    let movie = viewModel.movies[indexPath.row - 1]
                    cell.titleLabel.text = movie.title ?? "Unknown Title"
                default:
                    break
                }
            }
        }

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            let selectedMovie = viewModel.filteredMovies[indexPath.row]
            showMovieDetails(movie: selectedMovie)
            return
        }

        if indexPath.row == 0 {
            isExpanded[indexPath.section] = !(isExpanded[indexPath.section] ?? false)
            tableView.reloadSections([indexPath.section], with: .automatic)
        } else {
            switch indexPath.section {
            case 0:
                let year = viewModel.distinctYears()[indexPath.row]
                selectedMovies = viewModel.movies(forYear: year)
            case 1:
                let genre = viewModel.distinctGenres()[indexPath.row]
                selectedMovies = viewModel.movies(forGenre: genre)
            case 2:
                let director = viewModel.distinctDirectors()[indexPath.row]
                selectedMovies = viewModel.movies(forDirector: director)
            case 3:
                let actor = viewModel.distinctActors()[indexPath.row]
                selectedMovies = viewModel.movies(forActor: actor)
            case 4:
                let movie = viewModel.movies[indexPath.row]
                showMovieDetails(movie: movie)
                return
            default:
                break
            }

            presentSelectedMovies()
        }
    }

    private func presentSelectedMovies() {
        let selectedMoviesVC = SelectedMoviesViewController()
        selectedMoviesVC.movies = selectedMovies
        navigationController?.pushViewController(selectedMoviesVC, animated: true)
    }
    
    private func showMovieDetails(movie: Movie) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
            vc.movie = movie
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }

    }

   
      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          if searchText.isEmpty {
              isSearching = false
              tableView.reloadData()
          } else {
              isSearching = true
              viewModel.searchMovies(with: searchText)
              tableView.reloadData()
          }
      }

      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          searchBar.text = ""
          isSearching = false
          tableView.reloadData()
      }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func setupToolbar() {
           let toolbar = UIToolbar()
           toolbar.sizeToFit()

           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
           
           let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           toolbar.items = [doneButton,flexibleSpace]
           
           searchBar.inputAccessoryView = toolbar
       }

    
       @objc func doneButtonTapped() {
          
           searchBar.resignFirstResponder()
       }


}

