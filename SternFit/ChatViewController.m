//
//  ChatViewController.m
//  SternFit
//
//  Created by MacOS on 12/18/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "ChatMineTableViewCell.h"
#import "SVPullToRefresh.h"
#import "MapViewController.h"

@interface ChatViewController () {
    CGSize iOSDeviceScreenSize;
    float keyboardHeight;
    int lines;
    int isKeyboardShowing;
    NSMutableArray *chats;
    //long secondsFromGMT;
    int messageLimit;
    UIImage *bmImage;
    int isRecording;
    NSTimer *levelTimer;
    
    NSUserDefaults *defaults;
    AppDelegate *appDelegate;
    BOOL isButtonShowing;
    int loadImageIndex;
}

//@property (nonatomic) UIImagePickerController *imagePickerController;
//@property (nonatomic) UIImagePickerController *imagePickerCameraController;

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loadImageIndex = -2;
    
    messageLimit = MESSAGE_SHOWN_LIMITS;
    
    defaults = [NSUserDefaults standardUserDefaults];
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    self.labelTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chatTableViewTap:)];
    tapView8.delegate = self;
    [self.chatTableView addGestureRecognizer:tapView8];
    
    UITapGestureRecognizer *tapView9 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(highlightViewTap:)];
    tapView9.delegate = self;
    [self.overlayView addGestureRecognizer:tapView9];
    
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc] init];
    [LongPress addTarget:self action:@selector(longPressDetected:)];
    LongPress.delegate = self;
    [self.btnVoice addGestureRecognizer:LongPress];
    
    iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    keyboardHeight = 216.0f;
    lines = 0;
    isKeyboardShowing = 0;
    //secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
    
    self.audioView.layer.cornerRadius = 15.0f;
    self.audioView.layer.masksToBounds = YES;
    self.audioView.hidden = YES;
    
    [self intiEmojiView];
    
    [self.btnSaveToGallery setTitle:NSLocalizedString(@"Save to Gallery", nil) forState:UIControlStateNormal];
    [self.btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated {
    self.isplaying = NO;
    
    
    appDelegate.currentViewController = self;
    
    self.pullToRefreshFlag = NO;
    self.btnVoice.hidden = YES;
    self.audioView.hidden = YES;
    [self.btnVoice setTitle:NSLocalizedString(@"Hold to talk", nil) forState:UIControlStateNormal];
    [self.imgChatExtra setImage:[UIImage imageNamed:@"chat_voice.png"]];
    
    self.chatTableView.frame = CGRectMake(0, 94, iOSDeviceScreenSize.width, iOSDeviceScreenSize.height - 94 - 45);
    self.viewExtra.frame = CGRectMake(0, iOSDeviceScreenSize.height, iOSDeviceScreenSize.width, 180);
    self.viewChat.frame = CGRectMake(0, iOSDeviceScreenSize.height - 45, iOSDeviceScreenSize.width, 45);
    
    if (self.isPrivateChat == 1) {
        self.imgAddUser.hidden = YES;
        CGRect frame = self.chatTableView.frame;
        frame.origin.y -= 30;
        frame.size.height += 30;
        self.chatTableView.frame = frame;
    }
    
    if (self.chatroomID == nil || [self.chatroomID isEqual:@""]) {
        
    } else {
        if (loadImageIndex == -2) {
            appDelegate.messageNum -= [[DBManager getSharedInstance] getLastUnreadMessageNum:self.chatroomID];
            
            chats = (NSMutableArray*) [[DBManager getSharedInstance] getMessages:self.chatroomID limit:messageLimit];
            
            NSString *lastupdatetime = [[DBManager getSharedInstance] getLastUpdateTime:self.chatroomID];
            
            [self.chatTableView reloadData];
            [self scrollToBottom];
            
            if ([lastupdatetime isEqual:@"0"])
                [self showProgress:YES];
            
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?cID=%@&lastupdatetime=%@&userID=%@", SERVER_ADDRESS, GET_PRIVATE_MESSAGE, self.chatroomID, lastupdatetime, [defaults objectForKey:@"userID"]]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       @try {
                                           if (data != nil) {
                                               NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                               
                                               if (result != nil && [result count] > 0) {
                                                   NSMutableDictionary *temp;
                                                   for (int i = 0; i < [result count]; i++) {
                                                       temp = (NSMutableDictionary*) [result objectAtIndex:i];
                                                       
                                                       long time = [[temp objectForKey:@"lastupdatetime"] longValue];// + secondsFromGMT;
                                                       NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:time];
                                                       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                       [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
                                                       NSString *date = [dateFormatter stringFromDate: currentTime];
                                                       
                                                       [[DBManager getSharedInstance] addMessage:[temp objectForKey:@"chatroomID"] senderID:[temp objectForKey:@"senderID"] message:[temp objectForKey:@"message"] type:[temp objectForKey:@"type"] lastupdatetime:[temp objectForKey:@"lastupdatetime"] created_at:date updated_at:date status:@"1"];
                                                       
                                                       appDelegate.messageNum++;
                                                   }
                                               }
                                           }
                                           
                                           chats = (NSMutableArray*) [[DBManager getSharedInstance] getMessages:self.chatroomID limit:messageLimit];
                                       }
                                       @catch (NSException *exception) {
                                           
                                       }
                                       @finally {
                                           if ([lastupdatetime isEqual:@"0"])
                                               [self showProgress:NO];
                                           
                                           [self.chatTableView reloadData];
                                           [self scrollToBottom];
                                       }
                                   }];
        }
    }
    
    if (appDelegate.messageNum < 0)
        appDelegate.messageNum = 0;
    
    //chats = [[NSMutableArray alloc] init];
    if (self.isPrivateChat == 1) {
        
        Friend *friend = (Friend*) [self.users objectAtIndex:0];
        
        self.labelTitle.text = friend.name;
        self.viewMember.hidden = YES;
    } else {
        self.labelTitle.text = self.roomName;
        self.labelMember.text = self.memberNames;
        self.labelMember.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0f];
        self.viewMember.hidden = NO;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.chatTableView addPullToRefreshWithActionHandler:^{
        weakSelf.pullToRefreshFlag = YES;
        [weakSelf loadMoreMessages];
    }];
}

