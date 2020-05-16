//
//  UITableView+AppVersion.swift
//  AppVersion
//

import UIKit

public extension UITableView {

    /**
     Adds version label into the table footer.
     Will replace current table footer.

     - Parameters:
        - format: Version format
        - alignment: Label text alignment in the footer, default: Center
        - textColor: Label text color, default: UIColor.gray
        - footerHeight: Label text color, default: 20
     */
    func addVersionFooter(with format: AppInfo.VersionFormat,
                                 alignment: NSTextAlignment = .center,
                                 textColor: UIColor = UIColor.gray,
                                 footerHeight: CGFloat = 22) {
        let versionLabel = AppVersionLabel()
        versionLabel.format = format
        versionLabel.textAlignment = alignment
        versionLabel.textColor = textColor

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: footerHeight))
        footerView.addAtCenter(view: versionLabel)
        tableFooterView = footerView
    }
}
