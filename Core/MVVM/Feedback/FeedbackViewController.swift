//
//  FeedbackViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 27.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class FeedbackViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var messageContainerView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardAvoiding.avoid(with: containerBottomConstraint, inside: view).disposed(by: rx.disposeBag)
        containerBottomConstraint.constant = (view.bounds.size.height / 2) - containerView.bounds.size.height
        
        titleLabel.text = Strings.Feedback.title
        titleLabel.font = .filsonMediumWithSize(17)
        titleLabel.textColor = Colors.snowWhite
        
        separatorView.backgroundColor = Colors.solled
        containerView.backgroundColor = Colors.bagdet
        
        messageTextField.font = .filsonRegularWithSize(15)
        messageTextField.textColor = Colors.solled
        messageTextField.placeHolderColor = Colors.solled
        messageContainerView.backgroundColor = Colors.amethyst
        
        sendButton.backgroundColor = Colors.ichigos
        sendButton.titleLabel?.font = .filsonMediumWithSize(16)
        sendButton.setTitle(Strings.Feedback.send, for: .normal)
        sendButton.setTitleColor(Colors.snowWhite, for: .normal)
    }
    
    public func onUpdate(with viewModel: FeedbackViewModel, disposeBag: DisposeBag) {
        messageTextField.viewModel = viewModel.messageTextFieldViewModel
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        sendButton.rx.tap.bind(to: viewModel.sendTrigger).disposed(by: disposeBag)
    }
}
