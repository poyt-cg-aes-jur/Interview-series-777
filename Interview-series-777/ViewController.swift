//
//  ViewController.swift
//  Interview-series-098
//
//  Created by user-gy-cg-pds2
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let baseURL = "https://fileupload.rick-and-friends.site/search?keyword="
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var results: [String] = []
    var searchTask: DispatchWorkItem?
    var currentTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchResults(for: searchText)
    }
    
    private func fetchResults(for query: String) {
        guard !query.isEmpty else { return }
        
        let urlString = baseURL + query
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.main.async {
            self.currentTask = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    do {
                        let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                        self.results = decodedResponse.results.map{ $0.key }
                        self.tableView.reloadData()
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
            }
            self.currentTask?.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]
        return cell
    }
}


struct Response: Codable {
    let success: Bool
    let count: Int
    let results: [Result]
}

struct Result: Codable {
    let key: String
    let size: Int
    let uploaded: String
    let url: String
}

//MARK: - Tasks
// 1 - How does this codebase work? Please explain briefly?
// 2 - Optimize the codebase.
// 3 - Fix memory leaks - retain cycles (if any).
// 4 - Fix the incorrect usage of threads (if any).
// 5 - Implement the search cancel button's logic.
// 6 - Refactor the codebase into the MVVM pattern.
// 7 - Write a unit test for the network call.


//MARK: - If Time Permits
// 1 - Debug the UI and fix issues (if any).
// 2 - Test application performance using Instruments.

