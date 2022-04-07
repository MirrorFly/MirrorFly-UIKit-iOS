//
//  ImageReceiverCell.swift
//  MirrorflyUIkit
//
//  Created by User on 03/09/21.
//

import UIKit
import FlyCommon
import FlyCore
import NicoProgress
import GoogleMaps
import MapKit

class ReceiverImageCell: BaseTableViewCell {
    @IBOutlet weak var captionBotom: NSLayoutConstraint?
    @IBOutlet weak var captionTop: NSLayoutConstraint?
    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var progressBar: NicoProgressBar?
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var reecivedTime: UILabel!
    @IBOutlet weak var fwdView: UIView!
    @IBOutlet weak var fwdIcon: UIButton!
    @IBOutlet weak var filseSize: UILabel!
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var downloadImg: UIImageView!
    @IBOutlet weak var downoadButton: UIButton!
    @IBOutlet weak var progrssButton: UIButton!
    @IBOutlet weak var timeTopCons: NSLayoutConstraint?
    var imageGeasture: UITapGestureRecognizer!
    @IBOutlet weak var groupSenderNameLabel: GroupReceivedMessageHeader!
    @IBOutlet weak var bubbleImageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var overlayImage: UIImageView!
    
    @IBOutlet weak var replyView: UIView?
    @IBOutlet weak var messageTypeIconView: UIView?
    @IBOutlet weak var messageTypeIcon: UIImageView?
    @IBOutlet weak var chatMapView: GMSMapView?
    @IBOutlet weak var mediaImageView: UIImageView?
    @IBOutlet weak var replyTextLabel: UILabel?
    @IBOutlet weak var replyUserLabel: UILabel?
    @IBOutlet weak var bubbleImageView: UIImageView?
    @IBOutlet weak var receivedTimeBottomcons: NSLayoutConstraint?
    @IBOutlet weak var senderNameContainer: UIView!
    
    // Forward Outlet
    @IBOutlet weak var forwardImageView: UIImageView?
    @IBOutlet weak var forwardView: UIView?
    @IBOutlet weak var forwardLeadingCons: NSLayoutConstraint?
    @IBOutlet weak var bubbleImageLeadingCons: NSLayoutConstraint?
    @IBOutlet weak var forwardButton: UIButton?
    var composeMailDelegate: ShowMailComposeDelegate?
    
    var message : ChatMessage?
    var refreshDelegate: RefreshBubbleImageViewDelegate? = nil
    var selectedForwardMessage: [SelectedForwardMessage]? = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
    imageGeasture = UITapGestureRecognizer()
    imageContainer.addGestureRecognizer(imageGeasture)
    progressBar?.transition(to: .determinate(percentage: 30.0))
    caption.font = UIFont.font12px_appRegular()
    filseSize.font = UIFont.font12px_appSemibold()
    progressView.layer.cornerRadius = 5
    cellView.roundCorners(corners: [.topLeft, .bottomLeft, .topRight], radius: 5.0)
        imageContainer.layer.cornerRadius = 5.0
        imageContainer.clipsToBounds = true
        progressBar?.primaryColor = .white
        progressBar?.secondaryColor = .clear
        cellView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSelectView(selected: Bool) {
         if selected {
         self.backgroundColor = .lightGray
         }else {
             self.backgroundColor = .clear
         }
    }
    
    @IBAction func canceldownload(_ sender: Any) {
        downloadView.isHidden = false
    }
    
