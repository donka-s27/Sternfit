//
//  SettingsViewController.m
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "ChangeUsernameViewController.h"
#import "MHCustomTabBarController.h"

@interface SettingsViewController () {
    BOOL isNotification;
    BOOL isUnitSystem;
    NSString *password;
    UIImage *bmImage;
    int visibleMode;
    BOOL isUsernameChanged;
    BOOL isPasswordChanged;
    NSMutableArray *validValues;
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
}

//@property (nonatomic) UIImagePickerController *imagePickerController;
//@property (nonatomic) UIImagePickerController *imagePickerCameraController;
@property (nonatomic) UIActionSheet *actionSheet;

@end

@implementation SettingsViewController

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
    self.labelPageTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
    
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Do any additional setup after loading the view.
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.imgProfile.layer.borderColor = borderColor.CGColor;
    self.imgProfile.layer.borderWidth = 3.0f;
    self.imgProfile.layer.cornerRadius = 43.0f;
    self.imgProfile.layer.masksToBounds = YES;
    
    
    if ([[defaults objectForKey:@"gender"] isEqual:@"male"]) {
        UIColor *borderColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
        self.imgProfile.layer.borderColor = borderColor.CGColor;
    } else {
        UIColor *borderColor = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
        self.imgProfile.layer.borderColor = borderColor.CGColor;
    }
    
    UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editViewTap:)];
    tapView8.delegate = self;
    [self.imgBg addGestureRecognizer:tapView8];
    [self.imgBg setUserInteractionEnabled:YES];
    
    isNotification = YES;
    isUnitSystem = YES;
    
    [self.switchNotification addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Gallery", nil), nil];
    
    validValues = (NSMutableArray*) [@"a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9,_" componentsSeparatedByString:@","];
    
    self.btnSave.hidden = YES;
}

- (BOOL) checkValid:(NSString *) string {
    NSString *temp;
    BOOL ret = NO;
    for (int j = 0; j < [string length] - 1; j++) {
        temp = [string substringWithRange:NSMakeRange(j, 1)];
        ret = NO;
        for (int i = 0; i < [validValues count]; i++) {
            if ([[validValues objectAtIndex:i] isEqual:temp])
            {
                ret = YES;
                break;
            }
        }
        
        if (ret == NO)
            return NO;
    }
    
    return YES;
}

- (void) viewWillAppear:(BOOL)animated {
    
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.labelStatus.layer.borderColor = borderColor.CGColor;
    self.labelStatus.layer.borderWidth = 2.0f;
    self.labelStatus.layer.cornerRadius = 7.5f;
    if ([[defaults objectForKey:@"visibleMode"] intValue] == 2) {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    } else {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
    }
    
    [self loadLabelForBottomMenu];
    
    
    appDelegate.currentViewController = self;
    isUsernameChanged = NO;
    isPasswordChanged = NO;
}

