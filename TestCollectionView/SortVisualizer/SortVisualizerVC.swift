//
//  SortVisualizerVC.swift
//  TestCollectionView
//
//  Created by Nguyen Dinh Cong on 2019/12/06.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

class SortVisualizerVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    var items: [Int] = []
    var currentIndex = 0
    
    var timer: Timer?
    
    enum Section {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sort Visualizer"
        
        configureNavItem()
        configHierachy()
        configDataSource()
    }
    
    func configHierachy() {
        collectionView.register(UINib(nibName: "SortCell", bundle: nil), forCellWithReuseIdentifier: "SortCell")
        collectionView.collectionViewLayout = createLayout()
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnv -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .absolute(layoutEnv.container.effectiveContentSize.width / CGFloat(self.items.count)),
                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = .init(top: 1.0, leading: 1.0, bottom: 1.0, trailing: 1.0)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)),
                subitems: [item])
            
            return NSCollectionLayoutSection(group: group)
        }
    }
    
    func configDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, identifier -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortCell", for: indexPath) as! SortCell
            cell.heightConstraint.constant = CGFloat(identifier) / CGFloat(self.items.count) * (collectionView.frame.height - 40)
            return cell
        })
        
        applyData()
    }
    
    func applyData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(toggleSort))
    }
    
    @objc func toggleSort() {
        items = Array(0..<100).shuffled()
        
        currentIndex = 0
        timer?.invalidate()
        processNext()
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension SortVisualizerVC {
    func processNext() {
        let indexToBeSorted = currentIndex + 1
        
        if indexToBeSorted >= items.count { return }
        
        for i in 0...currentIndex {
            if items[indexToBeSorted] < items[i] {
                let removedItem = items.remove(at: indexToBeSorted)
                items.insert(removedItem, at: i)
                break
            }
        }
        
        currentIndex = indexToBeSorted
        
        applyData()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { [weak self] _ in
            self?.processNext()
        }
    }
}