    func getCellFor(_ message: ChatMessage?, at indexPath: IndexPath?,isShowForwardView: Bool?) -> ReceiverImageCell? {
        currentIndexPath = indexPath
        chatMapView?.isHidden = true
        
        // Forward view elements and its data
        forwardView?.isHidden = (isShowForwardView == true && message?.mediaChatMessage?.mediaDownloadStatus == .downloaded) ? false : true
        forwardView?.makeCircleView(borderColor: Color.forwardCircleBorderColor.cgColor, borderWidth: 1.5)
        forwardLeadingCons?.constant = (isShowForwardView == true && message?.mediaChatMessage?.mediaDownloadStatus == .downloaded) ? 20 : 0
        bubbleImageLeadingCons?.constant = (isShowForwardView == true && message?.mediaChatMessage?.mediaDownloadStatus == .downloaded) ? 10 : 0
        forwardButton?.isHidden = (isShowForwardView == true && message?.mediaChatMessage?.mediaDownloadStatus == .downloaded) ? false : true
    
        if selectedForwardMessage?.filter({$0.chatMessage.messageId == message?.messageId}).first?.isSelected == true {
            forwardImageView?.image = UIImage(named: "forwardSelected")
            forwardImageView?.isHidden = false
            forwardView?.makeCircleView(borderColor: Color.forwardCircleBorderColor.cgColor, borderWidth: 0.0)
        } else {
            forwardImageView?.image = UIImage(named: "")
            forwardImageView?.isHidden = true
            forwardView?.makeCircleView(borderColor: Color.forwardCircleBorderColor.cgColor, borderWidth: 1.5)
        }
        
        if  (message?.mediaChatMessage?.mediaDownloadStatus == .not_downloaded || message?.mediaChatMessage?.mediaDownloadStatus == .downloading || message?.messageStatus == .notAcknowledged || isShowForwardView == true) {
            fwdView?.isHidden = true
            fwdIcon?.isHidden = true
        } else {
            fwdView?.isHidden = false
            fwdIcon?.isHidden = false
        }
        
        // Reply view elements and its data
       if(message?.isReplyMessage == true) {
            replyView?.isHidden = false
           let getReplymessage =  message?.replyParentChatMessage?.messageTextContent
           let replyMessage = FlyMessenger.getMessageOfId(messageId: message?.replyParentChatMessage?.messageId ?? "")
           messageTypeIconView?.isHidden = true
           replyTextLabel?.text = getReplymessage
           if replyMessage?.mediaChatMessage != nil {
               messageTypeIconView?.isHidden = false
               switch replyMessage?.mediaChatMessage?.messageType {
               case .image:
                   messageTypeIcon?.image = UIImage(named: (message?.isMessageSentByMe ?? false) ? "senderCamera" : "receiverCamera")
                   if let thumImage = replyMessage?.mediaChatMessage?.mediaThumbImage {
                       let converter = ImageConverter()
                       let image =  converter.base64ToImage(thumImage)
                       mediaImageView?.image = image
                       mediaImageView?.isHidden = false
                       replyTextLabel?.text = (!(replyMessage?.mediaChatMessage?.mediaCaptionText.isEmpty ?? false)) ? replyMessage?.mediaChatMessage?.mediaCaptionText : "Photo"
                   }
               case .audio:
                   messageTypeIcon?.image = UIImage(named: (message?.isMessageSentByMe ?? false) ? "senderAudio" : "receiverAudio")
                   let duration = Int(replyMessage?.mediaChatMessage?.mediaDuration ?? 0)
                   replyTextLabel?.text = (!(replyMessage?.mediaChatMessage?.mediaCaptionText.isEmpty ?? false)) ? replyMessage?.mediaChatMessage?.mediaCaptionText : replyMessage?.mediaChatMessage?.messageType.rawValue.capitalized.appending(" (\(duration.msToSeconds.minuteSecondMS))")
               case .video:
                   messageTypeIcon?.image = UIImage(named: (message?.isMessageSentByMe ?? false) ? "senderVideo" : "video")
                   if let thumImage = replyMessage?.mediaChatMessage?.mediaThumbImage {
                       let converter = ImageConverter()
                       let image =  converter.base64ToImage(thumImage)
                       mediaImageView?.image = image
                       mediaImageView?.isHidden = false
                       replyTextLabel?.text = (!(replyMessage?.mediaChatMessage?.mediaCaptionText.isEmpty ?? false)) ? replyMessage?.mediaChatMessage?.mediaCaptionText : replyMessage?.mediaChatMessage?.messageType.rawValue.capitalized
                   }
               default:
                   messageTypeIconView?.isHidden = true
               }
               
           } else if replyMessage?.locationChatMessage != nil {
               chatMapView?.isHidden = false
               replyTextLabel?.text = "Location"
               messageTypeIcon?.image = UIImage(named: (message?.isMessageSentByMe ?? false) ? "map" : "receivedMap")
               guard let latitude = replyMessage?.locationChatMessage?.latitude else {
                   return nil
               }
               guard let longitude = replyMessage?.locationChatMessage?.longitude  else {
                   return nil
               }
               
               chatMapView?.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0, bearing: 360.0, viewingAngle: 15.0)
      
               DispatchQueue.main.async
               { [self] in
                   // 2. Perform UI Operations.
                   let position = CLLocationCoordinate2DMake(latitude,longitude)
                   let marker = GMSMarker(position: position)
                   marker.map = chatMapView
               }
               messageTypeIconView?.isHidden = false
           } else if replyMessage?.contactChatMessage != nil {
               replyTextLabel?.text = "Contact"
               messageTypeIcon?.image = UIImage(named: (message?.isMessageSentByMe ?? false) ? "senderContact" : "receiverContact")
               messageTypeIconView?.isHidden = false
           } else {
               mediaImageView?.isHidden = true
           }
        if(replyMessage?.isMessageSentByMe ?? false) {
            replyUserLabel?.text = you.localized
        }
        else {
            replyUserLabel?.text = replyMessage?.senderUserName
        }
    }
        else {
            replyView?.isHidden = true
        }
        
