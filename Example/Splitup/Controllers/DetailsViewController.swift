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
            animateRollIndicator: true,
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
    
    // MARK: Table view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CollectionViewCell.cellSize(for: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellId, for: indexPath)
    }

}
