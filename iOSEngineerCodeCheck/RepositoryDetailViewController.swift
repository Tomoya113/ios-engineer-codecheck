//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!

    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var openIssuesCountLabel: UILabel!

    var searchRepositoriesController: SearchRepositoriesViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let searchRepositoriesViewController = searchRepositoriesViewController,
            let selectedRepositoryIndex = searchRepositoriesViewController.selectedRepositoryIndex
        else {
            return
        }
        repository = searchRepositoriesViewController.repositories[selectedRepositoryIndex]

        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starCountLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        openIssuesCountLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getRepositoryAvatar()

    }

    func getRepositoryAvatar() {
        titleLabel.text = repository["full_name"] as? String ?? ""

        guard
            let owner = repository["owner"] as? [String: Any],
            let avatarURLString = owner["avatar_url"] as? String
        else { return }

        guard let avatarURL = URL(string: avatarURLString) else { return }

        URLSession.shared.dataTask(with: avatarURL) { (data, res, err) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }.resume()

    }

}
