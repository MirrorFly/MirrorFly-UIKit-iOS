//
//  Color.swift
//  commonDemo
//
//  Created by User on 13/08/21.
//

import Foundation
import UIKit

//Chage Colour in Asset Colour set
enum Color {

    static let backgroundColor = UIColor(named: "BackgroundColor")
    static let primaryAppColor = UIColor(named: "PrimaryAppColor")
    static let secondaryAppColor = UIColor(named: "SecondaryAppColor")
    static let secondaryTextColor = UIColor(named: "SecondaryTextColor")
    static let primaryTextColor = UIColor(named: "PrimaryTextColor")
    static let primaryTextColor1 = UIColor(named: "PrimaryTextColor1")
    static let primaryTextColor2 = UIColor(named: "PrimaryTextColor2")
    static let primaryTextColor3 = UIColor(named: "PrimaryTextColor3")
    static let appPrimaryColor = UIColor(named: "AppPrimaryColor")
    static let progressColor = UIColor(named: "progressColor")
    static let borderColor = UIColor(named:  "BorderColor")
    static let imageSelection = UIColor(named: "imageSelection")
    static let captionTxt = UIColor(named: "captionTxt")
    static let navigationColor = UIColor(named:  "NavigationColor")
    static let cellSelectionColor = UIColor(named:  "cellSelection")
    static let recentChatSelectionColor = UIColor(hex: "E2E2E2")
    static let chatDateHeaderBackground = UIColor(named: "ChatDateHeaderBackground")
    static let chatDateHeaderText = UIColor(named: "ChatDateHeaderText")
    static let shadowColor = UIColor(named: "shadow")
    static let groupIconBackgroundGray = UIColor(named: "ImageBackgroundGray")
    static let color1 = UIColor(named: "color1")
    static let color2 = UIColor(named: "color2")
    static let color3 = UIColor(named: "color3")
    static let color4 = UIColor(named: "color4")
    static let color5 = UIColor(named: "color5")
    static let color6 = UIColor(named: "color6")
    static let color7 = UIColor(named: "color7")
    static let color8 = UIColor(named: "color8")
    static let color9 = UIColor(named: "color9")
    static let color10 = UIColor(named: "color10")
    static let color11 = UIColor(named: "color11")
    static let color12 = UIColor(named: "color12")
    static let color13 = UIColor(named: "color13")
    static let color14 = UIColor(named: "color14")
    static let color15 = UIColor(named: "color15")
    static let color16 = UIColor(named: "color16")
    static let color17 = UIColor(named: "color17")
    static let color18 = UIColor(named: "color18")
    static let color19 = UIColor(named: "color19")
    static let color20 = UIColor(named: "color20")
    static let recentChatTextColor = UIColor.init(hex: "767676")
    static let userNameTextColor = UIColor.init(hex: "181818")
    static let recentChatDateTimeColor = UIColor.init(hex: "959595")
    static let recentChaTimeBlueColor = UIColor.init(hex: "4879F9")
    static let recentChatHeaderSectionColor = UIColor.init(hex: "F2F2F2")
    static let userStatusTextColor = UIColor.init(hex: "767676")
    static let previewInnerBgColor = UIColor.init(hex: "D0D8EB")
    static let previewContentBgColor = UIColor.init(hex: "E2E8F7")
    static let senderBubbleColor = UIColor(named: "sender_bubble_color")
    static let receiverBubbleColor = UIColor(named: "receiver_bubble_color")
    static let forwardCircleBorderColor = UIColor(hex: "C4C4C6")
    static let previewCaptionTextColor = UIColor(named: "previewCaptionColor")
    static let leaveGroupTextColor = UIColor(named: "leaveGroup")
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
