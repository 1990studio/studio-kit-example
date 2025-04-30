import UIKit

class SKView: UIView {
    
    // Gesture
    var tapGesture: UITapGestureRecognizer?
    
    // Convenient place to reference constraints
    var trailingConstraint: NSLayoutConstraint?
    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    var onTap: (() -> Void)? {
        didSet {
            if let gesture = tapGesture {
                self.removeGestureRecognizer(gesture)
            }
            let tapGesture = UITapGestureRecognizer(target:self, action: #selector(handleTapGesture))
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @objc func handleTapGesture() {
        onTap?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
