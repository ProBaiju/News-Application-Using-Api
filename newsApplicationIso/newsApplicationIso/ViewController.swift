//
//  ViewController.swift
//  newsApplicationIso
//
//  Created by AL20 on 19/06/23.
//



//api key is : 4ad916e802f64fecba37f4520bab75c6


import UIKit
import SafariServices

//class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return
//    }
//
//    private let tableView: UITableView = {
//         let table = UITableView()
//        table.register(UITableView.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
//        return table
//    }()
//
//    private var viewModels = [NewsTableViewCellViewModle]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "News"
//        view.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//        view.backgroundColor = .systemBackground
//
//        APICaller.shared.getTopStories{ [weak self ] result in
//            switch result{
//            case.success(let articles):
//                self?.viewModels = articles.compactMap({
//                    NewsTableViewCellViewModle(title: $0.title,
//                                               subtitle: $0.description ?? "no description",
//                                               imageURL: URL(string: $0.urlToImage ?? "")
//                    )
//                })
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            case.failure(let error):
//                print(error)
//
//            }
//        }
//    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
//    //table
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModels.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath ) as? NewsTableViewCell else{
//            fatalError()
//        }
//        cell.configure(with: viewModels[indexPath.row ])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//
//
//
//}
//

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
     private var viewModels = [NewsTableViewCellViewModle]()
    private var articles = [Article]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.map {
                    NewsTableViewCellViewModle(
                        title: $0.title,
                        subtitle: $0.description ?? "No description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("API Error:", error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError("Failed to dequeue NewsTableViewCell")
        }
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    // TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else{
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
