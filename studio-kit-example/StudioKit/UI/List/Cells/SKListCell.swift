import UIKit

class SKListCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    class var placeholderCell: SKListCell.Type? {
        return nil
    }
    
    var label: UILabel?
    
    var width: CGFloat = 200

    override init(frame: CGRect) {
        super.init(frame: frame)

//        contentView.backgroundColor = .gray
        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.layer.cornerRadius = 8
        
//        let label = UILabel()
//        label.text = "Title"
//        label.textColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(label)
//        self.label = label

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
//            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
    
    func setIsSelected() {}
    
    func setIsDeselected() {}
    
    func willDisplay() {}
    
    func didBecomeSelectable(isSelected: Bool) {
        if isSelected { setIsSelected() } else { setIsDeselected() }
    }
    
    func didBecomeDeselectable() {
        setIsDeselected()
    }
}
