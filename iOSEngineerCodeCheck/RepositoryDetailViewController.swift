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
        
        let repository = searchRepositoriesController.repositories[searchRepositoriesController.selectedRepositoryIndex]

        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starCountLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        openIssuesCountLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getRepositoryAvatar()

    }

    func getRepositoryAvatar() {

        let repository = searchRepositoriesController.repositories[searchRepositoriesController.selectedRepositoryIndex]

        titleLabel.text = repository["full_name"] as? String

        if let owner = repository["owner"] as? [String: Any] {
            if let avatarURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: avatarURL)!) { (data, res, err) in
                    let image = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.avatarImageView.image = image
                    }
                }.resume()
            }
        }

    }

}