        //Bubble View
        ChatUtils.setReceiverBubbleBackground(imageView: bubbleImageView)
        
        self.message = message
        
        if let senderName = message?.senderUserName, message?.messageChatType == .groupChat {
            print("ReceiverImageCell senderName \(senderName)")
            groupSenderNameLabel.text = senderName
        } else {
            groupSenderNameLabel.isHidden = true
            senderNameContainer.isHidden = true
        }
        if let captionTxt = message?.mediaChatMessage?.mediaCaptionText, captionTxt != "" {
            caption.attributedText = processTextMessage(message: message?.mediaChatMessage?.mediaCaptionText ?? "", uiLabel: caption)
            receivedTimeBottomcons?.constant = 0
            timeTopCons?.isActive = true
            captionTop?.constant = 7
            captionBotom?.constant = 0
            timeTopCons?.constant = 0
            overlayImage.isHidden = true
        }else{
            timeTopCons?.isActive = false
            timeTopCons?.constant = 0
            captionTop?.constant = 0
            captionBotom?.constant = 0
            receivedTimeBottomcons?.constant = 0
            caption.text = ""
            overlayImage.isHidden = false
        }
        if message?.mediaChatMessage?.mediaDownloadStatus == .not_downloaded {
            if let thumbImage = message?.mediaChatMessage?.mediaThumbImage {
                let converter = ImageConverter()
                var image =  converter.base64ToImage(thumbImage)
                image = image?.sd_blurredImage(withRadius: 5.0)
                imageContainer.image = image
                progressBar?.isHidden = true
                progressView.isHidden = true
                progrssButton.isHidden = true
                downoadButton.isHidden = false
                downloadView.isHidden = false
                if let fileSiz = message?.mediaChatMessage?.mediaFileSize{
                    filseSize.text = "\(fileSiz.byteSize)"
                } else {
                    filseSize.text = ""
                }
                close.isHidden = true
       }
    } else if message?.mediaChatMessage?.mediaDownloadStatus == .downloading {
            if let thumbImage = message?.mediaChatMessage?.mediaThumbImage {
            let converter = ImageConverter()
            var image =  converter.base64ToImage(thumbImage)
            image = image?.sd_blurredImage(withRadius: 5.0)
                imageContainer.image = image
            }
            progressBar?.isHidden = false
            progressView.isHidden = false
            progrssButton.isHidden = false
            downoadButton.isHidden = true
            downloadView.isHidden = true
            filseSize.text = ""
            close.isHidden = false
    } else if message?.mediaChatMessage?.mediaDownloadStatus == .downloaded {
            if let localPath = message?.mediaChatMessage?.mediaFileName {
                let directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let folderPath: URL = directoryURL.appendingPathComponent("FlyMedia/Image", isDirectory: true)
                let fileURL: URL = folderPath.appendingPathComponent(localPath)
                if FileManager.default.fileExists(atPath: fileURL.relativePath) {
                    let data = NSData(contentsOf: fileURL)
                    let image = UIImage(data: data! as Data)
                    imageContainer.image = image
                }
            } else {
            if let thumbImage = message?.mediaChatMessage?.mediaThumbImage {
            let converter = ImageConverter()
            var image =  converter.base64ToImage(thumbImage)
            image = image?.sd_blurredImage(withRadius: 5.0)
                imageContainer.image = image
            }
            }
            progressView.isHidden = true
            progrssButton.isHidden = true
            downoadButton.isHidden = true
            downloadView.isHidden = true
            filseSize.text = ""
            close.isHidden = true
        } else {
            if let thumbImage = message?.mediaChatMessage?.mediaThumbImage {
                let converter = ImageConverter()
                var image =  converter.base64ToImage(thumbImage)
                image = image?.sd_blurredImage(withRadius: 5.0)
                imageContainer.image = image
            }
                downloadView.isHidden = false
                downoadButton.isHidden = false
                progrssButton.isHidden = true
                progressBar?.isHidden = true
                progressView.isHidden = true
                if let fileSiz = message?.mediaChatMessage?.mediaFileSize{
                filseSize.text = "\(fileSiz)"
                }else {
                    filseSize.text = ""
                }
                close.isHidden = true
        }
        guard let timeStamp =  message?.messageSentTime else {
            return self
        }
        self.reecivedTime.text = Utility.convertTime(timeStamp: timeStamp)
   
