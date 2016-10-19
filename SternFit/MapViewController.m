//
//  MapViewController.m
//  SternFit
//
//  Created by MacOS on 1/21/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "MapViewController.h"
#import "sbMapAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize strLocation,map;
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
    
    NSArray *items = [strLocation componentsSeparatedByString:@","];
    [map removeAnnotations:[map.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"!(self isKindOfClass:%@)",[MKUserLocation class]]]];
    map.hidden=NO;
    
    CLLocationCoordinate2D l;
    l.latitude=[[items objectAtIndex:0] doubleValue];
    l.longitude=[[items objectAtIndex:1] doubleValue];
    SBMapAnnotation *annotation= [[SBMapAnnotation alloc]initWithCoordinate:l];
    
    [map addAnnotation:annotation];
    [map setRegion:MKCoordinateRegionMake([annotation coordinate], MKCoordinateSpanMake(.005, .005)) animated:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
