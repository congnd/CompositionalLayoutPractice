//
//  OrthogonalSectionsVC.swift
//  TestCollectionView
//
//  Created by Nguyen Dinh Cong on 2019/11/27.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

class OrthogonalSectionsVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Orthogonal Sections"
        
        configHierarchy()
        configDataSource()
    }
    
    func configHierarchy() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.collectionViewLayout = createLayout()
    }
    
    func configDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, identifier -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.largeContentTitle = "Cong"
            cell.backgroundColor = .green
            return cell
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = 30
        for section in 0..<5 {
            snapshot.appendSections([section])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnv -> NSCollectionLayoutSection? in
            let leadingItem = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(0.7),
                heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let trailingItem = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.3)))
            trailingItem.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem,
                count: 2)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(0.4)),
                subitems: [leadingItem, trailingGroup])
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
}
