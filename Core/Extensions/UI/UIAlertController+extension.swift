//
//  UIAlertController+extension.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func show(title: String, message: String) -> Driver<Void> {
        return Observable.create { observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                observer.onNext(())
                observer.onCompleted()
            })
            alert.addAction(okAction)
            alert.presenter().present()
            return Disposables.create {
                alert.close()
            }
        }.asDriver(onErrorJustReturn: ())
    }
}

public protocol AlertProducer {
    var shouldShowAlert: Driver<AlertData> { get }
}
