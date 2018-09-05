//
//  SegmentView.swift
//  WeatherCore
//
//  Created by Oleg Petrychuk on 22.01.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

class SegmentView: LoadableView {
    public var didSelectAtIndex : ((Int) -> Void)?
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var stepView: UIView!
    @IBOutlet private weak var stepViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var stepViewLeftSpacingConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        lineView.backgroundColor = .ichigos
        stepView.backgroundColor = .ichigos
    }
    
    func addSegmentWithTitle(title: String) {
        stackView.addArrangedSubview(button(withTitle: title))
        stackView.layoutIfNeeded()
    }

    func setSegment(atIndex index: Int) {
        if let view = stackView.subviews[safe: index] {
            animateSegmentView(view)
        }
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
        
        UIView.animate(withDuration: Double(duration)) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func onButtonDidTap(_ sender: UIButton) {
        guard let index = stackView.subviews.index(of: sender) else { return }
        setSegment(atIndex: index)
        self.didSelectAtIndex?(index)
    }
}
