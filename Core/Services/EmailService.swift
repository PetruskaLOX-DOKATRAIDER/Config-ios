//
//  EmailService.swift
//  Core
//
//  Created by Oleg Petrychuk on 10.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import MessageUI

public enum EmailServiceError: Error {
    case noAccount
    case cancelled
    case saved
    case failed
    case unknown(Error)
}

public struct EmailInfo {
    let recipients: [String]
    let subject: String
    let message: String

    public init(
        recipient: String = "",
        subject: String = "",
        message: String = ""
    ) {
        self.recipients = [recipient]
        self.subject = subject
        self.message = message
    }
}

public protocol EmailService {
    func send(withInfo info: EmailInfo) -> DriverResult<Void, EmailServiceError>
}

public final class EmailServiceImpl: NSObject, EmailService, MFMailComposeViewControllerDelegate {
    private let sendResult: BehaviorRelay<Result<Void, EmailServiceError>?> = BehaviorRelay(value: nil)
    private let router: Router
    private let emailAbility: EmailAbility.Type
    
    public init(
        router: Router,
        emailAbility: EmailAbility.Type = MFMailComposeViewController.self // for tests
    ) {
        self.router = router
        self.emailAbility = emailAbility
    }
    
    public func send(withInfo info: EmailInfo) -> DriverResult<Void, EmailServiceError> {
        guard emailAbility.canSendMail() else { return .just(Result(error: .noAccount)) }
        let vc = mailComposeVC(withInfo: info)
        router.appRouter.topViewController?.navigationController?.present(vc, animated: true, completion: nil)
        return sendResult.asDriver().filterNil()
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            sendResult.accept(Result(error: .unknown(error)))
        }
        
        switch result {
        case .cancelled: sendResult.accept(Result(error: .cancelled))
        case .saved: sendResult.accept(Result(error: .saved))
        case .sent: sendResult.accept(Result(value: ()))
        case .failed: sendResult.accept(Result(error: .failed))
        }
        
        router.appRouter.topViewController?.close()
    }
    
    private func mailComposeVC(withInfo emailInfo: EmailInfo) -> UIViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        return vc
    }
}

public protocol EmailAbility {
    static func canSendMail() -> Bool
}
extension MFMailComposeViewController: EmailAbility {}

extension EmailServiceError: Equatable {
    public static func == (lhs: EmailServiceError, rhs: EmailServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.noAccount, .noAccount): return true
        case (.cancelled, .cancelled): return true
        case (.saved, .saved): return true
        case (.failed, .failed): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}
