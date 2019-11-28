//
//  CollectionViewBasedMenuVC.swift
//  TestCollectionView
//
//  Created by Nguyen Dinh Cong on 2019/11/24.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

class CollectionViewBasedMenuVC: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var outlineCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureDataSource()
    }

}

extension CollectionViewBasedMenuVC {
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        outlineCollectionView = collectionView
    }

    func configureDataSource() {
        dataSource = .init(collectionView: outlineCollectionView) { collectionView, indexPath, menuItem -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CollectionViewCell",
                for: indexPath) as? CollectionViewCell else { fatalError("Could not create new cell") }
            cell.title.text = menuItem.title
            cell.level = menuItem.level
            return cell
        }

        // load our initial data
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func generateLayout() -> UICollectionViewLayout {
        let itemHeightDimension = NSCollectionLayoutDimension.absolute(44)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: itemHeightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: itemHeightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.main])
        func addItems(_ menuItem: Item) {
            snapshot.appendItems([menuItem])
            if menuItem.isExpanded {
                menuItem.subItems.forEach { addItems($0) }
            }
        }
        items.forEach { addItems($0) }
        return snapshot
    }

    func updateUI() {
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension CollectionViewBasedMenuVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = dataSource.itemIdentifier(for: indexPath) else { return }

        collectionView.deselectItem(at: indexPath, animated: true)
        
        if menuItem.subItems.isEmpty {
            if let sceneClass = menuItem.sceneClass {
                let orthogonalSectionsVC = sceneClass.init(nibName: String(describing: sceneClass), bundle: nil)
                show(orthogonalSectionsVC, sender: nil)
            }
        } else {
            menuItem.isExpanded.toggle()
            updateUI()
        }
    }
}
