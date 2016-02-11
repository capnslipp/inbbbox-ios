//
//  ShotDetailsCollectionViewController.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 05.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol ShotDetailsCollectionViewControllerDelegate: class {
    func didFinishPresentingDetails(sender: ShotDetailsCollectionViewController)
}

class ShotDetailsCollectionViewController: UICollectionViewController {
    
    weak var delegate: ShotDetailsCollectionViewControllerDelegate?
    private var header = ShotDetailsHeaderView()
    private var footer = ShotDetailsFooterView()
    
    private var shot: Shot?
    
    convenience init(shot: Shot) {
        self.init(collectionViewLayout: ShotDetailsCollectionViewFlowLayout())
        // NGRTemp: Until model hooked up
        
        self.shot = shot
        
        // NGRTodo: get image async
        let imageUrl = shot.image.normalURL.absoluteString
        let shotDescription = shot.description
        let title = shot.title
        let author = shot.user.name ?? shot.user.username
        let client = "Client link"
        let info = "app name + date"
        let avatar = shot.user.avatarString!
        
        header.viewData = ShotDetailsHeaderView.ViewData(description: shotDescription,
            title: title!,
            author: author,
            client: client,
            shotInfo: info,
            shot: imageUrl,
            avatar: avatar
        )
        setupSubviews()
    }
    
    // MARK: UICollectionViewController DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableClass(ShotDetailsCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        cell.viewData = ShotDetailsCollectionViewCell.ViewData(avatar: "", author: "author", comment: "comment", time: "time")
        
        return cell
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
        
        collectionView?.registerClass(ShotDetailsCollectionViewCell.self, type: .Cell)
        collectionView?.registerClass(ShotDetailsHeaderView.self, type: .Header)
        collectionView?.registerClass(ShotDetailsFooterView.self, type: .Footer)
    }
}

extension ShotDetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - ((collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left + (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.right), height: 100)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return header.requiredSize()
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize {
            return footer.requiredSize()
    }
}

extension ShotDetailsCollectionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        header.displayCompactVariant()
        footer.displayEditingVariant()
        collectionViewLayout.invalidateLayout()
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