- (void) loadMoreMessages {
    messageLimit += MESSAGE_SHOWN_LIMITS;
    chats = (NSMutableArray*) [[DBManager getSharedInstance] getMessages:self.chatroomID limit:messageLimit];
    
    [self.chatTableView reloadData];
    
    if (self.pullToRefreshFlag == YES) {
        self.pullToRefreshFlag = NO;
        [self.chatTableView.pullToRefreshView stopAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClicked:(id)sender {
    if (self.isplaying == YES) {
        [self.player stop];
        self.isplaying = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnChatExtraClicked:(id)sender {
    if (isKeyboardShowing == 2) {
        [self.txtSend becomeFirstResponder];
    } else {
        isKeyboardShowing = 2;
        [self.txtSend resignFirstResponder];
        
        CGRect containerFrame = self.viewChat.frame;
        containerFrame.origin.y=self.view.bounds.size.height - (keyboardHeight + containerFrame.size.height);
        
        CGRect tblFrame = self.chatTableView.frame;
        tblFrame.size.height=self.view.bounds.size.height-(keyboardHeight + containerFrame.size.height + tblFrame.origin.y);
        
        self.emojiScrollView.hidden = YES;
        self.pageControl.hidden = YES;
        
        CGRect exFrame = self.viewExtra.frame;
        exFrame.origin.y = self.view.bounds.size.height - keyboardHeight;
        exFrame.size.height = keyboardHeight;
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.viewChat.frame=containerFrame;
                             self.chatTableView.frame=tblFrame;
                             self.viewExtra.frame = exFrame;
                             [self scrollToBottom];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}
- (IBAction)btnChatSendClicked:(id)sender {
    
}
- (IBAction)btnChatEmojiClicked:(id)sender {
        isKeyboardShowing = 3;
        [self.txtSend resignFirstResponder];
        
        CGRect containerFrame = self.viewChat.frame;
        containerFrame.origin.y=self.view.bounds.size.height - (keyboardHeight + containerFrame.size.height);
        
        CGRect tblFrame = self.chatTableView.frame;
        tblFrame.size.height=self.view.bounds.size.height-(keyboardHeight + containerFrame.size.height + tblFrame.origin.y);
        
        [self.imgChatExtra setImage:[UIImage imageNamed:@"chat_voice.png"]];
        
        self.emojiScrollView.hidden = NO;
        self.pageControl.hidden = NO;
        //self.pageControl.hidden = NO;
        //[self.imgChatEmoji setImage:[UIImage imageNamed:@"chat_emoji.png"]];
        //self.txtSend.hidden = YES;
        
        CGRect exFrame = self.viewExtra.frame;
        exFrame.origin.y = self.view.bounds.size.height - keyboardHeight;
        exFrame.size.height = keyboardHeight;
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.viewChat.frame=containerFrame;
                             self.chatTableView.frame=tblFrame;
                             self.viewExtra.frame = exFrame;
                             [self scrollToBottom];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
}
- (IBAction)btnAddUserClicked:(id)sender {
    if (self.isPrivateChat == 1)
        return;
}
- (IBAction)btnExtraCameraClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Camera" message:@"Can't use this functionality!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    isKeyboardShowing = 0;

    UIImagePickerController *imagePickerCameraController = [[UIImagePickerController alloc] init];
    [imagePickerCameraController setSourceType: UIImagePickerControllerSourceTypeCamera];
    [imagePickerCameraController setDelegate: self];
    imagePickerCameraController.allowsEditing = YES;

    [self presentViewController:imagePickerCameraController animated: YES completion:nil];
}
- (IBAction)btnExtraPhotoClicked:(id)sender {
    isKeyboardShowing = 0;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerController setDelegate: self];
    imagePickerController.allowsEditing = YES;
    
    [self presentViewController:imagePickerController animated: YES completion:nil];
}
- (IBAction)btnExtraVoiceClicked:(id)sender {
    if (isKeyboardShowing == 4) {
        [self.txtSend becomeFirstResponder];
        return;
    }
    [self.txtSend resignFirstResponder];
    
    isKeyboardShowing = 4;
    [self.imgChatExtra setImage:[UIImage imageNamed:@"chat_keyboard.png"]];
    
    isRecording = 0;
    [self.btnVoice setTitle:NSLocalizedString(@"Hold to talk", nil) forState:UIControlStateNormal];
    self.btnVoice.hidden = NO;
}
- (IBAction)btnExtraMapClicked:(id)sender {
    //[self restoreDefaultPosition];
    
    NSDate *currentTime = [NSDate date];
    long time = (long) [currentTime timeIntervalSince1970];
    
    currentTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSString *date = [dateFormatter stringFromDate: currentTime];
    
    //time -= secondsFromGMT;
    
    
    NSString *location = [NSString stringWithFormat:@"%f,%f", appDelegate.currentLocation.coordinate.latitude, appDelegate.currentLocation.coordinate.longitude];
    
    // send push
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?senderID=%@&senderName=%@&chatroomID=%@&type=3&lastupdatetime=%ld&message=%@", SERVER_ADDRESS, SEND_MESSAGE, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], self.chatroomID, time, location]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           }];
    
    [[DBManager getSharedInstance] addMessage:self.chatroomID senderID:[defaults objectForKey:@"userID"] message:location type:@"3" lastupdatetime:[NSString stringWithFormat:@"%ld", time] created_at:date updated_at:date status:@"1"];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    [temp setObject:[defaults objectForKey:@"userID"] forKey:@"senderID"];
    [temp setObject:location forKey:@"message"];
    [temp setObject:@"3" forKey:@"type"];
    [temp setObject:[NSString stringWithFormat:@"%ld", time] forKey:@"lastupdatetime"];
    [temp setObject:date forKey:@"created_at"];
    
    if (chats == nil)
        chats = [[NSMutableArray alloc] init];
    [chats addObject:temp];
    
    messageLimit++;
    
    [self.chatTableView reloadData];
    [self scrollToBottom];
}

#pragma - mark TextField Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.txtSend.text isEqual:@""])
            return NO;
        
        NSDate *currentTime = [NSDate date];
        long time = (long) [currentTime timeIntervalSince1970];
        
        currentTime = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        NSString *date = [dateFormatter stringFromDate: currentTime];
        
        //time -= secondsFromGMT;
        
        
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?senderID=%@&senderName=%@&chatroomID=%@&type=0&lastupdatetime=%ld&message=%@", SERVER_ADDRESS, SEND_MESSAGE, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], self.chatroomID, time, [self.txtSend.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               }];
        [[DBManager getSharedInstance] addMessage:self.chatroomID senderID:[defaults objectForKey:@"userID"] message:self.txtSend.text type:@"0" lastupdatetime:[NSString stringWithFormat:@"%ld", time] created_at:date updated_at:date status:@"1"];
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        [temp setObject:[defaults objectForKey:@"userID"] forKey:@"senderID"];
        [temp setObject:self.txtSend.text forKey:@"message"];
        [temp setObject:@"0" forKey:@"type"];
        [temp setObject:[NSString stringWithFormat:@"%ld", time] forKey:@"lastupdatetime"];
        [temp setObject:date forKey:@"created_at"];
        
        if (chats == nil)
            chats = [[NSMutableArray alloc] init];
        [chats addObject:temp];
        
        messageLimit++;
        
        [self.chatTableView reloadData];
        [self scrollToBottom];
        
        self.txtSend.text = @"";
        lines = 0;
        [self changeViewChatHeight];
        
        return NO;
    }
    
    lines = (int)(textView.contentSize.height/textView.font.leading) - 1;
    [self changeViewChatHeight];
    
    return YES;
}

#pragma mark - KeyBord Methods

-(void) keyboardWillHide:(NSNotification *)note
{
    if (isKeyboardShowing == 2 || isKeyboardShowing == 3 || isKeyboardShowing == 4)
        return;
    isKeyboardShowing = 0;
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect containerFrame = self.viewChat.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    CGRect tblFrame=self.chatTableView.frame;
    tblFrame.size.height=self.view.bounds.size.height-(containerFrame.size.height+tblFrame.origin.y);
	
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	self.viewChat.frame = containerFrame;
	self.chatTableView.frame=tblFrame;
	// commit animations
	[UIView commitAnimations];
}


-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    isKeyboardShowing = 1;
    self.btnVoice.hidden = YES;
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    //for get keybord height
    //CGFloat kbHeight = [[note objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    keyboardHeight = keyboardBounds.size.height;
    
    CGRect containerFrame = self.viewChat.frame;
    containerFrame.origin.y=self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    CGRect tblFrame=self.chatTableView.frame;
    tblFrame.size.height=self.view.bounds.size.height-(keyboardBounds.size.height + containerFrame.size.height+tblFrame.origin.y);
    
    CGRect exFrame = self.viewExtra.frame;
    exFrame.origin.y = self.view.bounds.size.height;
    exFrame.size.height = keyboardHeight;
    
    [self.imgChatExtra setImage:[UIImage imageNamed:@"chat_voice.png"]];
    
    // animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	// set views with new info
	self.viewChat.frame=containerFrame;
    self.chatTableView.frame=tblFrame;
    self.viewExtra.frame = exFrame;
    [self scrollToBottom];
	// commit animations
	[UIView commitAnimations];
}

-(void)scrollToBottom{
    
    [self.chatTableView scrollRectToVisible:CGRectMake(0, self.chatTableView.contentSize.height - self.chatTableView.bounds.size.height, self.chatTableView.bounds.size.width, self.chatTableView.bounds.size.height) animated:YES];
    
}

- (void) changeViewChatHeight {
    if (lines < 5) {
        CGRect containerFrame = self.viewChat.frame;
        containerFrame.origin.y=self.view.bounds.size.height - (keyboardHeight + 45.0f + lines * 15.0f);
        if (isKeyboardShowing == 0)
            containerFrame.origin.y += keyboardHeight;
        containerFrame.size.height = 45.0f + lines * 15.0f;
        
        CGRect txtFrame = self.txtSend.frame;
        txtFrame.size.height = 37.0f + lines * 15.0f;
        
        CGRect tblFrame = self.chatTableView.frame;
        tblFrame.size.height = self.view.bounds.size.height - (keyboardHeight + 45.0f + tblFrame.origin.y + lines * 15.0f);
        if (isKeyboardShowing == 0)
            tblFrame.size.height += keyboardHeight;
        
        // set views with new info
        self.viewChat.frame=containerFrame;
        self.chatTableView.frame=tblFrame;
        self.txtSend.frame = txtFrame;
        [self scrollToBottom];
    }
}

- (IBAction)chatTableViewTap:(UITapGestureRecognizer*)recognizer {
    if (isKeyboardShowing == 0)
        return;
    [self.txtSend resignFirstResponder];
    
    [self restoreDefaultPosition];
}

- (void) restoreDefaultPosition {
    CGRect containerFrame = self.viewChat.frame;
    containerFrame.origin.y=self.view.bounds.size.height - containerFrame.size.height;
    
    CGRect tblFrame = self.chatTableView.frame;
    tblFrame.size.height=self.view.bounds.size.height- (containerFrame.size.height + tblFrame.origin.y);
    
    CGRect exFrame = self.viewExtra.frame;
    exFrame.origin.y = self.view.bounds.size.height;
    exFrame.size.height = keyboardHeight;
    
    [self.imgChatExtra setImage:[UIImage imageNamed:@"chat_voice.png"]];
    
    self.emojiScrollView.hidden = YES;
    self.btnVoice.hidden = YES;
    self.pageControl.hidden = YES;
    //self.pageControl.hidden = YES;
    //[self.imgChatEmoji setImage:[UIImage imageNamed:@"chat_emoji_normal.png"]];
    //self.txtSend.hidden = NO;
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.viewChat.frame=containerFrame;
                         self.chatTableView.frame=tblFrame;
                         self.viewExtra.frame = exFrame;
                         [self scrollToBottom];
                     }
                     completion:^(BOOL finished) {
                         isKeyboardShowing = 0;
                     }];
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (chats == nil)
        return 0;
    return [chats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ChatMineTableViewCell";
    
    ChatMineTableViewCell *cell = (ChatMineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatMineTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.parent = self;
    
    NSMutableDictionary *message = (NSMutableDictionary*) [chats objectAtIndex:indexPath.row];
    
    [cell setData:message];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height;
    ChatMineTableViewCell *cell=(ChatMineTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    height = [cell cellHeight];
    
    return height - 5;
}

- (void) refreshChat:(NSMutableDictionary *) chat {
    int time = [[chat objectForKey:@"lastupdatetime"] intValue];
    //time += secondsFromGMT;
    
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSString *date = [dateFormatter stringFromDate: currentTime];
    
    /*[[DBManager getSharedInstance] addMessage:self.chatroomID senderID:[chat objectForKey:@"userID"] message:[chat objectForKey:@"message"] type:@"0" lastupdatetime:[chat objectForKey:@"lastupdatetime"] created_at:date updated_at:date];*/
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    [temp setObject:[chat objectForKey:@"senderID"] forKey:@"senderID"];
    [temp setObject:[chat objectForKey:@"message"] forKey:@"message"];
    [temp setObject:[chat objectForKey:@"messagetype"] forKey:@"type"];
    [temp setObject:[chat objectForKey:@"lastupdatetime"] forKey:@"lastupdatetime"];
    [temp setObject:date forKey:@"created_at"];
    
    if (isRecording > 0) {
        if ([chats count] < 2)
            [chats insertObject:temp atIndex:0];
        else
            [chats insertObject:temp atIndex:([chats count] - 2)];
    } else
        [chats addObject:temp];
    messageLimit++;
    
    [self.chatTableView reloadData];
    [self scrollToBottom];
}

- (void) intiEmojiView {
    NSString *name;
    int pageIndex, row, col;
    for (int i = 1; i <= 30; i++) {
        if (i < 10) {
            name = [NSString stringWithFormat:@"0%d.png", i];
        } else {
            name = [NSString stringWithFormat:@"%d.png", i];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        
        pageIndex = (int) ((i - 1) / 12);
        row = (int) ((i - 1) % 12) / 4;
        col = (i - 1) % 4;
        
        imageView.frame = CGRectMake(320 * pageIndex + 20 + 80 * col, 20 + 60 * row, 40, 40);
        [imageView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emojiTap:)];
        tapView8.delegate = self;
        imageView.tag = i;
        [imageView addGestureRecognizer:tapView8];
        
        [self.emojiScrollView addSubview:imageView];
    }
    
    [self.emojiScrollView setContentSize:CGSizeMake(320 * 3, 180)];
    self.emojiScrollView.pagingEnabled = YES;
    self.emojiScrollView.showsHorizontalScrollIndicator = NO;
    self.emojiScrollView.delegate = self;
    [self.pageControl setNumberOfPages:3];
    CGRect frame = self.pageControl.frame;
    frame.origin.y = keyboardHeight - 30;
    self.pageControl.frame = frame;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int width = scrollView.frame.size.width;
    float xPos = scrollView.contentOffset.x + 10;
    self.pageControl.currentPage = (int)xPos/width;
}

- (IBAction)emojiTap:(UITapGestureRecognizer*)recognizer {
    int index = (int) recognizer.view.tag;
    
    NSString *emoji;
    if (index < 10) {
        emoji = [NSString stringWithFormat:@"0%d", index];
    } else {
        emoji = [NSString stringWithFormat:@"%d", index];
    }
    
    NSDate *currentTime = [NSDate date];
    long time = (long) [currentTime timeIntervalSince1970];
    
    currentTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSString *date = [dateFormatter stringFromDate: currentTime];
    
    //time -= secondsFromGMT;
    
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?senderID=%@&senderName=%@&chatroomID=%@&type=1&lastupdatetime=%ld&message=%@", SERVER_ADDRESS, SEND_MESSAGE, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], self.chatroomID, time, emoji]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           }];
    
    [[DBManager getSharedInstance] addMessage:self.chatroomID senderID:[defaults objectForKey:@"userID"] message:emoji type:@"1" lastupdatetime:[NSString stringWithFormat:@"%ld", time] created_at:date updated_at:date status:@"1"];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    [temp setObject:[defaults objectForKey:@"userID"] forKey:@"senderID"];
    [temp setObject:emoji forKey:@"message"];
    [temp setObject:@"1" forKey:@"type"];
    [temp setObject:[NSString stringWithFormat:@"%ld", time] forKey:@"lastupdatetime"];
    [temp setObject:date forKey:@"created_at"];
    
    if (chats == nil)
        chats = [[NSMutableArray alloc] init];
    [chats addObject:temp];
    
    messageLimit++;
    
    [self.chatTableView reloadData];
    [self scrollToBottom];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    loadImageIndex = -1;
    [picker dismissViewControllerAnimated:YES completion:nil];
    bmImage = [self imageWithImage:info[UIImagePickerControllerEditedImage] scaledToSize:CGSizeMake(150, 150)];

    [self uploadImage:bmImage];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)uploadImage:(UIImage*)image
{
    NSDate *currentTime = [NSDate date];
    long time = (long) [currentTime timeIntervalSince1970];
    
    currentTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSString *date = [dateFormatter stringFromDate: currentTime];
    
    //time -= secondsFromGMT;
    
    NSString *filename = [NSString stringWithFormat:@"%ld.jpg", time];
    
    // save image on local
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", self.chatroomID, filename]];
    [UIImagePNGRepresentation(bmImage) writeToFile:filePath atomically:YES];
    
    // upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, UPLOAD_IMAGE];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    // username
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"username\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@", self.chatroomID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // filename
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"filename\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[filename dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // image data
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
  
    //NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];

    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    [temp setObject:image forKey:@"image"];
    [temp setObject:@"10" forKey:@"type"];
    [temp setObject:[defaults objectForKey:@"userID"] forKey:@"senderID"];
    [temp setObject:date forKey:@"created_at"];
    
    if (chats == nil)
        chats = [[NSMutableArray alloc] init];
    [chats addObject:temp];
    
    loadImageIndex = (int)[chats count] - 1;
    
    [self.chatTableView reloadData];
    [self scrollToBottom];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (loadImageIndex < [chats count])
                                   [chats removeObjectAtIndex:loadImageIndex];
                               
                               // send push
                               NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?senderID=%@&senderName=%@&chatroomID=%@&type=2&message=%@&lastupdatetime=%ld", SERVER_ADDRESS, SEND_MESSAGE, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], self.chatroomID, [NSString stringWithFormat:@"%@_%@", self.chatroomID, filename], time]];
                               
                               NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
                               
                               [request setHTTPMethod:@"POST"];
                               
                               [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                                
                                                      completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                          
                                                          [[DBManager getSharedInstance] addMessage:self.chatroomID senderID:[defaults objectForKey:@"userID"] message:[NSString stringWithFormat:@"%@_%@", self.chatroomID, filename] type:@"2" lastupdatetime:[NSString stringWithFormat:@"%ld", time] created_at:date updated_at:date status:@"1"];
                                                          NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                                                          [temp setObject:[defaults objectForKey:@"userID"] forKey:@"senderID"];
                                                          [temp setObject:[NSString stringWithFormat:@"%@_%@", self.chatroomID, filename] forKey:@"message"];
                                                          [temp setObject:@"2" forKey:@"type"];
                                                          [temp setObject:[NSString stringWithFormat:@"%ld", time] forKey:@"lastupdatetime"];
                                                          [temp setObject:date forKey:@"created_at"];
                                                          
                                                          [chats insertObject:temp atIndex:loadImageIndex];
                                                          
                                                          messageLimit++;
                                                          
                                                          [self.chatTableView reloadData];
                                                          [self scrollToBottom];
                                                      }];
                           }];
}

