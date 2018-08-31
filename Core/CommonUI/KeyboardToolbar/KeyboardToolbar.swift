//
//  KeyboardToolbar.swift
//  Core
//
//  Created by Oleg Petrychuk on 27.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import LoadableViews

public class KeyboardToolbar: LoadableView {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    required public init(
        cancelTitle: String = Strings.Keybardtoolbar.cancel,
        submitButtonTitle: String? = nil
    ) {
        super.init(frame: .zero)
        setup()
        cancelButton.setTitle(cancelTitle, for: .normal)
        submitButton.setTitle(submitButtonTitle, for: .normal)
        submitButton.isHidden = submitButtonTitle.isNilOrEmpty
    }
    
    private func setup() {
        cancelButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.endEditing(true)
        }).disposed(by: rx.disposeBag)
        
        backgroundColor = .amethyst
        
        [cancelButton, submitButton].forEach {
            $0?.titleLabel?.font = .filsonMediumWithSize(15)
            $0?.setTitleColor(.ichigos, for: .normal)
        }
    }
}