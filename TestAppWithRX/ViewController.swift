//
//  ViewController.swift
//  TestAppWithRX
//
//  Created by George Kyrylenko on 09.08.2020.
//  Copyright © 2020 TestApp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
        
    private let contactsManager = ContactsManager()
    private let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var contactsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareSearchBar()
        getContacts()
    }
    
    func prepareTableView(){
        contactsManager.contacts.bind(to: contactsTableView.rx.items(cellIdentifier: "ContactCell")){ (index, contact: Contact, cell) in
            guard let contactCell = cell as? ContactCell else {return}
            contactCell.userNameLbl.text = contact.name
            contactCell.phoneNumberLbl.text = contact.phoneNumbers?.first
        }.disposed(by: disposeBag)
    }

    func prepareSearchBar(){
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        searchController.searchBar.rx.text.orEmpty
        .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged().subscribe {[weak self] (searchText) in
                print(searchText)
                self?.contactsManager.searchContacts(by: searchText.event.element?.lowercased())
        }.disposed(by: disposeBag)
        
    }
    
    func getContacts(){
        contactsManager.updateContacts()
    }
}