- (void) highlightImage:(UIImage*) image {
    if (image == nil)
        return;
    self.audioView.hidden = YES;
    self.imgExpand.hidden = NO;
    isButtonShowing = NO;
    self.btnSaveToGallery.hidden = YES;
    self.btnDone.hidden = YES;
    
    [self.imgExpand setImage:image];
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.blackView.hidden = NO;
                         self.overlayView.hidden = NO;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)highlightViewTap:(UITapGestureRecognizer*)recognizer {
    if (isButtonShowing == NO) {
        isButtonShowing = YES;
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.btnSaveToGallery.hidden = NO;
                             self.btnDone.hidden = NO;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        isButtonShowing = NO;
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.btnSaveToGallery.hidden = YES;
                             self.btnDone.hidden = YES;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void) gotoMapController:(NSString*)location {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *controller = (MapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    controller.strLocation = location;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL) playAudio:(NSString*) audiofile time:(int)time {
    if (audiofile == nil)
        return NO;
    
    if (self.isplaying == YES) {
        [self.player stop];
        self.isplaying = NO;
        return NO;
    }
    
    recordedTimeInSec = time;
    totalTime = time;

    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:audiofile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:audiofile];
    
    if ([fileManager fileExistsAtPath:txtPath] == YES) {
        // create a session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        // create player
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:documentsURL error:nil];
        self.player.delegate = self;
        [self.player prepareToPlay];
        [self.player play];
        
        self.isplaying = YES;
    } else {
        [self showProgress:YES];
        NSString *fileURL = [NSString stringWithFormat:@"%@%@", IMAGE_URL, audiofile];
        [NSURLConnection sendAsynchronousRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:fileURL]]
         
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^( NSURLResponse *response, NSData *data, NSError *error ) {
                                   if(error)
                                   {
                                       
                                   }
                                   else
                                   {
                                       @try {
                                           NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                                                NSUserDomainMask, YES);
                                           
                                           NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:audiofile];
                                           
                                           if ([data writeToFile:filePath atomically:YES]) {
                                               NSLog(@"Success");
                                               AVAudioSession *session = [AVAudioSession sharedInstance];
                                               [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                                               
                                               // create player
                                               self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:documentsURL error:nil];
                                               self.player.delegate = self;
                                               [self.player prepareToPlay];
                                               [self.player play];
                                               
                                               self.isplaying = YES;
                                           } else {
                                               NSLog(@"Fail");
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           
                                       }
                                       @finally {
                                           [self showProgress:NO];
                                       }
                                       
                                   }
                               }];
    }
    return YES;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    // done playing
    self.isplaying = NO;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.blackView.hidden = YES;
                         self.overlayView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    self.isplaying = NO;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.blackView.hidden = YES;
                         self.overlayView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    // something didn't play so well
}

