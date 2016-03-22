//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class ShotsCollectionViewController: UICollectionViewController {

    let stateManager = ShotsCollectionViewControllerStateManager()
    let shotsProvider = ShotsProvider()
    var shots = [ShotType]()
    private var onceTokenForInitialShotsAnimation = dispatch_once_t(0)

    //MARK - Life cycle

    @available(*, unavailable, message="Use init() method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(collectionViewLayout: stateManager.collectionViewLayout)
    }
}

//MARK - UIViewController
extension ShotsCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.pagingEnabled = true
        collectionView?.backgroundView = ShotsCollectionBackgroundView()
        collectionView?.registerClass(ShotCollectionViewCell.self, type: .Cell)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_once(&onceTokenForInitialShotsAnimation) {
            firstly {
                self.shotsProvider.provideShots()
                }.then { shots -> Void in
                    if let shots = shots {
                        self.shots = shots
                        self.collectionView?.reloadData()
                    }
                }.error { error in
                    // NGRTemp: Need mockups for error message view
                    print(error)
            }
        }
    }
}

//MARK - UICollectionViewDataSource
extension ShotsCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateManager.shotsCollectionViewDataSource.itemsCountForShots(shots, collectionView: collectionView, section: section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = stateManager.shotsCollectionViewDataSource.cellForShots(shots, collectionView: collectionView, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
}

extension ShotsCollectionViewController: ShotCollectionViewCellDelegate {

    func shotCollectionViewCellDidStartSwiping(_: ShotCollectionViewCell) {
        collectionView?.scrollEnabled = false
    }
    func shotCollectionViewCellDidEndSwiping(_: ShotCollectionViewCell) {
        collectionView?.scrollEnabled = true
    }
}

