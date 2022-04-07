//
//  ParticipantCell.swift
//  MirrorflyUIkit
//
//  Created by John on 23/11/21.
//

import UIKit
import FlyCommon
import SDWebImage

class ParticipantCell: UITableViewCell {

    @IBOutlet weak var removeIcon: UIButton?
    @IBOutlet weak var emptyView: UIView?
    @IBOutlet weak var removeButton: UIImageView?
    @IBOutlet weak var checkBoxImageView: UIImageView?
    @IBOutlet weak var statusUILabel: UILabel?
    @IBOutlet weak var nameUILabel: UILabel?
    @IBOutlet weak var contactImageView: UIImageView?
    @IBOutlet weak var receiverMessageTypeImageView: UIImageView?
    @IBOutlet weak var receiverMessageTypeView: UIView?
    @IBOutlet weak var statusImage: UIImageView?
    @IBOutlet weak var statusView: UIView?
    @IBOutlet weak var statusImageCons: NSLayoutConstraint?
    @IBOutlet weak var statusViewTralingCons: NSLayoutConstraint?
    @IBOutlet weak var receivedMessageTrailingCons: NSLayoutConstraint?
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
    }
    
    func initialSetUp() {
        contactImageView?.makeRounded()
    }
    
    // MARK: SetContactInformation
    func hideLastMessageContentInfo() {
        statusImage?.isHidden = true
        receiverMessageTypeView?.isHidden = true
        statusImageCons?.constant = 0
        receivedMessageTrailingCons?.constant = 0
        statusViewTralingCons?.constant = 0
    }
    
    func showLastMessageContentInfo() {
        receivedMessageTrailingCons?.constant = 5
        statusViewTralingCons?.constant = 5
        statusImageCons?.constant = 7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setImage(imageURL: String, name: String, color: UIColor) {
       let urlString = "\(Environment.sandboxImage.baseURL)\(media)/\(imageURL)?mf=\(FlyDefaults.authtoken)"
        let url = URL(string: urlString)
        contactImageView?.sd_setImage(with: url, placeholderImage: getPlaceholder(name: name, color: color))
    }
    
    func getPlaceholder(name: String , color: UIColor)->UIImage {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let ipimage = IPImage(text: trimmedName, radius: Double(contactImageView?.frame.size.height ?? 0.0), font: UIFont.font32px_appBold(), textColor: nil, color: color)
        let placeholder = ipimage.generateInitialImage()
        return placeholder ?? #imageLiteral(resourceName: "ic_profile_placeholder")
    }
    
    func setTextColorWhileSearch(searchText: String,profileDetail: ProfileDetails) {
        let tempSearchText = searchText.trim()
        if let range = profileDetail.name.range(of: tempSearchText, options: [.caseInsensitive, .diacriticInsensitive]) {
            let convertedRange = NSRange(range, in: profileDetail.name)
            let attributedString = NSMutableAttributedString(string: profileDetail.name.capitalized)
            attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], range: convertedRange)
            nameUILabel?.attributedText = attributedString
        } else {
            nameUILabel?.text = profileDetail.name.capitalized
            nameUILabel?.textColor = Color.userNameTextColor
        }
    }
    
    func setImage(imageURL: String, name: String, color: UIColor , recentChat : RecentChat) {
        let urlString = "\(Environment.sandboxImage.baseURL + "" + media + "/" + imageURL + "?mf=" + "" + FlyDefaults.authtoken)"
        let url = URL(string: urlString)
        var placeHolder = UIImage()
        if recentChat.profileType == .groupChat {
            placeHolder = UIImage(named: ImageConstant.ic_group_small_placeholder)!
            
        } else {
            placeHolder = getPlaceholder(name: name, color: color)
        }
        contactImageView?.sd_setImage(with: url, placeholderImage: placeHolder)
    }
    
    func setRecentChatDetails(recentChat: RecentChat,color: UIColor) {
        nameUILabel?.text = recentChat.profileName
        statusUILabel?.text = recentChat.lastMessageContent
        setImage(imageURL: recentChat.profileImage ?? "", name: recentChat.profileName, color: color)
        checkBoxImageView?.image = recentChat.isSelected ?  UIImage(named: ImageConstant.ic_checked) : UIImage(named: ImageConstant.ic_check_box)
        setImage(imageURL: recentChat.profileImage ?? "", name: recentChat.profileName, color: color , recentChat: recentChat)
        removeButton?.isHidden = true
        statusUILabel?.isHidden = false
        statusImage?.isHidden = (recentChat.isLastMessageSentByMe == true) ? false : true
        statusView?.isHidden = (recentChat.isLastMessageSentByMe == true) ? false : true
        receiverMessageTypeView?.isHidden = false
        
            switch recentChat.lastMessageType {
            case .text:
                receiverMessageTypeView?.isHidden = true
            case .contact:
                receiverMessageTypeImageView?.image = UIImage(named: ImageConstant.ic_rccontact)
            case .image:
                receiverMessageTypeImageView?.image = UIImage(named: ImageConstant.ic_rcimage)
            case .location:
                receiverMessageTypeImageView?.image = UIImage(named: ImageConstant.ic_rclocation)
            case .audio:
                receiverMessageTypeImageView?.image = UIImage(named: ImageConstant.ic_rcaudio)
            case .video:
                receiverMessageTypeImageView?.image = UIImage(named: ImageConstant.ic_rcvideo)
            case .document:
                receiverMessageTypeImageView?.image = UIImage(named: ImageConstant.ic_rcdocument)
            default:
                receiverMessageTypeView?.isHidden = true
            }
    
        switch recentChat.isLastMessageSentByMe {
        case true:
            // show hide sent and received msg status
            switch recentChat.lastMessageStatus {
            case .notAcknowledged:
                statusImage?.image = UIImage(named: ImageConstant.ic_hour)
                break
            case .sent:
                switch recentChat.lastMessageType {
                case .video, .audio, .image,.text,.contact:
                    statusImage?.image = UIImage(named: ImageConstant.ic_hour)
                default:
                    statusImage?.image = UIImage(named: ImageConstant.ic_sent)
                }
                break
            case .acknowledged:
                statusImage?.image = UIImage(named: ImageConstant.ic_sent)
                break
            case .delivered:
                statusImage?.image = UIImage(named: ImageConstant.ic_delivered)
                break
            case .seen:
                statusImage?.image = UIImage(named: ImageConstant.ic_seen)
                break
            case .received:
                statusImage?.image = UIImage(named: ImageConstant.ic_delivered)
                break
            default:
                statusImage?.image = UIImage(named: ImageConstant.ic_hour)
                break
            }
            case false:
            statusImage?.isHidden = true
        }
    }
}