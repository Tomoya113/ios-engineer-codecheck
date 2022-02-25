//
//  SearchRepositoriesViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import UIKit

final class SearchRepositoriesViewController: UITableViewController {

    @IBOutlet weak private var searchBar: UISearchBar!

    private let disposeBag = DisposeBag()
    private let router: SearchRepositoriesRouterType
    private let viewModel: SearchRepositoriesViewModelType

    init?(
        coder: NSCoder,
        viewModel: SearchRepositoriesViewModelType,
        router: SearchRepositoriesRouterType
    ) {
        self.viewModel = viewModel
        self.router = router
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        configureTableViewDelegate()

        let searchBarText = searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")

        searchBarText
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                self.viewModel.inputs.searchQuery.onNext(text)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.repositories
            .asObservable()
            .bind(to: tableView.rx.items) { tableView, row, element in
                let cell = UITableViewCell()
                cell.textLabel?.text = element.fullName
                cell.detailTextLabel?.text = element.language
                cell.tag = row
                return cell
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind(to: viewModel.inputs.selectedItemIndex)
            .disposed(by: disposeBag)

        viewModel.outputs.selectedItem
            .drive(onNext: { [router] selectedItem in
                let destinationViewController = router.createRepositoryDetailPage(selectedRepository: selectedItem)
                self.navigationController?.pushViewController(destinationViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupView() {
        title = "リポジトリ検索"
        searchBar.placeholder = "検索したいリポジトリ名を入力"
    }

    private func configureTableViewDelegate() {
        /*
         RxCocoaが裏でDelegateの設定を行ってくれるので、UITableViewControllerが自動で行っている
         delegateの設定を無効化にする
         */
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
    }

}
