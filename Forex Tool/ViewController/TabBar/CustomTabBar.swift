//
//  CustomTabBar.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 25/09/2021.
//

import Foundation
import UIKit
class CustomTabBar: UIView {
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        layer.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9647058824, blue: 1, alpha: 1).cgColor
        // Khởi tạo từng tab bar item
        for index in 0 ..< menuItems.count{
            let itemWidth = frame.width / CGFloat(menuItems.count)
            let offsetX = itemWidth * CGFloat(index)
            
            let itemView = createTabItem(item: menuItems[index])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = index
            
            addSubview(itemView)
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: heightAnchor),
                itemView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offsetX),
                itemView.topAnchor.constraint(equalTo: topAnchor),
            ])
        }
        setNeedsLayout()
        layoutIfNeeded()
        activateTab(tab: 2)
    }
    
    func createTabItem(item: TabItem) -> UIView {
        let tabBarItem = UIView()
        tabBarItem.layer.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9647058824, blue: 1, alpha: 1).cgColor
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        
//        let itemTitleLabel = UILabel()
//        itemTitleLabel.text = item.displayTitle
//        itemTitleLabel.textAlignment = .center
//        itemTitleLabel.font = UIFont(name: "Roboto-Regular", size: 10)
//        itemTitleLabel.textColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.2117647059, alpha: 1)
//        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        itemTitleLabel.clipsToBounds = true
        
        let itemImageView = UIImageView()
        itemImageView.image = item.icon.withRenderingMode(.automatic)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.clipsToBounds = true
        
//        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.addSubview(itemImageView)
        
        // Auto layout cho item title và item icon
        NSLayoutConstraint.activate([
            itemImageView.heightAnchor.constraint(equalToConstant: 30),
            itemImageView.widthAnchor.constraint(equalToConstant: 30),
            itemImageView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemImageView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 8),
            itemImageView.leadingAnchor.constraint(equalTo: tabBarItem.leadingAnchor, constant: 20),
//            itemTitleLabel.heightAnchor.constraint(equalToConstant: 13),
//            itemTitleLabel.widthAnchor.constraint(equalTo: tabBarItem.widthAnchor),
//            itemTitleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 4),
        ])
        // Thêm tap gesture recognizer để handle tap event
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        return tabBarItem
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        //
        Constant.isInTabBarControll = true
        switchTab(from: activeItem, to: sender.view!.tag)
    }
    
    func switchTab(from: Int, to: Int) {
        deactivateTab(tab: from)
        activateTab(tab: to)
    }
    
    func activateTab(tab: Int) {
        let tabToActivate = subviews[tab]
        let borderWidth = tabToActivate.frame.width - 20
        let borderLayer = CALayer()
        borderLayer.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.2117647059, alpha: 1)
        borderLayer.name = "Active Border"
        borderLayer.frame = CGRect(x: 10, y: 0, width: borderWidth, height: 2)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8,
                           delay: 0.0,
                           options: [.curveEaseIn, .allowUserInteraction]) {
                tabToActivate.layer.addSublayer(borderLayer)
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            } completion: { _ in
                self.itemTapped?(tab)
                self.activeItem = tab
            }
        }
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = subviews[tab]
        let layerToRemove = inactiveTab.layer.sublayers?.filter({ $0.name == "Active Border" })
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction]) {
                layerToRemove?.forEach({ $0.removeFromSuperlayer() })
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            } completion: { _ in
                
            }
        }
    }
}

