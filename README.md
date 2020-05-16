# 📲  App Version  [![Build Status](https://travis-ci.com/amebalabs/AppVersion.svg?branch=master)](https://travis-ci.com/amebalabs/AppVersion) ![Swift Support](https://img.shields.io/badge/Swift-4.2-orange.svg) ![Documentation](https://github.com/amebalabs/AppVersion/blob/master/docs/badge.svg) [![Version](https://img.shields.io/cocoapods/v/AppVersion.swift.svg?style=flat)](http://cocoapods.org/pods/AppVersion.swift) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

### Don't let you users to get stuck on outdated version of your app.

- [x] Automatic update tracking using [**Semantic Versioning**](https://semver.org/)
- [x] Buil-in UI alerts
- [x] Rich set of delegate methods
- [x] [Fully documented ](https://appversion.ameba.co)
- [x] Good test coverage
- [x] [Small code base](https://github.com/amebalabs/AppVersion/blob/master/.cloc.report)
- [x] No external dependencies
- [x] Available through all major package managers: Cocoapods, Cartage and Swift Package Manager 

---

## Table of Contents
- [Screenshots](https://github.com/amebalabs/AppVersion/#screenshots)
- [Requirements](https://github.com/amebalabs/AppVersion/#requirements)
- [Installation](https://github.com/amebalabs/AppVersion/#nstallation)
- [Features](https://github.com/amebalabs/AppVersion/#features)
    - [Delegates](https://github.com/amebalabs/AppVersion/#delegates)
- [Example](https://github.com/amebalabs/AppVersion/#example)
- [Author](https://github.com/amebalabs/AppVersion/#author)

---

## Screenshots
### Update UI alerts

1. Skippable alert
2. Unskippable alert (Default)
3. Blocking alert

<p align="center">
  <img height="450" src="https://raw.githubusercontent.com/amebalabs/AppVersion/master/Images/UIAlert.png">
</p>

### Custom UILabel and UITableView footer
<p align="center">
  <img height="250" src="https://raw.githubusercontent.com/amebalabs/AppVersion/master/Images/UITableView_short.png">
</p>

- Four formatting options available(`AppInfo.VersionFormat`):
    - Short(version only): 1.0.0
    - Short with app name: AppVersion 1.0.0
    - Long(version +  build): 1.0.0(42)
    - Long with app name: 1.0.0(42)

## Requirements

- Swift 4.2
- Xcode 10 or greater
- iOS 11.0 or greater

## Installation

### CocoaPods

AppVersion is available through [CocoaPods](http://cocoapods.org). To install it add the following line to your Podfile:

```ruby
pod "AppVersion.swift"
```

### Carthage

If you’re using [Carthage](https://github.com/Carthage/Carthage),  add AppVersion to your `Cartfile`:

```
github "amebalabs/AppVersion"
```
Make sure to add `AppVersion.framework` to "Linked Frameworks and Libraries" and "copy-frameworks" Build Phases.

### Swift Package Manager
TBD


## Usage

Setup AppVersion in your AppDelegate.swift, code is self-explanatory:

```swift
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appVersion = AppVersion.shared
        appVersion.updateFrequency = 1 // I want to check for updates once a day
        appVersion.alertsEnabled = true // I want UI alerts, presenting update options
        appVersion.alertType = .skippable // I want UI alert to include "Skip" button
        appVersion.neverEnabled = true // I want UI alert to include "Never" butoon
        appVersion.alertPresentationStyle = .actionSheet // I want UI presented as an actionSheet
        appVersion.checkBeforeUpdatePresented = { // I want to present UI only if App Store version has more than 1 review and average rating is higher than 3
            return (appVersion.appStoreVersionInfo?.ratingsCount ?? 0) > 1
                && (appVersion.appStoreVersionInfo?.averageRating ?? 0) > 3
        }
        appVersion.regionCode = Locale.current.regionCode! // I want to check the update for current region only
        appVersion.run()
        return true
    }

```
### Delegates

Each meaningfull update tracking event provided as delegate (`AppVersionDelegate`). All delegates are optional, so you can implement only the one you need.
Delegates can be used even if UI Alerts are disabled, for example you can choose to implement your own UI.
Please refer to documentation for more details.

### UILabel and UITableView
#### Using Storyboard
Create AppVersion label in storyboard: Drag UILabel on your storyboard and set class to `AppVersionLabel`

<img height="180" src="https://raw.githubusercontent.com/amebalabs/AppVersion/master/Images/Storyboard_class.png">

After that set format name in Attributes Inpector:
<img height="130" src="https://raw.githubusercontent.com/amebalabs/AppVersion/master/Images/Storyboard_format.png">


####  Create  `AppVersionLabel` programatically:

```
let versionLabel = AppVersionLabel()
versionLabel.format = format
versionLabel.textAlignment = .center
versionLabel.textColor = .red
```  

#### Add version in UITableView footer:
```swift
tableView.addVersionFooter(with: .longWithName)
```
or
```
tableView.addVersionFooter(with: .long, alignment: .right, textColor: .lightGray, footerHeight: 22)
```
## Author
- Website: [Ameba](https://ameba.co) 
- Gtihub [@amebalabs](https://github.com/amebalabs/)
## License

AppVersion is available under the MIT license. See the LICENSE file for more info.
