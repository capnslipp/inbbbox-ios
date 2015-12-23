//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol InitialShotsCollectionViewLayoutDelegate: class {
    func initialShotsCollectionViewDidFinishAnimations()
}

final class InitialShotsCollectionViewController: UICollectionViewController {

    weak var delegate: InitialShotsCollectionViewLayoutDelegate?

//    MARK: - Life cycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init() {
        self.init(collectionViewLayout: InitialShotsCollectionViewLayout(itemsCount: 3))
    }

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

//    MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        if let collectionView = collectionView {
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.pagingEnabled = true
            collectionView.registerClass(ShotCollectionViewCell.self, type: .Cell)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapCollectionView:")
            collectionView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

//    MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // NGRTodo: implement me!
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
    }

//    MARK: - Actions

    func didTapCollectionView(_: UITapGestureRecognizer) {
        // NGRTemp: temporary implementation
        // NGRTodo: will be invoked after animations finish
        delegate?.initialShotsCollectionViewDidFinishAnimations()
    }
}
