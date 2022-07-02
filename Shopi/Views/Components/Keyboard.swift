
import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    let didChange = PassthroughSubject<CGFloat, Never>()
    
    private var _center: NotificationCenter
    private(set) var currentHeight: CGFloat = 0 {
        didSet {
            didChange.send(currentHeight)
        }
    }
    
    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        _center.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        // Keyboard will show.
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        // Keyboard will hide.
        currentHeight = 0
    }
}
