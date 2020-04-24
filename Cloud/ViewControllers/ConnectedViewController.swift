import UIKit

final class ConnectedViewController: StandardSheetViewController {
    
    private enum ButtonType: Int {
        case showFriends = 0
        case hide = 1
    }
    
    override func actionButtonPressed(_ sender: UIButton) {
        guard let button = ButtonType(rawValue: sender.tag) else {
            preconditionFailure()
        }
        switch button {
        case .showFriends:
            print("Not implemented")
        case .hide:
            performSegue(withIdentifier: "Hide", sender: self)
        }
    }
}