- (void) loadLabelForBottomMenu {
    self.labelPageTitle.text = NSLocalizedString(@"Settings", nil);
    self.labelMode.text = NSLocalizedString(@"Invisibility mode", nil);
    self.labelVisibleSelect.text = NSLocalizedString(@"SELECT ONE", nil);
    self.labelInvisibleSelect.text = NSLocalizedString(@"SELECT ONE", nil);
    [self.btnOption1 setTitle:NSLocalizedString(@"Visibale to everyone", nil) forState:UIControlStateNormal];
    [self.btnOption2 setTitle:NSLocalizedString(@"Invisibable to strangers", nil) forState:UIControlStateNormal];
    [self.btnOption3 setTitle:NSLocalizedString(@"Invisibable to everyone", nil) forState:UIControlStateNormal];
    self.labelUsernameTitle.text = NSLocalizedString(@"Username", nil);
    self.labelPasswordTitle.text = NSLocalizedString(@"Password", nil);
    self.labelNotificationTitle.text = NSLocalizedString(@"Notification sound", nil);
    self.labelNotificationDesc.text = NSLocalizedString(@"Trun on / off sound system", nil);
    self.labelUnitTitle.text = NSLocalizedString(@"Units system", nil);
    self.labelUnit.text = NSLocalizedString(@"US Units", nil);
    //[self.btnEdit1 setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    //[self.btnEdit2 setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [self.btnEdit3 setTitle:NSLocalizedString(@"Metric Units", nil) forState:UIControlStateNormal];
    [self.btnEdit4 setTitle:NSLocalizedString(@"US Units", nil) forState:UIControlStateNormal];
   // [self.btnSave setTitle:NSLocalizedString(@"SAVE", nil) forState:UIControlStateNormal];
    //self.labelTap.text = NSLocalizedString(@"Tap to edit", nil);
    
    
    
    self.labelUsername.text = [defaults objectForKey:@"name"];
    password = [defaults objectForKey:@"password"];
    
    if ([[defaults objectForKey:@"isNotification"] intValue] == 1) {
        isNotification = YES;
    } else {
        isNotification = NO;
    }
    [self.switchNotification setOn:isNotification];
    
    visibleMode = [[defaults objectForKey:@"visibleMode"] intValue];
    if (visibleMode == 0) {
        self.labelMode.text = NSLocalizedString(@"Visibable to everyone", nil);
    } else if (visibleMode == 1) {
        self.labelMode.text = NSLocalizedString(@"Invisibable to strangers", nil);
    } else {
        self.labelMode.text = NSLocalizedString(@"Invisibable to everyone", nil);
    }
    
    if ([[defaults objectForKey:@"isUnitSystem"] intValue] == 1)
        isUnitSystem = YES;
    else
        isUnitSystem = NO;
    
    if ([defaults objectForKey:@"profile"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"profile.jpg"];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
        [self.imgProfile setImage:image];
    }
    
    if (isUnitSystem) {
        [self.imgMetric setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
        [self.imgUS setImage:[UIImage imageNamed:@"settings_checked.png"]];
    } else {
        [self.imgMetric setImage:[UIImage imageNamed:@"settings_checked.png"]];
        [self.imgUS setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnShowVisibleOptions:(id)sender {
    self.viewOption.hidden = NO;
}

- (IBAction)btnHideVisibleOptions:(id)sender {
    self.viewOption.hidden = YES;
}

- (IBAction)editViewTap:(UITapGestureRecognizer*)recognizer {
    self.viewOption.hidden = YES;
}

- (void) changeVisibleMode:(int) vMode {
    
    
    
    int notification = 0;
    if ([self.switchNotification isOn]) {
        [defaults setObject:@"1" forKey:@"isNotification"];
        notification = 1;
    } else {
        [defaults setObject:@"0" forKey:@"isNotification"];
    }
    
    [defaults setObject:[NSString stringWithFormat:@"%d", vMode] forKey:@"visibleMode"];
    
    [defaults synchronize];
    
    [self showProgress:YES];
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&visible=%d&notificationSound=%d", SERVER_ADDRESS, UPDATE_USER, [defaults objectForKey:@"name"], visibleMode, notification]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self showProgress:NO];
                           }];
}

- (IBAction)btnOption1Clicked:(id)sender {
    self.labelMode.text = NSLocalizedString(@"Visibable to everyone", nil);
    self.viewOption.hidden = YES;
    visibleMode = 0;
    [self changeVisibleMode:visibleMode];
    self.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
}
- (IBAction)btnOption2Clicked:(id)sender {
    self.labelMode.text = NSLocalizedString(@"Invisibable to strangers", nil);
    self.viewOption.hidden = YES;
    visibleMode = 1;
    [self changeVisibleMode:visibleMode];
    self.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
}
- (IBAction)btnOption3Clicked:(id)sender {
    self.labelMode.text = NSLocalizedString(@"Invisibable to everyone", nil);
    self.viewOption.hidden = YES;
    visibleMode = 2;
    [self changeVisibleMode:visibleMode];
    self.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
}

- (IBAction)btnProfileImageClicked:(id)sender {
    [self.actionSheet showInView:self.view];
}

- (IBAction)btnEditUsernameClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChangeUsernameViewController *controller = (ChangeUsernameViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChangeUsernameViewController"];
    controller.isUsernameChange = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)btnEditPasswordClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChangeUsernameViewController *controller = (ChangeUsernameViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChangeUsernameViewController"];
    controller.isUsernameChange = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnEditMetricClicked:(id)sender {
    isUnitSystem = NO;
    [self.imgMetric setImage:[UIImage imageNamed:@"settings_checked.png"]];
    [self.imgUS setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    
    
    if (isUnitSystem)
        [defaults setObject:@"1" forKey:@"isUnitSystem"];
    else
        [defaults setObject:@"0" forKey:@"isUnitSystem"];
    
    [defaults synchronize];
}
- (IBAction)btnEditUSClicked:(id)sender {
    isUnitSystem = YES;
    [self.imgMetric setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    [self.imgUS setImage:[UIImage imageNamed:@"settings_checked.png"]];
    
    if (isUnitSystem)
        [defaults setObject:@"1" forKey:@"isUnitSystem"];
    else
        [defaults setObject:@"0" forKey:@"isUnitSystem"];
    
    [defaults synchronize];
}

- (IBAction)btnSaveClicked:(id)sender {
    
}

- (void)alertView:(UIAlertView *)localAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}
- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerController setDelegate: self];
    imagePickerController.allowsEditing = YES;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
	
    [self changeUploadButtonPosition];
}

- (void) changeUploadButtonPosition {
    
    NSString *filename = @"";
    [self.imgProfile setImage:bmImage];
    filename = @"profile.jpg";
    
    [defaults setObject:@"profile.jpg" forKey:@"profile"];
    [defaults synchronize];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    [UIImagePNGRepresentation(bmImage) writeToFile:filePath atomically:YES];
    
    [self uploadImage:bmImage username:[defaults objectForKey:@"name"] filename:filename];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    bmImage = [self imageWithImage:info[UIImagePickerControllerEditedImage] scaledToSize:CGSizeMake(150, 150)];
    //[self.imgProfile setImage:bmImage];
    [self changeUploadButtonPosition];
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

- (IBAction)btnBackClicked:(id)sender {
    MHCustomTabBarController *destinationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHCustomTabBarController"];
//
//    //remove old viewController
//    if (tabBarViewController.oldViewController) {
//        [tabBarViewController.oldViewController willMoveToParentViewController:nil];
//        [tabBarViewController.oldViewController.view removeFromSuperview];
//        [tabBarViewController.oldViewController removeFromParentViewController];
//    }
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

    destinationViewController.view.frame = self.view.bounds;
    [self addChildViewController:destinationViewController];
    [self.view addSubview:destinationViewController.view];
    [destinationViewController didMoveToParentViewController:self];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setDelegate: self];
        imagePickerController.allowsEditing = YES;
        
        [self presentViewController:imagePickerController animated: YES completion:nil];
    } else if (buttonIndex == 0){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Camera" message:@"Can't use this functionality!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        UIImagePickerController *imagePickerCameraController = [[UIImagePickerController alloc] init];
        [imagePickerCameraController setSourceType: UIImagePickerControllerSourceTypeCamera];
        [imagePickerCameraController setDelegate: self];
        imagePickerCameraController.allowsEditing = YES;
        
        [self presentViewController:imagePickerCameraController animated: YES completion:nil];
    }
}

- (void)uploadImage:(UIImage*)image username:(NSString *)username filename:(NSString *)filename
{
    // [self showProgress:YES];
    
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
    [body appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    //[self showProgress:NO];
}

- (void) setState:(id)sender {
    [self changeVisibleMode:visibleMode];
}

@end