- (void)onPlayingTimer:(id)sender
{
    recordedTimeInSec--;
    
}

- (void) changeVoiceLevel:(float) volume {
    if (volume <= 0.2f) {
        self.imgVoiceLevel1.hidden = NO;
        self.imgVoiceLevel2.hidden = YES;
        self.imgVoiceLevel3.hidden = YES;
        self.imgVoiceLevel4.hidden = YES;
        self.imgVoiceLevel5.hidden = YES;
    } else if (volume <= 0.4f) {
        self.imgVoiceLevel1.hidden = NO;
        self.imgVoiceLevel2.hidden = NO;
        self.imgVoiceLevel3.hidden = YES;
        self.imgVoiceLevel4.hidden = YES;
        self.imgVoiceLevel5.hidden = YES;
    } else if (volume <= 0.6f) {
        self.imgVoiceLevel1.hidden = NO;
        self.imgVoiceLevel2.hidden = NO;
        self.imgVoiceLevel3.hidden = NO;
        self.imgVoiceLevel4.hidden = YES;
        self.imgVoiceLevel5.hidden = YES;
    } else if (volume <= 0.8f) {
        self.imgVoiceLevel1.hidden = NO;
        self.imgVoiceLevel2.hidden = NO;
        self.imgVoiceLevel3.hidden = NO;
        self.imgVoiceLevel4.hidden = NO;
        self.imgVoiceLevel5.hidden = YES;
    } else {
        self.imgVoiceLevel1.hidden = NO;
        self.imgVoiceLevel2.hidden = NO;
        self.imgVoiceLevel3.hidden = NO;
        self.imgVoiceLevel4.hidden = NO;
        self.imgVoiceLevel5.hidden = NO;
    }
    
}

