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
    var currentMem = ""
    var presenter: ListViewPresenerProtocol?
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
        settingSearchController()
    }
    // MARK: - Table view data source.

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredMems.count
        }
        return presenter?.listMems.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var memos: String
        if isFiltering {
            memos = filteredMems[indexPath.row]
        } else {
            memos = presenter?.listMems[indexPath.row] ?? ""
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
                mems = presenter?.listMems[indexPath.row] ?? ""
            }
        }
        currentMem = mems
        NotificationCenter.default.post(name: Notification.Name("settingSelectedMem"), object: self.currentMem)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Work over UISearchController.

extension ListMemsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterForSearchText(searchController.searchBar.text!)
    }

    func filterForSearchText(_ searchText: String) {
        filteredMems = presenter!.listMems.filter({ (mems: String) -> Bool in
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
}

// MARK: - Update tableView after loading data

extension ListMemsVC: ListViewProtocol {
    func updateList() {
        self.tableView.reloadData()
    }
}
