// Generated by Apple Swift version 5.6 (swiftlang-5.6.0.323.62 clang-1316.0.20.8)
#ifndef FLYCORE_SWIFT_H
#define FLYCORE_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if !defined(SWIFT_EXTERN)
# if defined(__cplusplus)
#  define SWIFT_EXTERN extern "C"
# else
#  define SWIFT_EXTERN extern
# endif
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import AVFoundation;
@import FlyCommon;
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="FlyCore",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif


SWIFT_CLASS("_TtC7FlyCore11ChatManager")
@interface ChatManager : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end













/// Delegate for Chat Server Connection
SWIFT_PROTOCOL("_TtP7FlyCore23ConnectionEventDelegate_")
@protocol ConnectionEventDelegate <NSObject>
/// Called when conneciton with chat server was made successfully
- (void)onConnected;
/// Called when chat server connection was disconnected
- (void)onDisconnected;
/// Called when chat server connection failed due to invalid credentials
- (void)onConnectionNotAuthorized;
@end


SWIFT_CLASS("_TtC7FlyCore14ContactManager")
@interface ContactManager : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end





SWIFT_CLASS("_TtC7FlyCore18ContactSyncManager")
@interface ContactSyncManager : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC7FlyCore17FlyCoreController")
@interface FlyCoreController : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end





@protocol MessageEventsDelegate;
@class NSString;
@class ChatMessage;

/// Handles sending chat messages of every type to user by proving public methods
SWIFT_CLASS("_TtC7FlyCore12FlyMessenger")
@interface FlyMessenger : NSObject
@property (nonatomic, strong) id <MessageEventsDelegate> _Nullable messageEventsDelegate;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) FlyMessenger * _Nonnull shared;)
+ (FlyMessenger * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
/// Encrypt the message content string
/// \param message text representation of a message
///
/// \param messageId id of the message
///
///
/// returns:
/// encrypted message content
+ (NSString * _Nullable)encryptDecryptMessageContentWithMessage:(NSString * _Nonnull)message messageId:(NSString * _Nonnull)messageId isEncrypt:(BOOL)isEncrypt SWIFT_WARN_UNUSED_RESULT;
/// Gives the chatmessages available for the  given jid
/// \param jid Jid of the User/Group/Broadcast
///
+ (NSArray<ChatMessage *> * _Nonnull)getMessagesOfJid:(NSString * _Nonnull)jid SWIFT_WARN_UNUSED_RESULT;
+ (NSArray<ChatMessage *> * _Nonnull)getAllMediaMessagesOfJid:(NSString * _Nonnull)jid SWIFT_WARN_UNUSED_RESULT;
/// Gives the chatmessages available for the  given jid
/// \param jid Jid of the User/Group/Broadcast
///
+ (NSArray<ChatMessage *> * _Nonnull)getMediaMessagesOfJid:(NSString * _Nonnull)jid SWIFT_WARN_UNUSED_RESULT;
/// Gives the list of chatmessages available for the  given message ids
/// \param messageIds message ids
///
+ (NSArray<ChatMessage *> * _Nonnull)getMessagesUsingIdsWithMessageIds:(NSArray<NSString *> * _Nonnull)messageIds SWIFT_WARN_UNUSED_RESULT;
/// Gives the Chatmessage object for a given message id
/// \param messageId id of a message
///
+ (ChatMessage * _Nullable)getMessageOfIdWithMessageId:(NSString * _Nonnull)messageId SWIFT_WARN_UNUSED_RESULT;
+ (void)uploadFileWithChatMessage:(ChatMessage * _Nonnull)chatMessage completion:(void (^ _Nullable)(BOOL))completion;
@end



@interface FlyMessenger (SWIFT_EXTENSION(FlyCore))
+ (void)cancelMediaUploadOrDownloadWithMessage:(ChatMessage * _Nonnull)message sendMessageListener:(void (^ _Nonnull)(BOOL))sendMessageListener;
+ (void)resetFailedMediaMessagesWithChatUserJid:(NSString * _Nonnull)chatUserJid;
@end


@interface FlyMessenger (SWIFT_EXTENSION(FlyCore))
+ (void)forwardMessageMediaAccessWithMessages:(NSArray<ChatMessage *> * _Nonnull)messages jidList:(NSArray<NSString *> * _Nonnull)jidList;
+ (void)composeForwardMessageWithMessageIds:(NSArray<NSString *> * _Nonnull)messageIds toJidList:(NSArray<NSString *> * _Nonnull)toJidList;
@end

@class AVCaptureFileOutput;
@class NSURL;
@class AVCaptureConnection;
@class AVAssetExportSession;

@interface FlyMessenger (SWIFT_EXTENSION(FlyCore)) <AVCaptureFileOutputRecordingDelegate>
- (void)captureOutput:(AVCaptureFileOutput * _Nonnull)output didFinishRecordingToOutputFileAtURL:(NSURL * _Nonnull)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> * _Nonnull)connections error:(NSError * _Nullable)error;
+ (void)compressVideoWithInputURL:(NSURL * _Nonnull)inputURL outputURL:(NSURL * _Nonnull)outputURL handler:(void (^ _Nonnull)(AVAssetExportSession * _Nullable))handler;
@end


