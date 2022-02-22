//
//  SearchRepositoriesViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchRepositoriesViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    var repositories: [[String: Any]] = []

    var task: URLSessionTask?
    var searchWord: String!
    var apiURL: String!
    var selectedRepositoryIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // NOTE:画面遷移時に呼ばれる
        if segue.identifier == "Detail"{
            let destinationViewController = segue.destination as! RepositoryDetailViewController
            destinationViewController.searchRepositoriesController = self
        }
    }

}

// MARK: TableView Configuration
extension SearchRepositoriesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // NOTE:セルを選択した時に呼ばれる
        selectedRepositoryIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)

    }

}

// MARK: UISearchBar Configuration
extension SearchRepositoriesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // NOTE:SearchBarの文字を初期化する
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
        if searchWord.isEmpty { return }

        let apiURLString = "https://api.github.com/search/repositories?q=\(searchWord)"
        guard let apiURL = URL(string: apiURLString) else {
            print("invalid URL")
            return
        }

        task = URLSession.shared.dataTask(with: apiURL) { (data, res, err) in
            guard let data = data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data) else { return }
            guard let obj = json as? [String: Any] else { return }
            guard let items = obj["items"] as? [[String: Any]] else { return }

            self.repositories = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // NOTE:タスクを実行する(resumeを実行しないとタスクが実行されない)
        task?.resume()
    }
}
