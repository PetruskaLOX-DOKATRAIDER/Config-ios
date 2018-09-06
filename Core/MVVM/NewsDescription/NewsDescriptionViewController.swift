//
//  NewsDescriptionViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class NewsDescriptionViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var detailsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var buttonsContainerView: UIView!
    @IBOutlet private weak var coverImageGradientView: GradientView!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var coverImageContainerView: UIView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.News.title
        view.backgroundColor = .bagdet
        
        titleLabel.textColor = .snowWhite
        titleLabel.font = .filsonMediumWithSize(23)
        
        subtitleLabel.textColor = .solled
        subtitleLabel.font = .filsonMediumWithSize(18)
        
        descriptionLabel.textColor = .solled
        descriptionLabel.font = .filsonRegularWithSize(15)

        coverImageGradientView.startColor = .clear
        coverImageGradientView.endColor = .bagdet
        
        shareButton.setTitle(Strings.Newsdescription.share, for: .normal)
        shareButton.backgroundColor = .ichigos
        shareButton.setTitleColor(.snowWhite, for: .normal)
        shareButton.titleLabel?.font = .filsonMediumWithSize(17)
        shareButton.applyShadow(color: UIColor.ichigos.cgColor)
        
        detailsButton.setTitle(Strings.Newsdescription.details, for: .normal)
        detailsButton.backgroundColor = .ichigos
        detailsButton.setTitleColor(.snowWhite, for: .normal)
        detailsButton.titleLabel?.font = .filsonBoldWithSize(18)
        detailsButton.applyShadow(color: UIColor.ichigos.cgColor)
    }
    
    public func onUpdate(with viewModel: NewsDescriptionViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.subtitle.drive(subtitleLabel.rx.text).disposed(by: disposeBag)
        viewModel.description.drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.coverImageURL.drive(coverImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.isWorking.drive(view.rx.activityIndicator).disposed(by: disposeBag)
        viewModel.messageViewModel.drive(view.rx.messageView).disposed(by: disposeBag)
        viewModel.content.filterEmpty().drive(onNext: { [weak self] in self?.mapContent($0) }).disposed(by: rx.disposeBag)
        viewModel.isDataAvaliable.drive(onNext: { [weak self] in self?.showContent($0) }).disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        detailsButton.rx.tap.bind(to: viewModel.detailsTrigger).disposed(by: disposeBag)
        shareButton.rx.tap.bind(to: viewModel.shareTrigger).disposed(by: disposeBag)
        viewModel.refreshTrigger.onNext(())
    }
    
    private func showContent(_ show: Bool) {
        let alpha: CGFloat = show ? 1 : 0
        UIView.animate(withDuration: 1.3, animations: {
            self.coverImageContainerView.alpha = alpha
            self.buttonsContainerView.alpha = alpha
        })
        
        let contentBottomOffset: CGFloat = 60
        let newConstant: CGFloat = show ? contentBottomOffset : view.bounds.size.height
        self.scrollViewTopConstraint.constant = newConstant
        UIView.animate(withDuration: 1.3, animations: { self.view.layoutIfNeeded() })
    }
    
    private func mapContent(_ content: [NewsContentItemViewModel]) {
        content.forEach { item in
            if let viewModel = item as? NewsImageContentItemViewModel {
                addImageContentView(withViewModel: viewModel)
            } else if let viewModel = item as? NewsTextContentItemViewModel {
                addTextContentView(withViewModel: viewModel)
            }
        }
        addSeparatorView(height: 55)
        view.layoutIfNeeded()
    }
    
    private func addImageContentView(withViewModel viewModel: NewsImageContentItemViewModel) {
        let height: CGFloat = CGFloat(self.view.bounds.size.height * 0.3)
        let view = NewsImageContentItemView(frame: CGRect(x: 0, y: 0, width: contentStackView.bounds.size.width, height: height))
        view.viewModel = viewModel
        contentStackView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
    
    private func addTextContentView(withViewModel viewModel: NewsTextContentItemViewModel) {
        let view = NewsTextContentItemView(frame: CGRect(x: 0, y: 0, width: contentStackView.bounds.size.width, height: 75))
        view.viewModel = viewModel
        contentStackView.addArrangedSubview(view)
    }
    
    private func addSeparatorView(height: CGFloat) {
        let view = UIView()
        view.backgroundColor = .clear
        contentStackView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
}