- (IBAction)longPressDetected:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.isplaying == YES) {
            [self.player stop];
            self.isplaying = NO;
        }
        
        // Long press detected, start the timer
        [self.btnVoice setTitle:NSLocalizedString(@"Release to send", nil) forState:UIControlStateNormal];
        isRecording = 1;
        
        // create a URL to an audio asset
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        documentsURL = [documentsURL URLByAppendingPathComponent:@"audiofile.mp4"];
        
        // create an audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        if (session.inputAvailable) {
            
            NSLog(@"We can start recording!");
            [session setActive:YES error:nil];
            
        } else {
            NSLog(@"We don't have a mic to record with :-(");
        }
        
        // settings for our recorder
        NSDictionary *audioSettings = @{AVFormatIDKey: [NSNumber numberWithInt:kAudioFormatMPEG4AAC],
                                        AVSampleRateKey: [NSNumber numberWithFloat:22050],
                                        AVNumberOfChannelsKey: [NSNumber numberWithInt:1]
                                        };
        
        // create an audio recorder with the above URL
        self.recorder = [[AVAudioRecorder alloc]initWithURL:documentsURL settings:audioSettings error:nil];
        self.recorder.delegate = self;
        [self.recorder prepareToRecord];
        [self.recorder setMeteringEnabled:YES];
        [self.recorder record];
        
        recordedTimeInSec = 0;
        mRecordingUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onRecordingTimer:) userInfo:nil repeats:YES];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(onVolumeCallback:) userInfo:nil repeats:YES];
        
        [self changeVoiceLevel:0.0f];
        self.labelSlide.text = NSLocalizedString(@"Slide up to cancel", nil);
        self.labelSlide.textColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.audioView.hidden = NO;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"changed");
        CGPoint coords = [recognizer locationInView:recognizer.view];
        if (coords.y < 0) {
            [self.btnVoice setTitle:NSLocalizedString(@"Release to cancel", nil) forState:UIControlStateNormal];
            self.labelSlide.text = NSLocalizedString(@"Release to cancel", nil);
            self.labelSlide.textColor = [UIColor redColor];
            isRecording = 2;
        } else {
            [self.btnVoice setTitle:NSLocalizedString(@"Release to send", nil) forState:UIControlStateNormal];
            self.labelSlide.text = NSLocalizedString(@"Slide up to cancel", nil);
            self.labelSlide.textColor = [UIColor whiteColor];
            isRecording = 1;
        }
    }
    else
    {
        if (recognizer.state == UIGestureRecognizerStateCancelled
            || recognizer.state == UIGestureRecognizerStateFailed
            || recognizer.state == UIGestureRecognizerStateEnded)
        {
            // Long press ended, stop the timer
            [self.recorder stop];
            
            [mRecordingUpdateTimer invalidate];
            mRecordingUpdateTimer = nil;
            [levelTimer invalidate];
            levelTimer = nil;
            [self.btnVoice setTitle:NSLocalizedString(@"Hold to talk", nil) forState:UIControlStateNormal];
            
            if (recordedTimeInSec < 1) {
                isRecording = 0;
                self.labelSlide.text = NSLocalizedString(@"Short to record", nil);
                self.labelSlide.textColor = [UIColor redColor];
                
                [UIView animateWithDuration:2.0f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     self.audioView.hidden = YES;
                                 }
                                 completion:^(BOOL finished) {
                                     
                                 }];
            } else {
                [UIView animateWithDuration:0.5f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     self.audioView.hidden = YES;
                                 }
                                 completion:^(BOOL finished) {
                                     
                                 }];
                if (isRecording == 2) {
                    [chats removeLastObject];
                    [self.chatTableView reloadData];
                    
                    [self scrollToBottom];
                    return;
                }
                
                isRecording = 0;
                
                [chats removeLastObject];
                
                NSDate *currentTime = [NSDate date];
                long time = (long) [currentTime timeIntervalSince1970];
                
                currentTime = [NSDate dateWithTimeIntervalSince1970:time];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
                NSString *date = [dateFormatter stringFromDate: currentTime];
                
                //time -= secondsFromGMT;
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%ld.mp4", self.chatroomID, time]];
                
                if ([fileManager fileExistsAtPath:txtPath] == NO) {
                    NSString *resourcePath = [documentsDirectory stringByAppendingPathComponent:@"audiofile.mp4"];
                    [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
                }
                
                
                NSString *audiofile = [NSString stringWithFormat:@"%@_%ld.mp4,%d", self.chatroomID, time, recordedTimeInSec];
                
                // send push
                
                NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?senderID=%@&senderName=%@&chatroomID=%@&type=4&lastupdatetime=%ld&message=%@", SERVER_ADDRESS, SEND_MESSAGE, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], self.chatroomID, time, audiofile]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
                
                [request setHTTPMethod:@"POST"];
                
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                 
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       }];
                
                [[DBManager getSharedInstance] addMessage:self.chatroomID senderID:[defaults objectForKey:@"userID"] message:audiofile type:@"4" lastupdatetime:[NSString stringWithFormat:@"%ld", time] created_at:date updated_at:date status:@"1"];
                
                // upload image
                NSData *file1Data = [[NSData alloc] initWithContentsOfURL:self.recorder.url];
                NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, UPLOAD_AUDIO];
                
                request = [[NSMutableURLRequest alloc] init];
                [request setURL:[NSURL URLWithString:urlString]];
                [request setHTTPMethod:@"POST"];
                
                NSString *boundary = @"---------------------------14737809831466499882746641449";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                
                NSMutableData *body = [NSMutableData data];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", [NSString stringWithFormat:@"%@_%ld.mp4", self.chatroomID, time]]] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:file1Data]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [request setHTTPBody:body];
                
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                 
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       }];
                
                NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                [temp setObject:[defaults objectForKey:@"userID"] forKey:@"senderID"];
                [temp setObject:audiofile forKey:@"message"];
                [temp setObject:@"4" forKey:@"type"];
                [temp setObject:[NSString stringWithFormat:@"%ld", time] forKey:@"lastupdatetime"];
                [temp setObject:date forKey:@"created_at"];
                
                if (chats == nil)
                    chats = [[NSMutableArray alloc] init];
                [chats addObject:temp];
                
                [self.chatTableView reloadData];
                
                [self scrollToBottom];
            }
        }
    }
    
}

