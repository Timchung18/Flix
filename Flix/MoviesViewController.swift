//
//  MoviesViewController.swift
//  Flix
//
//  Created by Timothy Cheung on 1/19/20.
//  Copyright © 2020 timothycheung80. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]() // the array of movies from the API results

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self // function call
        tableView.delegate = self   // function call
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // TODO: Get the array of movies
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // TODO: Store the movies in a property to use elsewhere
                self.movies = dataDictionary["results"] as! [[String:Any]]
                // TODO: Reload your table view data
                self.tableView.reloadData()

           }
        }
        task.resume()

        // Do any additional setup after loading the view.
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        // will call the function below 'movies.count' number of times, meaning that there will be 'movies.count' number of cells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
        // this loads each cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get the new view controller(MovieDetailsVC) using segue.destination
        let detailsViewController = segue.destination as! MovieDetailsViewController
        // get the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // pass the selected object(movie) to the new view controller(MovieDetailsVC)
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
