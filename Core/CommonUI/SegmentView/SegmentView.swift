//
//  SegmentView.swift
//  WeatherCore
//
//  Created by Oleg Petrychuk on 22.01.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

class SegmentView: LoadableView {
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var stepView: UIView!
    @IBOutlet private weak var stepViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var stepViewLeftSpacingConstraint: NSLayoutConstraint!
    
    public var didSelectSegment: ((Int) -> Void)?
    public var titles: [String] = [String]() {
        didSet {
            stackView.removeAllSubviews()
            titles
                .map{ button(withTitle: $0) }
                .forEach { stackView.addArrangedSubview($0) }
            stackView.layoutIfNeeded()
            selectedSegment = 0
        }
    }
    public var selectedSegment: Int = 0 {
        didSet {
            guard let view = stackView.subviews[safe: selectedSegment] else { return }
            animateSegmentView(view)
        }
    }
    
    override func setupNib() {
        super.setupNib()
        
        lineView.backgroundColor = Colors.ichigos
        stepView.backgroundColor = Colors.ichigos
    }
    
    private func button(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .filsonMediumWithSize(17)
        button.addTarget(self, action: #selector(onButtonDidTap), for: .touchUpInside)
        return button
    }
    
    private func animateSegmentView(_ view: UIView) {
        stepViewWidthConstraint.constant = view.bounds.size.width
        
        let newSegmentLeftOffset = view.frame.origin.x
        let duration = abs(stepViewLeftSpacingConstraint.constant - newSegmentLeftOffset) * 0.002
        stepViewLeftSpacingConstraint.constant = newSegmentLeftOffset
        
        UIView.animate(withDuration: TimeInterval(duration)) { self.layoutIfNeeded() }
    }
    
    @objc private func onButtonDidTap(_ sender: UIButton) {
        guard let index = stackView.subviews.index(of: sender) else { return }
        selectedSegment = index
        self.didSelectSegment?(index)
    }
}