@interface FlyMessenger (SWIFT_EXTENSION(FlyCore))
- (void)uploadingProgressWithPercent:(float)percent message:(ChatMessage * _Nonnull)message;
- (void)uploadSucceededWithMessage:(ChatMessage * _Nonnull)message response:(NSDictionary<NSString *, id> * _Nonnull)response;
- (void)uploadWithErrorWithError:(NSString * _Nonnull)error messageId:(NSString * _Nonnull)messageId;
- (void)downloadingProgressWithPercent:(float)percent message:(ChatMessage * _Nonnull)message;
- (void)downloadSucceededWithMessage:(ChatMessage * _Nonnull)message fileLocalPath:(NSString * _Nonnull)fileLocalPath fileName:(NSString * _Nonnull)fileName;
- (void)downloadWithErrorWithError:(NSString * _Nonnull)error messageId:(NSString * _Nonnull)messageId;
@end

@class ProfileDetails;

/// Delegate for group events
SWIFT_PROTOCOL("_TtP7FlyCore19GroupEventsDelegate_")
@protocol GroupEventsDelegate <NSObject>
/// Called whenever a user Created new Group receive Message
- (void)didAddNewMemeberToGroupWithGroupJid:(NSString * _Nonnull)groupJid newMemberJid:(NSString * _Nonnull)newMemberJid addedByMemberJid:(NSString * _Nonnull)addedByMemberJid;
/// called whenever a admin remove participant group model class
- (void)didRemoveMemberFromGroupWithGroupJid:(NSString * _Nonnull)groupJid removedMemberJid:(NSString * _Nonnull)removedMemberJid removedByMemberJid:(NSString * _Nonnull)removedByMemberJid;
/// called when a group Profile is fetched by you or by a member of the group
- (void)didFetchGroupProfileWithGroupJid:(NSString * _Nonnull)groupJid;
/// called whenever get group update message is received in user group
- (void)didUpdateGroupProfileWithGroupJid:(NSString * _Nonnull)groupJid;
/// called whenever get make Admin message is received in user group
- (void)didMakeMemberAsAdminWithGroupJid:(NSString * _Nonnull)groupJid newAdminMemberJid:(NSString * _Nonnull)newAdminMemberJid madeByMemberJid:(NSString * _Nonnull)madeByMemberJid;
/// Called whenever if a member removed from admin
- (void)didRemoveMemberFromAdminWithGroupJid:(NSString * _Nonnull)groupJid removedAdminMemberJid:(NSString * _Nonnull)removedAdminMemberJid removedByMemberJid:(NSString * _Nonnull)removedByMemberJid;
/// called   Whenever participant deleted from  the group
- (void)didDeleteGroupLocallyWithGroupJid:(NSString * _Nonnull)groupJid;
/// called  Whenever participant removed from  the group
- (void)didLeftFromGroupWithGroupJid:(NSString * _Nonnull)groupJid leftUserJid:(NSString * _Nonnull)leftUserJid;
- (void)didCreateGroupWithGroupJid:(NSString * _Nonnull)groupJid;
- (void)didFetchGroupsWithGroups:(NSArray<ProfileDetails *> * _Nonnull)groups;
- (void)didFetchGroupMembersWithGroupJid:(NSString * _Nonnull)groupJid;
- (void)didReceiveGroupNotificationMessageWithMessage:(ChatMessage * _Nonnull)message;
@end


