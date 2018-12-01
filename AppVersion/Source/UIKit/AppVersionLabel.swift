//
//  AppVersionLabel.swift
//  AppVersion
//

import UIKit

/// UILabel which is autopopulated with information about installed version of the app.
/// Can be used programmatically or in Storyboards
@IBDesignable
open class AppVersionLabel: UILabel {
    /// Desired version format
    public var format: AppInfo.VersionFormat = .long {
        didSet {
            updateText()
        }
    }

    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'format' instead.")
    @IBInspectable var formatName: String? {
        willSet {
            if let newFormat = AppInfo.VersionFormat(rawValue: newValue ?? "") {
                format = newFormat
            }
        }
    }
    /// Init UILable with frame
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    /// Init UILable with from coder
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        adjustsFontSizeToFitWidth = true
        numberOfLines = 0
        sizeToFit()
        updateText()
    }

    private func updateText() {
        text = AppInfo.version(with: format)
    }
}
