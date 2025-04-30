import UIKit

class SKRowListCell: SKListCell {
    
    // References
    
    var thumbnail: SKView?
    var labelContainer: SKView?
    var thumbnailContainer: SKView = SKView()
    var rightContainer: SKView = SKView()
    
    static var cellHeight: SKListCellHeight = 68

    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
        // General setup
        backgroundColor = .elevatedBackground
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.primaryBorder.cgColor
        
        // Shadow
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.03
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowRadius = 5
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        // Activate Constraints
        NSLayoutConstraint.activate([
           
        ])
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
