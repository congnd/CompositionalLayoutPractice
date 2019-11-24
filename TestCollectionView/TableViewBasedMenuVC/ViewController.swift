//
//  ViewController.swift
//  TestCollectionView
//
//  Created by Nguyen Dinh Cong on 2019/11/18.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

enum Section {
    case main
}

class Item: Hashable {
    private let uuid = UUID()
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    let title: String
    let level: Int
    let subItems: [Item]
    var isExpanded = false
    
    init(title: String, level: Int, subItems: [Item]) {
        self.title = title
        self.level = level
        self.subItems = subItems
    }
}

let items: [Item] = [
    Item(title: "Compositional Layout", level: 0, subItems: [
        Item(title: "Orthogonal Sections", level: 1, subItems: [
            Item(title: "Orthogonal Sections", level: 2, subItems: []),
            Item(title: "Orthogonal Section Behaviors", level: 2, subItems: []),
        ])
    ]),
    Item(title: "Diffable Data Source", level: 0, subItems: [
        Item(title: "Mountains Search Sections", level: 1, subItems: []),
        Item(title: "Search: Wi-Fi", level: 1, subItems: []),
    ])
]

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: UITableViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, item -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else { return nil }
            cell.title.text = item.title
            cell.level = item.level
            return cell
        })
        
        let snapshot = createSnapshot()
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.main])
        func addItem(_ item: Item) {
            snapshot.appendItems([item])
            if item.isExpanded {
                item.subItems.forEach { addItem($0) }
            }
        }
        items.forEach { addItem($0) }
        return snapshot
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        item.isExpanded.toggle()
        
        let snapshot = self.createSnapshot()
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
