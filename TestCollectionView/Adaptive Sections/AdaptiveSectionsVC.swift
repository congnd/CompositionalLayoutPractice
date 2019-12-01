//
//  AdaptiveSectionsVC.swift
//  TestCollectionView
//
//  Created by Nguyen Dinh Cong on 2019/12/01.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

class AdaptiveSectionsVC: UIViewController {
    enum SectionType: Int, CaseIterable {
        case section0 = 0
        case section1 = 1
        case section2 = 2
        func itemsPerHorizGroup(for layoutWidth: CGFloat) -> Int {
            let isRegularMode = layoutWidth > 600
            switch self {
            case .section0: return isRegularMode ? 2 : 1
            case .section1: return isRegularMode ? 7 : 4
            case .section2: return isRegularMode ? 4 : 3
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Adaptive Sections"
        
        configHierachy()
        configDataSource()
    }
    
    func configHierachy() {
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.collectionViewLayout = createLayout()
    }
    
    func configDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, identifier -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return nil }
            cell.backgroundColor = .red
            cell.title.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        })
        
        let itemsPerSection = 10
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        SectionType.allCases.forEach {
            snapshot.appendSections([$0.rawValue])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperbound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
        }
        dataSource.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnv -> NSCollectionLayoutSection? in
            guard let sectionType = SectionType(rawValue: sectionIndex) else { return nil }
            let itemsCount = sectionType.itemsPerHorizGroup(for: layoutEnv.container.effectiveContentSize.width)
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = .init(top: 2.0, leading: 2.0, bottom: 2.0, trailing: 2.0)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: sectionType == .section0 ? .absolute(44.0) : .fractionalWidth(0.2)),
                subitem: item,
                count: itemsCount)
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
}
