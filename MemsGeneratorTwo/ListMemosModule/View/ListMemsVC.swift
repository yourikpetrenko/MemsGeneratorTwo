//
//  ListMems.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 23.07.2020.
//  Copyright © 2020 Jura. All rights reserved.
//
import UIKit
import Alamofire

class ListMemsVC: UITableViewController {
    
    var presenter: ListViewPresenerProtocol?
    weak var delegate: CurrentMemeDelegate?
    private var arrayMems = [String]()
    private var textIndexPath: String?
    private var filteredMems = [String]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false}
        return text.isEmpty
    }

    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        getListMems()
        settingSearchController()
    }
    // MARK: - Table view data source.

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredMems.count
        }
        return arrayMems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var memos: String
        if isFiltering {
            memos = filteredMems[indexPath.row]
        } else {
            memos = arrayMems[indexPath.row]
        }
        cell.textLabel?.text = memos
        self.textIndexPath = memos
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var mems = ""
        if let indexPath = tableView.indexPathForSelectedRow {
            if isFiltering {
                mems = filteredMems[indexPath.row]
            } else {
                mems = arrayMems[indexPath.row]
            }
        }
        let identifierName = mems
        delegate?.transmittingIdMeme(identifierName: identifierName)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Work over UISearchController.
extension ListMemsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterForSearchText(searchController.searchBar.text!)
    }

    func filterForSearchText(_ searchText: String) {
        filteredMems = arrayMems.filter({ (mems: String) -> Bool in
            return mems.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    func settingSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по имени"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Network Service. Load list memes.
    func getListMems() {
//        let urlListMems = "https://ronreiter-meme-generator.p.rapidapi.com/images"
//        ListNetworkService.getList(url: urlListMems) { (response) in
//            self.arrayMems = response.array
//            self.tableView.reloadData()
//        }
    }
}

extension ListMemsVC: ListViewProtocol {
    func updateList(arrayMems: [String]) {
        self.arrayMems = arrayMems
        self.tableView.reloadData()
    }
}