- (void)onRecordingTimer:(id)sender
{
    recordedTimeInSec ++;
    if (recordedTimeInSec == 1) {
        
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        [temp setObject:[defaults objectForKey:@"userID"] forKey:@"senderID"];
        [temp setObject:@"" forKey:@"message"];
        [temp setObject:@"5" forKey:@"type"];
        [temp setObject:@"" forKey:@"lastupdatetime"];
        [temp setObject:@"" forKey:@"created_at"];
        
        [chats addObject:temp];
        
        [self.chatTableView reloadData];
        
        [self scrollToBottom];
    }
}

- (void) onVolumeCallback:(id)sender {
    [self.recorder updateMeters];
    
    const double ALPHA = 0.1;
    double peakPowerForChannel = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    self.lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * self.lowPassResults;
    
    [self changeVoiceLevel:self.lowPassResults];
}

- (void) gotoProfilePage:(int)index {
    
    Friend *friend;
    for (int i = 0; i < [appDelegate.friends count]; i++) {
        friend = (Friend*) [appDelegate.friends objectAtIndex:i];
        if (friend.userId == index) {
            appDelegate.selectOtherUser = friend;
            //UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //OtherProfileViewController *controller = (OtherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OtherProfileViewController"];
            //[self.navigationController pushViewController:controller animated:YES];
            
            [self moveToOtherProfile];
            return;
        }
    }
}

