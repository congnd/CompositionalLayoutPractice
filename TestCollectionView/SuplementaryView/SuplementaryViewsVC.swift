//
//  SuplementaryViewsVC.swift
//  TestCollectionView
//
//  Created by Nguyen Dinh Cong on 2019/12/01.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

class SuplementaryViewsVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    static let badgeElementKind = "badge-element-kind"
    static let headerKind = "header-element-kind"
    static let footerKind = "footer-element-kind"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Suplementary Views"
        
        configHierachy()
        configDataSource()
    }
    
    func configHierachy() {
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(SuplementaryView.self, forSupplementaryViewOfKind: SuplementaryViewsVC.badgeElementKind, withReuseIdentifier: SuplementaryView.reuseIdentifier)
        collectionView.register(SuplementaryView.self, forSupplementaryViewOfKind: SuplementaryViewsVC.headerKind, withReuseIdentifier: SuplementaryView.reuseIdentifier)
        collectionView.register(SuplementaryView.self, forSupplementaryViewOfKind: SuplementaryViewsVC.footerKind, withReuseIdentifier: SuplementaryView.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { sectionIndex, layoutEnv -> NSCollectionLayoutSection? in
            
            let badge = NSCollectionLayoutSupplementaryItem(
                layoutSize: .init(widthDimension: .absolute(20), heightDimension: .absolute(20)),
                elementKind: SuplementaryViewsVC.badgeElementKind,
                containerAnchor: .init(edges: [.top, .trailing], fractionalOffset: .init(x: 0.5, y: -0.5)))
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .absolute(80.0), heightDimension: .absolute(80.0)),
                supplementaryItems: [badge])
            item.contentInsets = .init(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(100.0), heightDimension: .absolute(190)), subitems: [item])
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(190)), subitems: [group])
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.interGroupSpacing = 5
//            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40)),
                elementKind: SuplementaryViewsVC.headerKind,
                alignment: .top)
            
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40)),
                elementKind: SuplementaryViewsVC.footerKind,
                alignment: .bottom)
            
            section.boundarySupplementaryItems = [header, footer]
            
            return section
        }
    }
    
    func configDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, identifier -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return nil }
            cell.backgroundColor = .gray
            cell.title.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SuplementaryViewsVC.badgeElementKind:
                let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SuplementaryView.reuseIdentifier, for: indexPath) as! SuplementaryView
                badgeView.backgroundColor = .green
                badgeView.isHidden = indexPath.row % 2 == 0
                return badgeView
                
            case SuplementaryViewsVC.headerKind:
                let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SuplementaryView.reuseIdentifier, for: indexPath) as! SuplementaryView
                badgeView.backgroundColor = .yellow
                return badgeView

            case SuplementaryViewsVC.footerKind:
                let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SuplementaryView.reuseIdentifier, for: indexPath) as! SuplementaryView
                badgeView.backgroundColor = .blue
                return badgeView
            default:
                return nil
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(0..<30))
        dataSource.apply(snapshot)
    }
}

class SuplementaryView: UICollectionReusableView {
    static let reuseIdentifier = "badge-reuse-identifier"
    
}
