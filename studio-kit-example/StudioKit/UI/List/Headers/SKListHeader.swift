import UIKit

class SKListHeader: UICollectionReusableView {
    
    class var height: CGFloat {
       return 28
    }
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    let defaultTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Header"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
        self.addSubview(defaultTitleLabel)
        
        NSLayoutConstraint.activate([
            defaultTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            defaultTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            defaultTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func configure() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SKEmptyListHeader: SKListHeader {
    
    override class var height: CGFloat {
        return 10
    }
    
    override func setupViews() {
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Self.height),
        ])
    }
    
}
