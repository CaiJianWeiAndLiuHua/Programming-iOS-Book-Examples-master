

import UIKit

// pure template code, more or less
// I've added some comments and logging


class DetailViewController: UIViewController {
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var detailItem: AnyObject? {
        didSet {
            print("detailItem didset")
            self.configureView()
        }
    }

    func configureView() {
        print("detail view configureView")
        print("detailItem: \(self.detailItem)")
        print("label: \(self.detailDescriptionLabel)")
        // problem is that when user taps a date in the master view...
        // an entirely new detail view controller is created
        // thus its viewDidLoad is called, and configureView is called...
        // at a time when there is no detailItem yet
        // Then detailItem is set, and configureView is called again!
        // This seems nutty but we have to cover every case...
        // ... because we don't know the order of events:
        // could be detailItem first, then viewDidLoad
        // in portrait view, it is; on iPhone it is
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("detail view viewdidload")
        self.configureView()
    }
}

extension DetailViewController {
    override func targetViewControllerForAction(action: Selector, sender: AnyObject?) -> UIViewController? {
        print("detail view controller target for \(action) \(sender)...")
        let result = super.targetViewControllerForAction(action, sender: sender)
        print("detail view controller target for \(action), returning \(result)")
        return result
    }
    
    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        print("detail view controller showViewController")
        super.showViewController(vc, sender: sender)
    }
    
    override func showDetailViewController(vc: UIViewController, sender: AnyObject?) {
        print("detail view controller showDetailViewController")
        super.showDetailViewController(vc, sender: sender)
    }
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        let ok = super.respondsToSelector(aSelector)
        if aSelector == #selector(showDetailViewController) {
            print("detail responds? \(ok)")
        }
        return ok
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        let ok = super.canPerformAction(action, withSender:sender)
        if action == #selector(showDetailViewController) {
            print("detail can perform? \(ok)")
        }
        return ok
    }



}

