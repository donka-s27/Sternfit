//
//  AppDelegate.h
//  SternFit
//
//  Created by MacOS on 12/9/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISidebarViewController.h"
#import "NearbyViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import "SideMenuViewController.h"
#import "FriendsViewController.h"
#import "SettingsViewController.h"
#import "TrainingViewController.h"
#import "ProfileViewController.h"
#import "StartGroupViewController.h"
#import "ChatViewController.h"
#import "SharePopupViewController.h"
#import "ExerciseViewController.h"
#import "Friend.h"
#import <CoreLocation/CLLocation.h>
#import "MHCustomTabBarController.h"
#import "SharedFittabViewController.h"
#import "FilterViewController.h"
#import "EditFittabViewController.h"
#import <CoreLocation/CLLocationManager.h>
#import "MBProgressHUD.h"
#import "CategoryViewController.h"
#import "OtherProfileViewController.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SupplementPlanViewController.h"
#import "DietPlanViewController.h"

static NSString * const APPTAG = @"SternFit";
static NSString * const APP_VERSION = @"1.0";
/*static NSString * const SERVER_ADDRESS = @"http://192.168.0.76/sternfit/public/";
static NSString * const IMAGE_URL = @"http://192.168.0.76/sternfit/uploads/";
static NSString * const EXERCISE_ICON_URL = @"http://192.168.0.76/sternfit/icons/";*/
static NSString * const SHARE_IMAGE_URL = @"http://www.sternfit.com/wang/share/";
static NSString * const SERVER_ADDRESS = @"http://www.sternfit.com/wang/public/";
static NSString * const IMAGE_URL = @"http://www.sternfit.com/wang/uploads/";
static NSString * const EXERCISE_ICON_URL = @"http://www.sternfit.com/wang/icons/";
static NSString * const REGISTER_USER = @"api/registeruser";
static NSString * const LOGIN_USER = @"api/loginuser";
static NSString * const UPDATE_USER = @"api/updateuser";
static NSString * const LOST_PASSWORD = @"api/lostpassword";
static NSString * const GET_USER_IMAGES = @"api/getimages";
static NSString * const UPLOAD_IMAGE = @"upload.php";
static NSString * const UPLOAD_AUDIO = @"audio_upload.php";
static NSString * const NEARBY_USERS = @"api/nearbyusers";
static NSString * const SEND_PUSH = @"api/sendpush";
static NSString * const GET_NOTIFICATIONS = @"api/getnotifications";
static NSString * const GET_FRIENDS = @"api/getfriends";
static NSString * const SHARE_FITTAB = @"api/sharefittab";
static NSString * const SHARED_FITTAB_USERS = @"api/getsharedfittabusers";
static NSString * const DELETE_NOTIFICATION = @"api/deletenotification";
static NSString * const DELETE_SHARED_FITTAB = @"api/deletesharedfittab";
static NSString * const CHANGE_USER_CREDENTIAL = @"api/changeusercredential";
static NSString * const GET_CATEGORIES = @"api/getcategories";
static NSString * const GET_EXERCISES = @"api/getexercises";
static NSString * const SEARCH_EXERCISES = @"api/searchexercises";
static NSString * const ADD_TRAININGPLAN = @"api/addtrainingplan";
static NSString * const GET_TRAININGPLANS = @"api/gettrainingplans";
static NSString * const DELETE_TRAININGPLAN = @"api/deletetrainingplan";
static NSString * const DELETE_FRIEND = @"api/deletefriend";
static NSString * const GET_PRIVATE_CHATROOM = @"api/getprivatechatroom";
static NSString * const GET_PRIVATE_MESSAGE = @"api/getprivatemessages";
static NSString * const SEND_MESSAGE = @"api/sendmessage";
static NSString * const ACCEPT_MESSAGE = @"api/acceptmessage";
static NSString * const CHECK_NOTIFICATION = @"api/checknotification";
static NSString * const CHECK_USER = @"api/checkuser";
static const int MESSAGE_SHOWN_LIMITS = 5;
static NSString * const CHANGE_PASSWORD = @"api/checkpassword";
static NSString * const ADD_DIETPLAN = @"api/adddietplan";
static NSString * const GET_DIETPLANS = @"api/getdietplans";
static NSString * const DELETE_DIETPLAN = @"api/deletedietplan";
static NSString * const SEARCH_DIETEXERCISES = @"api/searchdietexercises";
static NSString * const ADD_SUPPLEMENTPLAN = @"api/addsupplementplan";
static NSString * const GET_SUPPLEMENTPLANS = @"api/getsupplementplans";
static NSString * const DELETE_SUPPLEMENTPLAN = @"api/deletesupplementplan";
static NSString * const SEARCH_SUPPLEMENTEXERCISES = @"api/searchsupplementexercises";
static NSString * const CREATE_GROUP_CHAT = @"api/creategroupchat";

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) int tabIndex;
@property (nonatomic) int fromIndex;
//@property (nonatomic, strong) NSMutableDictionary *currentUser;
@property (nonatomic, strong) FilterViewController *rootView;
@property (nonatomic, strong) MHCustomTabBarController *tabBarController;
@property (nonatomic, strong) NSMutableArray *nearbyUsers;
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *sharedFittabUsers;
@property (nonatomic, strong) NSMutableArray *plans;
@property (nonatomic, strong) NSMutableArray *dietplans;
@property (nonatomic, strong) NSMutableArray *supplementplans;
@property (nonatomic, strong) NSMutableArray *editPlans;
@property (nonatomic, strong) NSMutableArray *groupChatIDs;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) Friend *selectOtherUser;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (assign, nonatomic) NSTimer *silenceTimer;
@property (nonatomic) int messageNum;
@property (nonatomic) int notificationNum;
@property (nonatomic, strong) UIImage *imageFittab;
@property (strong, nonatomic) FBSession *session;

- (void) refreshNotifications;

@end
