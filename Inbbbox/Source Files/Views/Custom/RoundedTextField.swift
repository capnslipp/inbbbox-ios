//
// Created by Lukasz Pikor on 01.02.2016.
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class RoundedTextField: RoundedView {

    // Public Properties
    let textField: UITextField
    
    // Private Properties
    private var didUpdateConstraints = false
    
    // MARK: Life Cycle

    override init(frame: CGRect) {
        textField = UITextField.newAutoLayoutView()
        
        super.init(frame: frame)
        
        addSubview(textField)
    }
    
    // MARK: Auto Layout
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            textField.autoPinEdgesToSuperviewEdges()
            
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
}
