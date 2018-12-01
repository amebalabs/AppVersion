//
//  UIView+Extension.swift
//  AppVersion
//

import UIKit

extension UIView {

    func addAtCenter(view: UIView) {
        addAtCenter(view: view, heightMultiplier: 1, widthMultiplier: 0.95)
    }

    func addAtCenter(view: UIView, heightMultiplier: CGFloat, widthMultiplier: CGFloat) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: self,
                                              attribute: .height, multiplier: heightMultiplier, constant: 0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self,
                                              attribute: .width, multiplier: widthMultiplier, constant: 0))

    }
}