- (void) moveToOtherProfile {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherProfileViewController *controller = (OtherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OtherProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) gotoMyProfilePage {
    
    Friend *friend = [[Friend alloc] init];
    friend.image = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"profile"]];
    friend.photo1 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo1"]];
    friend.photo2 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo2"]];
    friend.photo3 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo3"]];
    friend.photo4 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo4"]];
    friend.photo5 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo5"]];
    friend.userId = [[defaults objectForKey:@"userID"] intValue];
    friend.name = [defaults objectForKey:@"name"];
    friend.message = [defaults objectForKey:@"quote"];
    if ([[defaults objectForKey:@"visibleMode"] intValue] == 2)
        friend.status = 0;
    else
        friend.status = 1;
    // friend.chatroomID = [defaults objectForKey:@"chatroomID"];
    //friend.lastupdatetime = (int)([[defaults objectForKey:@"lastupdatetime"] intValue] / 60);
    if ([[defaults objectForKey:@"gender"] isEqual:@"male"])
        friend.gender = YES;
    else
        friend.gender = NO;
    
    
    friend.age = [[defaults objectForKey:@"age"] intValue];
    
    friend.height = [[defaults objectForKey:@"height"] intValue];
    friend.weight = [[defaults objectForKey:@"weight"] intValue];
    
    
    appDelegate.selectOtherUser = friend;
    /*UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherProfileViewController *controller = (OtherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OtherProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];*/
    [self moveToOtherProfile];
}

- (IBAction)btnSaveToGalleryClicked:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imgExpand.image, nil, nil, nil);
    isButtonShowing = NO;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.blackView.hidden = YES;
                         self.overlayView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)btnDoneClicked:(id)sender {
    isButtonShowing = NO;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.blackView.hidden = YES;
                         self.overlayView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
@end
