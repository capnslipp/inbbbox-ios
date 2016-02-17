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
    
    var localStorage = ShotsLocalStorage()
    var userStorageClass = UserStorage.self
    var shotOperationRequesterClass =  ShotOperationRequester.self
    
    private let commentsProvider = CommentsProvider(page: 1, pagination: 10)
    
    private var header = ShotDetailsHeaderView()
    private var footer = ShotDetailsFooterView()
    
    private var shot: Shot?
    private var comments: [Comment]?
    private let changingHeaderStyleCommentsThreshold = 3
    
    convenience init(shot: Shot) {
        self.init(collectionViewLayout: ShotDetailsCollectionViewFlowLayout())
        self.shot = shot
        
        setupSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly {
            self.commentsProvider.provideCommentsForShot(shot!)
        }.then { comments -> Void in
            self.comments = comments ?? []
            self.collectionView?.reloadData()
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    // MARK: UICollectionViewController DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let comments = comments else { return 0 }
        
        // NGRFix: interesting '>='? added because of problem when somebody adds comment between shot loading and comments loading
        return comments.count >= Int(shot!.commentsCount) ? comments.count : comments.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item < comments!.count {
            
            let cell = collectionView.dequeueReusableClass(ShotDetailsCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            
            let comment = comments![indexPath.item]
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            dateFormatter.timeStyle = .ShortStyle
            
            cell.viewData = ShotDetailsCollectionViewCell.ViewData(
                avatar: comment.user.avatarString!,
                author: comment.user.name ?? comment.user.username,
                comment: comment.body?.mutableCopy() as? NSMutableAttributedString ?? NSMutableAttributedString(),
                time: dateFormatter.stringFromDate(comment.createdAt)
            )
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableClass(ShotDetailsLoadMoreCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
            
            let difference = Int(shot!.commentsCount) - self.comments!.count
            cell.viewData = ShotDetailsLoadMoreCollectionViewCell.ViewData(
                commentsCount: difference > Int(commentsProvider.pagination) ? Int(commentsProvider.pagination).stringValue : difference.stringValue
            )
            cell.delegate = self
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableClass(ShotDetailsHeaderView.self, forIndexPath: indexPath, type: .Header)
            header.viewData = self.header.viewData
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
    
    // MARK: Private
    
    private func setupSubviews() {
        // Backgrounds
        view.backgroundColor = UIColor.clearColor()
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        view.insertSubview(blur, belowSubview: collectionView!)
        blur.autoPinEdgesToSuperviewEdges()
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.layer.shadowColor = UIColor.grayColor().CGColor
        collectionView?.layer.shadowOffset = CGSize(width: 0, height: 0.1)
        collectionView?.layer.shadowOpacity = 0.3
        
        collectionView?.registerClass(ShotDetailsCollectionViewCell.self, type: .Cell)
        collectionView?.registerClass(ShotDetailsLoadMoreCollectionViewCell.self, type: .Cell)
        collectionView?.registerClass(ShotDetailsHeaderView.self, type: .Header)
        collectionView?.registerClass(ShotDetailsFooterView.self, type: .Footer)
        
        
        // NGRTodo: move somewhere
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        
        if self.userStorageClass.currentUser != nil {
            // NGRFixme: call API for `Check if you like a shot`
        } else {
            let shotIsLiked = localStorage.likedShots.contains{
                $0.id == self.shot?.identifier
            }
            let viewData = ShotDetailsHeaderView.ViewData(
                description: shot!.description?.mutableCopy() as? NSMutableAttributedString,
                title: shot!.title!,
                author: shot!.user.name ?? shot!.user.username,
                client: shot!.team?.name,
                shotInfo: dateFormatter.stringFromDate(shot!.createdAt),
                shot: shot!.image.normalURL.absoluteString,
                avatar: shot!.user.avatarString!,
                shotLiked:  shotIsLiked,
                shotInBuckets: true // NGRTodo: provide this info
            )
            
            header = ShotDetailsHeaderView(viewData: viewData)

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
        
        let aLotButEnoughNotToBreakConstraints = CGFloat(5000)
        
        if indexPath.item < comments!.count {
            
            // NGRHack: It's not possible to use `dequeueReusableClass` cause it crashes.
            // This value should be high enough to contain long comment and not to break constraints in cell
            let cell = ShotDetailsCollectionViewCell(frame: CGRect(x: 0, y: 0, width: collectionViewUsableWidth, height: aLotButEnoughNotToBreakConstraints))
            
            let comment = comments![indexPath.item]
            
            cell.viewData = ShotDetailsCollectionViewCell.ViewData(
                avatar: comment.user.avatarString!,
                author: comment.user.name ?? comment.user.username,
                comment: comment.body?.mutableCopy() as? NSMutableAttributedString ?? NSMutableAttributedString(),
                time: "time"
            )
            
            cell.layoutIfNeeded()
            
            cellHeight = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
        } else {
            // NGRHack: It's not possible to use `dequeueReusableClass` cause it crashes.
            // This value should be high enough to contain long comment and not to break constraints in cell
            let cell = ShotDetailsLoadMoreCollectionViewCell(frame: CGRect(x: 0, y: 0, width: collectionViewUsableWidth, height: aLotButEnoughNotToBreakConstraints))
            
            cell.layoutIfNeeded()
            cellHeight = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
        }

        
        let size = CGSize(width: collectionViewUsableWidth, height: cellHeight)
        return size
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return header.intrinsicContentSize()
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize {
            return footer.requiredSize()
    }
}

extension ShotDetailsCollectionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let cellCount = (comments != nil) ? comments!.count : 0
        if cellCount >= changingHeaderStyleCommentsThreshold {
            header.displayCompactVariant()
        }
        footer.displayEditingVariant()
        collectionViewLayout.invalidateLayout()
        collectionView?.layoutIfNeeded()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        delegate?.didFinishPresentingDetails(self)
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
        
        // NGRTemp: will be refactored
        if like {
            if self.userStorageClass.currentUser != nil {
                let promise = self.shotOperationRequesterClass.likeShot(self.shot!.identifier)
                if let _ = promise.error {
                    completion(operationSucceed: false)
                }
            } else {
                do {
                    try self.localStorage.like(shotID: self.shot!.identifier)
                    
                } catch {
                    completion(operationSucceed: false)
                    return
                }
            }
            completion(operationSucceed: true)
        } else {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action -> Void in
                actionSheet.dismissViewControllerAnimated(true, completion: nil)
            }
            
            let unlikeAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Unlike", comment: ""), style: .Destructive) { action -> Void in
                if self.userStorageClass.currentUser != nil {
                    let promise = self.shotOperationRequesterClass.unlikeShot(self.shot!.identifier)
                    if let _ = promise.error {
                        completion(operationSucceed: false)
                    }
                } else {
                    do {
                        try self.localStorage.unlike(shotID: self.shot!.identifier)
                    } catch {
                        completion(operationSucceed: false)
                        return
                    }
                }
                completion(operationSucceed: true)
            }
            actionSheet.addAction(cancelAction)
            actionSheet.addAction(unlikeAction)
            
            presentViewController(actionSheet, animated: true, completion: nil)
            actionSheet.view.tintColor = UIColor.RGBA(0, 118, 255, 1)
        }
    }
}

extension ShotDetailsCollectionViewController: ShotDetailsLoadMoreCollectionViewCellDelegate {
    
    func shotDetailsLoadMoreCollectionViewCell(view: ShotDetailsLoadMoreCollectionViewCell, didTapLoadMoreButton: UIButton) {
        // NGRTodo: implement me!
        firstly {
            self.commentsProvider.nextPage()//provideCommentsForShot(shot!)
        }.then { comments -> Void in
            self.appendCommentsAndUpdateCollectionView(comments! as [Comment], loadMoreCell: view)
        }.then {
            print("") // NGRTodo: check if `load more...` should be visible and update comments count if needed
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    private func appendCommentsAndUpdateCollectionView(comments: [Comment], loadMoreCell: ShotDetailsLoadMoreCollectionViewCell) -> Promise<Void> {
        
        let currentCommentCount = self.comments!.count
        var indexPathsToInsert = [NSIndexPath]()
        var indexPathsToReload = [NSIndexPath]()
        var indexPathsToDelete = [NSIndexPath]()
        
        self.comments!.appendContentsOf(comments)
        
        for i in currentCommentCount..<self.comments!.count {
            indexPathsToInsert.append(NSIndexPath(forItem: i, inSection: 0))
        }
        
        if self.comments!.count < Int(shot!.commentsCount) {
            indexPathsToReload.append(collectionView!.indexPathForCell(loadMoreCell)!)
        } else {
            indexPathsToDelete.append(collectionView!.indexPathForCell(loadMoreCell)!)
        }
        
        self.collectionView?.performBatchUpdates({
                self.collectionView?.insertItemsAtIndexPaths(indexPathsToInsert)
                self.collectionView?.reloadItemsAtIndexPaths(indexPathsToReload)
                self.collectionView?.deleteItemsAtIndexPaths(indexPathsToDelete)
            },
            completion:nil
        )
        
        return Promise()
    }
}

extension ShotDetailsCollectionViewController: ShotDetailsFooterViewDelegate {
    func shotDetailsFooterView(view: ShotDetailsFooterView, didTapAddCommentButton: UIButton, forMessage message: String?) {
        if message?.isEmpty == true {
            footer.textField.becomeFirstResponder()
        } else {
            delegate?.didFinishPresentingDetails(self)
        }
    }
}