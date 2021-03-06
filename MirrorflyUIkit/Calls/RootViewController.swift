//
//  RootViewController.swift
//  MirrorFlyiOS-SDK
//
//  Created by User on 16/07/21.
//

import Foundation
import UIKit
import FlyCall
import FlyCommon

@objc class RootViewController : NSObject {
    public static var sharedInstance = RootViewController()
    var callViewController : CallViewController?
    
    override init() {
        super.init()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RootViewController : CallManagerDelegate {
    
    func onUserSpeaking(userId: String, audioLevel: Int) {
        callViewController?.onUserSpeaking(userId: userId, audioLevel: audioLevel)
    }
    
    func onUserStoppedSpeaking(userId: String) {
        callViewController?.onUserStoppedSpeaking(userId: userId)

    }
    
    func getGroupName(_ groupId: String) {
        callViewController?.getGroupName(groupId)
    }
    
    func onVideoTrackAdded(userJid: String) {
        
    }
    
    func getDisplayName(IncomingUser :[String]) {
        DispatchQueue.main.async { [weak self] in
            self?.callViewController?.getDisplayName(IncomingUser: IncomingUser)
        }
        
    }
    
    func sendCallMessage( groupCallDetails : GroupCallDetails , users: [String], invitedUsers: [String]) {
        callViewController?.sendCallMessage(groupCallDetails: groupCallDetails, users: users, invitedUsers: invitedUsers)
    }
    
    func socketConnectionEstablished() {
        
    }
    
    func onCallStatusUpdated(callStatus: CALLSTATUS, userId: String) {
        print("#root onCallStatusUpdated \(callStatus.rawValue) userJid : \(userId)")
        
        
        DispatchQueue.main.async { [weak self] in
            if userId == FlyDefaults.myJid && (callStatus != .RECONNECTING && callStatus != .RECONNECTED) {
                return
            }
            
            switch callStatus {
            case .ATTENDED:
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                if  let navigationController = window?.rootViewController as? UINavigationController {
                    if CallManager.getCallDirection() == .Incoming &&  (navigationController.presentedViewController?.isKind(of: CallViewController.self) == false || navigationController.presentedViewController == nil){
                        if let callController = self?.callViewController {
                            callController.modalPresentationStyle = .overFullScreen
                            let navigationStack = UINavigationController(rootViewController: callController)
                            navigationStack.setNavigationBarHidden(true, animated: true)
                            navigationStack.modalPresentationStyle = .overFullScreen
                            window?.rootViewController?.present(navigationStack, animated: true, completion: {
                            })
                        }
                    }
                }
            case .CONNECTED:
                print("CALL CONNECTED")
            case .DISCONNECTED:
                print("CALL DISCONNECTED")
            case .ON_HOLD:
                print("")
            case .ON_RESUME:
                print("")
            case .USER_JOINED:
                print("")
            case .USER_LEFT:
                print("")
            case .INVITE_CALL_TIME_OUT:
                print("")
            case .CALL_TIME_OUT:
                print("")
            case .RECONNECTING:
                print("")
            case .RECONNECTED:
                print("")
            case .CALLING_10S:
                print("")
            case .CALLING_AFTER_10S:
                print("")
            case .CONNECTING:
                print("")
            case .RINGING:
                print("")
            case .CALLING:
                print("")
            case .ATTENDED:
                print("")
            }
            
            self?.callViewController?.onCallStatusUpdated(callStatus: callStatus, userId: userId)
        }
    }
    
    func onCallAction(callAction: CallAction, userId: String) {
        callViewController?.onCallAction(callAction: callAction, userId: userId)
    }
    
    func onLocalVideoTrackAdded(userId: String) {
        callViewController?.onLocalVideoTrackAdded(userId: userId)
    }
    
    func onMuteStatusUpdated(muteEvent: MuteEvent, userId: String) {
        callViewController?.onMuteStatusUpdated(muteEvent: muteEvent, userId: userId)
    }
    
}

extension RootViewController {
    
    public func initCallSDK(){
        try! CallManager.initCallSDK()
        if callViewController == nil {
            callViewController = UIStoryboard(name: "Call", bundle: nil).instantiateViewController(withIdentifier: "CallViewController") as? CallViewController
        }
        CallManager.setCallViewController(callViewController!)
        CallManager.setCallEventsDelegate(delegate:  RootViewController.sharedInstance)
        
    }
}

