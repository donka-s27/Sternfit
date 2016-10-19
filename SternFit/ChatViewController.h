//
//  ChatViewController.h
//  SternFit
//
//  Created by MacOS on 12/18/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@import AVFoundation;
@interface ChatViewController : UIViewController <UITextViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate>
{
    NSTimer *           mRecordingUpdateTimer;
    int                 recordedTimeInSec;
    int                 totalTime;
}

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UIView *viewMember;
@property (nonatomic, strong) IBOutlet UILabel *labelMember;
@property (nonatomic, strong) IBOutlet UITableView *chatTableView;
@property (nonatomic, strong) IBOutlet UIView *viewChat;
@property (nonatomic, strong) IBOutlet UIImageView *imgChatExtra;
@property (nonatomic, strong) IBOutlet UIImageView *imgChatEmoji;
@property (nonatomic, strong) IBOutlet UIView *viewExtra;
@property (nonatomic, strong) IBOutlet UITextView *txtSend;
@property (nonatomic, strong) IBOutlet UIScrollView *emojiScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIView *overlayView;
@property (nonatomic, strong) IBOutlet UIView *blackView;
@property (nonatomic, strong) IBOutlet UIImageView *imgExpand;
@property (nonatomic, strong) IBOutlet UIView *audioView;
@property (nonatomic, strong) IBOutlet UIImageView *imgAddUser;

@property (nonatomic, strong) IBOutlet UILabel *labelSlide;
@property (nonatomic, strong) IBOutlet UIImageView *imgVoiceMic;
@property (nonatomic, strong) IBOutlet UIImageView *imgVoiceLevel1;
@property (nonatomic, strong) IBOutlet UIImageView *imgVoiceLevel2;
@property (nonatomic, strong) IBOutlet UIImageView *imgVoiceLevel3;
@property (nonatomic, strong) IBOutlet UIImageView *imgVoiceLevel4;
@property (nonatomic, strong) IBOutlet UIImageView *imgVoiceLevel5;
@property (nonatomic, strong) IBOutlet UIButton *btnVoice;
@property (nonatomic, strong) IBOutlet UIButton *btnSaveToGallery;
@property (nonatomic, strong) IBOutlet UIButton *btnDone;

@property (nonatomic, strong) NSString *chatroomID;
@property (nonatomic) int isPrivateChat;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSString *memberNames;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic) BOOL pullToRefreshFlag;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic) BOOL                isplaying;
@property (nonatomic) float lowPassResults;

@property (nonatomic, strong) AVAudioPlayer *player;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnChatExtraClicked:(id)sender;
- (IBAction)btnChatSendClicked:(id)sender;
- (IBAction)btnChatEmojiClicked:(id)sender;
- (IBAction)btnAddUserClicked:(id)sender;
- (IBAction)btnExtraCameraClicked:(id)sender;
- (IBAction)btnExtraPhotoClicked:(id)sender;
- (IBAction)btnExtraVoiceClicked:(id)sender;
- (IBAction)btnExtraMapClicked:(id)sender;
- (void) refreshChat:(NSMutableDictionary *) chat;
- (IBAction)btnSaveToGalleryClicked:(id)sender;
- (IBAction)btnDoneClicked:(id)sender;

- (void) highlightImage:(UIImage*) image;
- (void) gotoMapController:(NSString*)location;
- (BOOL) playAudio:(NSString*) audiofile time:(int) time;
- (void) gotoProfilePage:(int) index;
- (void) gotoMyProfilePage;

@end
