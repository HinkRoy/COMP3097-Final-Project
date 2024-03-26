//
//  TagCollectionViewCell.swift
//  TaskMaster
//
//  Created by Heng Zhou 2024/3/20.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 15),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -15)
        ])
    }
    
    func configure(with tag: String, isSelected: Bool) {
            textLabel.text = tag
            let defaultBackgroundColor = UIColor(hex: "#ccddfd")!
            let defaultTextColor = UIColor.black
            let selectedBackgroundColor = UIColor(hex: "#3478f7")!
            let selectedTextColor = UIColor.white
            
            backgroundColor = isSelected ? selectedBackgroundColor : defaultBackgroundColor
            textLabel.textColor = isSelected ? selectedTextColor : defaultTextColor
            
            layer.cornerRadius = 8
        }
}

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        
        return nil
    }
}
