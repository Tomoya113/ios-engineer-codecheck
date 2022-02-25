//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Nuke
import RxSwift
import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var languageLabel: UILabel!
    @IBOutlet weak private var stargazersCountLabel: UILabel!
    @IBOutlet weak private var watchersLabel: UILabel!
    @IBOutlet weak private var forksCountLabel: UILabel!
    @IBOutlet weak private var openIssuesCountLabel: UILabel!
    private let disposeBag = DisposeBag()
    private let viewModel: RepositoryDetailViewModelType

    init?(coder: NSCoder, viewModel: RepositoryDetailViewModelType) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.outputs.repository
            .drive(onNext: { [weak self] repository in
                guard let self = self else { return }
                self.titleLabel.text = repository.fullName
                self.languageLabel.text = "Written in \(repository.language ?? "")"
                self.stargazersCountLabel.text = "\(repository.stargazersCount) stars"
                self.watchersLabel.text = "\(repository.watchersCount) watchers"
                self.forksCountLabel.text = "\(repository.forksCount) forks"
                self.openIssuesCountLabel.text = "\(repository.openIssuesCount) open issues"
                Nuke.loadImage(with: repository.owner.avatarUrl, into: self.avatarImageView)
            })
            .disposed(by: disposeBag)
    }

}
