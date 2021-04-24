//
//  ViewController.swift
//  MovieSearcher
//
//  Created by Mohamad Eslami on 2/4/1400 AP.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var textField : UITextField!

    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    private func searchMovies(){
        textField.resignFirstResponder()
        
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        self.movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=3ef10bdd&s=\(text)&type=movie")! , completionHandler: {data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            var result : MovieResult?
            
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
                
            } catch {
                print("An error occurred")
            }
            
            guard let finalResult = result else {
                return
            }
            
            
            let resultMovies = finalResult.Search
            self.movies.append(contentsOf: resultMovies)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }).resume()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

struct MovieResult: Codable {
    let Search: [Movie]
}


struct Movie: Codable {
    
    let Title: String
    
    let Year:   String
    
    let imdbID: String
    
    let _Type:   String
    
    let Poster : String
    
    private enum CodingKeys: String, CodingKey {
        case Title, Year, imdbID, _Type = "Type", Poster
    }
    
}

