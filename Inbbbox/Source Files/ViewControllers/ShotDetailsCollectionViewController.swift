//
//  ShotDetailsCollectionViewController.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 05.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

protocol ShotDetailsCollectionViewControllerDelegate: class {
    func didFinishPresentingDetails(sender: ShotDetailsCollectionViewController)
}

class ShotDetailsCollectionViewController: UICollectionViewController {
    
    weak var delegate: ShotDetailsCollectionViewControllerDelegate?
    
    private var shotDetailsViewModel: ShotDetailsViewModel
    
    private var header = ShotDetailsHeaderView()
    private var footer = ShotDetailsFooterView()
    
    init(shot: Shot) {
        shotDetailsViewModel = ShotDetailsViewModel(shot: shot)
        super.init(collectionViewLayout: ShotDetailsCollectionViewFlowLayout())

        shotDetailsViewModel.delegate = self
        
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shotDetailsViewModel.loadComments { result in
            switch result {
            case .Success:
                self.collectionView?.reloadData()
            case .Error(let error):
                print(error)
            }
        }
    }
    
    // MARK: UICollectionViewController DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shotDetailsViewModel.itemsCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.item < shotDetailsViewModel.commentsCount {
            let cell = collectionView.dequeueReusableClass(ShotDetailsCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            cell.setupCell(shotDetailsViewModel.viewDataForCellAtIndex(indexPath.item))
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableClass(ShotDetailsLoadMoreCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            cell.setupCell(shotDetailsViewModel.viewDataForLoadMoreCell())
            cell.delegate = self
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableClass(ShotDetailsHeaderView.self, forIndexPath: indexPath, type: .Header)
            shotDetailsViewModel.viewDataForHeader { result, data in
                switch result {
                case .Success:
                    self.header.setupHeader(data!)
                case .Error(let error):
                    print(error)
                }
            }
            header.delegate = self
            self.header = header
            return header
        } else {
            let footer = collectionView.dequeueReusableClass(ShotDetailsFooterView.self, forIndexPath: indexPath, type: .Footer)
            footer.textField.delegate = self
            footer.delegate = self
            self.footer = footer
            return footer
        }
    }
    
    // MARK: UICollectionViewController Delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ShotDetailsCollectionViewCell {
            // NGRTodo: check if user can edit this comment (if it is user's comment)
            // what is more, first you should hide editView on all cells
            cell.showEditView()
        }
    }
    
    // MARK: Private
    
    private func setupSubviews() {
        // Backgrounds
        view.backgroundColor = UIColor.clearColor()
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        view.insertSubview(blurView, belowSubview: collectionView!)
        blurView.autoPinEdgesToSuperviewEdges()
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.layer.shadowColor = UIColor.grayColor().CGColor
        collectionView?.layer.shadowOffset = CGSize(width: 0, height: 0.1)
        collectionView?.layer.shadowOpacity = 0.3
        
        collectionView?.registerClass(ShotDetailsCollectionViewCell.self, type: .Cell)
        collectionView?.registerClass(ShotDetailsLoadMoreCollectionViewCell.self, type: .Cell)
        collectionView?.registerClass(ShotDetailsHeaderView.self, type: .Header)
        collectionView?.registerClass(ShotDetailsFooterView.self, type: .Footer)
        
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        shotDetailsViewModel.viewDataForHeader { result, data in
            switch result {
            case .Success:
                self.header.setupHeader(data!)
            case .Error(let error):
                print(error)
            }
        }
    }
}

// Mark: Authentication

extension ShotDetailsCollectionViewController {
    func showLoginView() {
        let interactionHandler: (UIViewController -> Void) = { controller in
            self.presentViewController(controller, animated: true, completion: nil)
        }
        let authenticator = Authenticator(interactionHandler: interactionHandler)
        
        firstly {
            authenticator.loginWithService(.Dribbble)
        }.then { Void in
            self.footer.textField.becomeFirstResponder()
        }
    }
}

