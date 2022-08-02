import UIKit

class GroupCell: UITableViewCell {
   
    @IBOutlet private weak var title: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = UIColor.systemBackground
        title.text = nil
    }
    
    func setTitle(with title: String) {
        self.title.text = title
    }
}