SWIFT_CLASS("_TtC7FlyCore12GroupManager")
@interface GroupManager : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end




/// Message related event delegate for all chat related activities
SWIFT_PROTOCOL("_TtP7FlyCore21MessageEventsDelegate_")
@protocol MessageEventsDelegate <NSObject>
/// Called when the a new message is received in all types of chat
- (void)onMessageReceivedWithMessage:(ChatMessage * _Nonnull)message chatJid:(NSString * _Nonnull)chatJid;
/// Called when the receipts from the other users or server for a particular message sent by you or received by you is updated.
- (void)onMessageStatusUpdatedWithMessageId:(NSString * _Nonnull)messageId chatJid:(NSString * _Nonnull)chatJid status:(enum MessageStatus)status;
/// Called when upload or download of a media file is completed successfully
- (void)onMediaStatusUpdatedWithMessage:(ChatMessage * _Nonnull)message;
/// Called when upload or download of a media file is failed
- (void)onMediaStatusFailedWithError:(NSString * _Nonnull)error messageId:(NSString * _Nonnull)messageId;
/// Called when the progress of upload or download of a media file is changed
- (void)onMediaProgressChangedWithMessage:(ChatMessage * _Nonnull)message progressPercentage:(float)progressPercentage;
/// Called when the message/conversation deleted for the chat user.
- (void)onMessagesClearedOrDeletedWithMessageIds:(NSArray<NSString *> * _Nonnull)messageIds;
/// Called when the message/conversation deleted for everyone.
- (void)onMessagesDeletedforEveryoneWithMessageIds:(NSArray<NSString *> * _Nonnull)messageIds;
/// Called whenever a notification needed to be shown or updated or cancelled
- (void)showOrUpdateOrCancelNotification;
/// Called whenever messages are cleared
- (void)onMessagesClearedToJid:(NSString * _Nonnull)toJid;
/// Called on set or update or remove all favourite messages
- (void)setOrUpdateFavouriteWithMessageId:(NSString * _Nonnull)messageId favourite:(BOOL)favourite removeAllFavourite:(BOOL)removeAllFavourite;
/// Called when an incoming message is being translated
- (void)onMessageTranslatedWithMessage:(ChatMessage * _Nonnull)message jid:(NSString * _Nonnull)jid;
@end


/// Delegate for profile events
SWIFT_PROTOCOL("_TtP7FlyCore21ProfileEventsDelegate_")
@protocol ProfileEventsDelegate <NSObject>
/// Called whenever a user comes online by opening the app
- (void)userCameOnlineFor:(NSString * _Nonnull)jid;
/// Called whenever a user went to offline by closing the app
- (void)userWentOfflineFor:(NSString * _Nonnull)jid;
/// Called when the profile details of the requested profile jid is fetched from server successfully
- (void)userProfileFetchedFor:(NSString * _Nonnull)jid profileDetails:(ProfileDetails * _Nullable)profileDetails;
/// Called when the current user successfully updated their profile
- (void)myProfileUpdated;
/// Caleld when profiles of all the users/friends of current user is successfully fetched from server
- (void)usersProfilesFetched;
- (void)blockedThisUserWithJid:(NSString * _Nonnull)jid;
- (void)unblockedThisUserWithJid:(NSString * _Nonnull)jid;
- (void)usersIBlockedListFetchedWithJidList:(NSArray<NSString *> * _Nonnull)jidList;
- (void)usersBlockedMeListFetchedWithJidList:(NSArray<NSString *> * _Nonnull)jidList;
/// Called whenever a user updated their profile
- (void)userUpdatedTheirProfileFor:(NSString * _Nonnull)jid profileDetails:(ProfileDetails * _Nonnull)profileDetails;
/// Called when a user blocked the current logged in user
- (void)userBlockedMeWithJid:(NSString * _Nonnull)jid;
/// Called when a user unblocked the current logged in user
- (void)userUnBlockedMeWithJid:(NSString * _Nonnull)jid;
- (void)hideUserLastSeen;
- (void)getUserLastSeen;
- (void)userDeletedTheirProfileFor:(NSString * _Nonnull)jid profileDetails:(ProfileDetails * _Nonnull)profileDetails;
@end


SWIFT_CLASS("_TtC7FlyCore16WebLoginsManager")
@interface WebLoginsManager : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end





#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif
