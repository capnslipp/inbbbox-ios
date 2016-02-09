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
    var layout = ShotDetailsCollectionViewFlowLayout()
    var header = ShotDetailsHeaderView()
    var footer = ShotDetailsFooterView()
    
    convenience init() {
        self.init(collectionViewLayout: ShotDetailsCollectionViewFlowLayout())
        // NGRTemp: Until model hooked up
        let image = UIImage(named: "shot-menu")!
        let shotDescription = "Hey Dribbblers! We are Netguru, a team of 150+ web and mobile software experts. We are just starting with design and want to build something for this awesome community. What’s the plan? Creating and launching Inbbbox - an inbox app for your Dribbble shots. Our developers team will release two native apps (iOS and Android) at the beginning of next year!Hey Dribbblers! We are Netguru, a team of 150+ web and mobile software experts. We are just starting with design and want to build something for this awesome community. What’s the plan? Creating and launching Inbbbox - an inbox app for your Dribbble shots. Our developers team will release two native apps (iOS and Android) at the beginning of next year!Hey Dribbblers! We are Netguru, a team of 150+ web and mobile software experts. We are just starting with design and want to build something for this awesome community. What’s the plan? Creating and launching Inbbbox - an inbox app for your Dribbble shots. Our developers team will release two native apps (iOS and Android) at the beginning of next year!Hey Dribbblers! We are Netguru, a team of 150+ web and mobile software experts. We are just starting with design and want to build something for this awesome community. What’s the plan? Creating and launching Inbbbox - an inbox app for your Dribbble shots. Our developers team will release two native apps (iOS and Android) at the beginning of next year!\n###############################"
        let title = "Weather Calendar Application"
        let author = "Author link"
        let client = "Client link"
        let info = "app name + date"
        
        header.viewData = ShotDetailsHeaderView.ViewData(description: shotDescription,
            title: title,
            author: author,
            client: client,
            shotInfo: info,
            shot: image,
            avatar: image
        )
        layout = collectionViewLayout as! ShotDetailsCollectionViewFlowLayout
        setupSubviews()
    }
    
    // MARK: UICollectionViewController DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableClass(ShotDetailsCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableClass(ShotDetailsHeaderView.self, forIndexPath: indexPath, type: .Header)
            header.setNeedsUpdateConstraints()
            header.updateConstraintsIfNeeded()
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
    
    private func finishPresentation() {
        delegate?.didFinishPresentingDetails(self)
    }
}

extension ShotDetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            // NGRFixme: this is not computing size properly (although constraints in header seems to be correct)
            return header.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize)
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
        layout.invalidateLayout()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        finishPresentation()
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
        finishPresentation()
    }
}

extension ShotDetailsCollectionViewController: ShotDetailsFooterViewDelegate {
    func shotDetailsFooterView(view: ShotDetailsFooterView, didTapAddCommentButton: UIButton, forMessage message: String?) {
        if message?.isEmpty == true {
            footer.textField.becomeFirstResponder()
        } else {
            finishPresentation()
        }
    }
}