        return self
    }
    
    func processTextMessage(message : String, uiLabel : UILabel) -> NSMutableAttributedString? {
        var attributedString : NSMutableAttributedString?
        
        if !message.isEmpty {
            attributedString = NSMutableAttributedString(string: message)
            let gestureRecognizer = UITapGestureRecognizer()
            let textArray = message.trim().split(separator: " ")
            
            
            for (index, tempText) in textArray.enumerated() {
                print("processTextMessage index \(index) item \(tempText)")
                print("processTextMessage tempText \(tempText)")
                 let text = String(tempText).trim()
                 if text.isNumber && text.count >= 6 && text.count <= 13 {
                     print("processTextMessage isNumber \(tempText)")
                     let numberRange = (message as NSString).range(of: text)
                     attributedString?.addAttribute(NSAttributedString.Key.underlineStyle,value: NSUnderlineStyle.single.rawValue, range: numberRange)
                     gestureRecognizer.view?.isUserInteractionEnabled = true
                     gestureRecognizer.addTarget(self, action: #selector(didTapTextLabel(sender:)))
                     uiLabel.addGestureRecognizer(gestureRecognizer)
                 } else if text.trim().verifyisUrl(urlString: text) {
                     print("processTextMessage text.isURL \(tempText)")
                     let urlRange = (message as NSString).range(of: text)
                     attributedString?.addAttribute(NSAttributedString.Key.underlineStyle,value: NSUnderlineStyle.single.rawValue, range: urlRange)
                     gestureRecognizer.view?.isUserInteractionEnabled = true
                     gestureRecognizer.addTarget(self, action: #selector(didTapTextLabel(sender:)))
                     uiLabel.addGestureRecognizer(gestureRecognizer)
                 } else if text.trim().isValidEmail(email: text) {
                     let urlRange = (message as NSString).range(of: text)
                     attributedString?.addAttribute(NSAttributedString.Key.underlineStyle,value: NSUnderlineStyle.single.rawValue, range: urlRange)
                     gestureRecognizer.view?.isUserInteractionEnabled = true
                     gestureRecognizer.addTarget(self, action: #selector(didTapTextLabel(sender:)))
                     uiLabel.addGestureRecognizer(gestureRecognizer)
                 }
                 
                 print("processTextMessage After else \(tempText)")
            }
            
            for tempText in textArray {
                let text = String(tempText)
                if text.isNumber && text.count >= 6 && text.count <= 13 {
                    let numberRange = (message as NSString).range(of: text)
                    attributedString?.addAttribute(NSAttributedString.Key.underlineStyle,value: NSUnderlineStyle.single.rawValue, range: numberRange)
                    gestureRecognizer.view?.isUserInteractionEnabled = true
                    gestureRecognizer.addTarget(self, action: #selector(didTapTextLabel(sender:)))
                    uiLabel.addGestureRecognizer(gestureRecognizer)
                } else if text.verifyisUrl(urlString: text) {
                    if text.isURL {
                        let urlRange = (message as NSString).range(of: text)
                        attributedString?.addAttribute(NSAttributedString.Key.underlineStyle,value: NSUnderlineStyle.single.rawValue, range: urlRange)
                        gestureRecognizer.view?.isUserInteractionEnabled = true
                        gestureRecognizer.addTarget(self, action: #selector(didTapTextLabel(sender:)))
                        uiLabel.addGestureRecognizer(gestureRecognizer)
                    }
                } else if text.isValidEmail(email: text) {
                    let urlRange = (message as NSString).range(of: text)
                    attributedString?.addAttribute(NSAttributedString.Key.underlineStyle,value: NSUnderlineStyle.single.rawValue, range: urlRange)
                    gestureRecognizer.view?.isUserInteractionEnabled = true
                    gestureRecognizer.addTarget(self, action: #selector(didTapTextLabel(sender:)))
                    uiLabel.addGestureRecognizer(gestureRecognizer)
                }
            }
        } else {
            attributedString = NSMutableAttributedString(string: message)
        }
        return attributedString
    }
    
    @objc func didTapTextLabel(sender: UITapGestureRecognizer){
        if let textUILabel = sender.view as? UILabel {
            let tempName = (textUILabel).text ?? ""
            if !tempName.isEmpty {
                let textArray = tempName.split(separator: " ")
                for tempText in textArray {
                    let text = String(tempText)
                    if text.isNumber && text.count >= 6 && text.count <= 13 {
                        let textRange = (tempName as NSString).range(of: text)
                        if(sender.didTapAttributedTextInLabel(label: textUILabel, inRange: textRange)) {
                            print("didTapTextLabel isNumber \(text)")
                            AppUtils.shared.callPhoneNumber(phoneNumber: text)
                            break
                        }
                        
                    } else if text.verifyisUrl(urlString: text) {
                        let textRange = (tempName as NSString).range(of: text)
                        if(sender.didTapAttributedTextInLabel(label: textUILabel, inRange: textRange)) {
                            print("didTapTextLabel isURL \(text)")
                            AppUtils.shared.openURLInBrowser(urlString: text)
                            break
                        }
                    } else if text.isValidEmail(email: text) {
                        composeMailDelegate?.showMailComposer(mail: text)
                    }
                }
            }
        }
        
    }
}