extension ShotDetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // NGRHack: hacky code
    /*
        The problem is that after using `estimatedItemSize` and `preferredLayoutAttributesFittingAttributes` in cell
        it is properly calculated, but not when it first appears.
        After appearing it has `estimatedItemSize` as a size and turns into proper size just after scrolling the collectionView.
        I tried to force showing proper size just from the beginning of appearing and I ended up with this solution.
        I think it's dirty, but the only one working (surprisingly) properly...
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let collectionViewUsableWidth = collectionView.bounds.width - ((collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left + (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.right)
        var cellHeight: CGFloat
        
        // This value should be high enough to contain long comment and not to break constraints in cell
        let aLotButEnoughNotToBreakConstraints = CGFloat(5000)
        let initialFrame = CGRect(x: 0, y: 0, width: collectionViewUsableWidth, height: aLotButEnoughNotToBreakConstraints)
        if indexPath.item < shotDetailsViewModel.commentsCount {
            // NGRHack: It's not possible to use `dequeueReusableClass` cause it crashes.
            let cell = ShotDetailsCollectionViewCell(frame: initialFrame)
            cell.setupCell(shotDetailsViewModel.viewDataForCellAtIndex(indexPath.item))
            cell.layoutIfNeeded()
            cellHeight = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
        } else {
            // NGRHack: It's not possible to use `dequeueReusableClass` cause it crashes.
            let cell = ShotDetailsLoadMoreCollectionViewCell(frame: initialFrame)
            cell.layoutIfNeeded()
            cellHeight = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
        }
        return CGSize(width: collectionViewUsableWidth, height: cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return header.intrinsicContentSize()
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize {
            return footer.intrinsicContentSize()
    }
}

extension ShotDetailsCollectionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if !UserStorage.loggedIn {
            showLoginView()
            return false
        }
        
        if shotDetailsViewModel.compactVariantCanBeDisplayed {
            header.displayCompactVariant()
        }
        footer.displayEditingVariant()
        collectionViewLayout.invalidateLayout()
        collectionView?.layoutIfNeeded()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
       
        if textField.text!.isEmpty == true {
            
            textField.resignFirstResponder()
            
            if shotDetailsViewModel.compactVariantCanBeDisplayed {
                header.displayNormalVariant()
            }
            footer.displayNormalVariant()
        } else {
            delegate?.didFinishPresentingDetails(self)
        }
        collectionViewLayout.invalidateLayout()
        collectionView?.layoutIfNeeded()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ShotDetailsCollectionViewController: ShotDetailsHeaderViewDelegate {
    
    func shotDetailsHeaderView(view: ShotDetailsHeaderView, didTapCloseButton: UIButton) {
        footer.textField.resignFirstResponder()
        delegate?.didFinishPresentingDetails(self)
    }
    
    func shotDetailsHeaderViewDidTapLikeButton(like: Bool, completion: (operationSucceed: Bool) -> Void) {
        
        shotDetailsViewModel.userDidTapLikeButton(like) { result -> Void in
            switch result {
            case .Success:
                completion(operationSucceed: true)
            case .Error(_):
                completion(operationSucceed: false)
            }
        }
    }
}

extension ShotDetailsCollectionViewController: ShotDetailsCollectionViewCellDelegate {
    
    func shotDetailsCollectionViewCell(view: ShotDetailsCollectionViewCell, didTapCancelButton: UIButton) {
        view.hideEditView()
    }
    
    func shotDetailsCollectionViewCell(view: ShotDetailsCollectionViewCell, didTapDeleteButton: UIButton) {
        // NGRTodo: Implement me!
    }
}

extension ShotDetailsCollectionViewController: ShotDetailsLoadMoreCollectionViewCellDelegate {
    
    func shotDetailsLoadMoreCollectionViewCell(view: ShotDetailsLoadMoreCollectionViewCell, didTapLoadMoreButton: UIButton) {
        shotDetailsViewModel.loadComments { result in
            switch result {
            case .Success:
                break
            case .Error(let error):
                print(error)
            }
        }
    }
}

extension ShotDetailsCollectionViewController: ShotDetailsFooterViewDelegate {
    func shotDetailsFooterView(view: ShotDetailsFooterView, didTapAddCommentButton: UIButton, forMessage message: String?) {
        footer.textField.resignFirstResponder()
        if message?.isEmpty == false {
            shotDetailsViewModel.postComment(message!) { result in
                switch result {
                case .Success:
                    break
                case .Error(let error):
                    print(error)
                }
            }
        }
    }
}

extension ShotDetailsCollectionViewController: ShotDetailsViewModelDelegate {
    
    func performBatchUpdate(insertIndexPaths: [NSIndexPath], reloadIndexPaths: [NSIndexPath], deleteIndexPaths: [NSIndexPath]) {
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertItemsAtIndexPaths(insertIndexPaths)
            self.collectionView?.reloadItemsAtIndexPaths(reloadIndexPaths)
            self.collectionView?.deleteItemsAtIndexPaths(deleteIndexPaths)
            },
            completion:nil
        )
    }
    
    func presentAlertController(controller: UIAlertController) {
        presentViewController(controller, animated: true, completion: nil)
        controller.view.tintColor = UIColor.RGBA(0, 118, 255, 1)
    }
}
