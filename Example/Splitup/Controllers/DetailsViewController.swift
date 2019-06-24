//
//  DetailsViewController.swift
//  Split Back
//
//  Created by Alex Bozhko on 06/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit
import Splitup

class DetailsViewController: UIViewController, SplitUpContainerConfig, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var containerConfig: SplitUpContainer.Config {
        return SplitUpContainer.Config(
            position: .front,
            animateRollIndicator: false,
            closeButtonImage: nil
        )
    }
    
    var scrollViewForSplit: UIScrollView? {
        return detailsView.collectionView
    }
    
    
    // MARK: Properties
    
    var detailsView: DetailsView! { return view as? DetailsView }
    
    override func loadView() {
        view = DetailsView(for: self)
    }
    
    // MARK: UI actions
    
    @objc func refresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.endRefreshing()
        }
    }
    
    @objc func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Table view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            return ListCell.cellSize(for: collectionView)
        }
        return CollectionViewCell.cellSize(for: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.cellId, for: indexPath)
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellId, for: indexPath)
    }

}
