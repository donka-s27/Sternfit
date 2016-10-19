//
//  MapViewController.h
//  SternFit
//
//  Created by MacOS on 1/21/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (strong,nonatomic) NSString *strLocation;

////// Outlets

@property (retain, nonatomic) IBOutlet MKMapView *map;

- (IBAction)btnBackClicked:(id)sender;

@end
