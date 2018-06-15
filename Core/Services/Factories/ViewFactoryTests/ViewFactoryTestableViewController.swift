import UIKit
import ReusableView
import RxSwift

class ViewFactoryTestableViewController: UIViewController, NonReusableViewProtocol {
    var recevedViewModel: String?
    func onUpdate(with viewModel: String, disposeBag: DisposeBag) {
        recevedViewModel = viewModel
    }
}
