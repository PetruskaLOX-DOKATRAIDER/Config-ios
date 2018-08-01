//
//  NewsDescriptionViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class NewsDescriptionViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var detailsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.textColor = .amethyst
        titleLabel.font = UIFont.filsonMediumWithSize(23)
        
        subtitleLabel.textColor = .amethyst
        subtitleLabel.font = UIFont.filsonMediumWithSize(18)
        
        descriptionLabel.textColor = .sungray
        descriptionLabel.font = .filsonRegularWithSize(15)
        
        shareButton.setTitle(Strings.Newsdescription.share, for: .normal)
        detailsButton.setTitle(Strings.Newsdescription.details, for: .normal)
        [shareButton, detailsButton].forEach{
            $0?.backgroundColor = .ichigos
            $0?.setTitleColor(.snowWhite, for: .normal)
            $0?.titleLabel?.font = .filsonMediumWithSize(18)
            $0?.applyShadow(color: UIColor.ichigos.cgColor)
        }
    }
    
    public func onUpdate(with viewModel: NewsDescriptionViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.subtitle.drive(subtitleLabel.rx.text).disposed(by: disposeBag)
        viewModel.description.drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.coverImageURL.drive(coverImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.isWorking.drive(view.rx.activityIndicator).disposed(by: disposeBag)
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        detailsButton.rx.tap.bind(to: viewModel.detailsTrigger).disposed(by: disposeBag)
        shareButton.rx.tap.bind(to: viewModel.shareTrigger).disposed(by: disposeBag)
        
        viewModel.content.drive(onNext: { [weak self] content in
            guard let strongSelf = self else { return }
            //strongSelf.contentStackView.removeAllSubviews()
            content.forEach{ item in
                if let viewModel = item as? NewsImageContentItemViewModel {
                    strongSelf.addImageContentView(withViewModel: viewModel)
                } else if let viewModel = item as? NewsTextContentItemViewModel {
                    strongSelf.addTextContentView(withViewModel: viewModel)
                }
            }
        }).disposed(by: rx.disposeBag)
        
        let animationsDuration = 0.8
        viewModel.isDataAvaliable.map{ $0 ? 1 : 0 }.drive(onNext: { [weak self] alpha in
            UIView.animate(withDuration: animationsDuration, animations:{ self?.coverImageView.alpha = alpha })
        }).disposed(by: disposeBag)
        viewModel.isDataAvaliable.drive(onNext: { [weak self] isDataAvaliable in
            let newConstant: CGFloat = isDataAvaliable ? 60 : self?.view.bounds.size.height ?? 0
            self?.scrollViewTopConstraint.constant = newConstant
            UIView.animate(withDuration: animationsDuration, animations: { self?.view.layoutIfNeeded() })
        }).disposed(by: disposeBag)
        
        viewModel.refreshTrigger.onNext(())
    }
    
    private func addImageContentView(withViewModel viewModel: NewsImageContentItemViewModel) {
        let view = NewsImageContentItemView()
        view.viewModel = viewModel
        contentStackView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.height.equalTo(self.view.bounds.size.height * 0.3)
        }
    }
    
    private func addTextContentView(withViewModel viewModel: NewsTextContentItemViewModel) {
        let view = NewsTextContentItemView()
        view.viewModel = viewModel
        contentStackView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.height.equalTo(100)
        }
    }
}
