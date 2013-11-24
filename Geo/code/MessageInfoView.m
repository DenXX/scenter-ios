//
//  MessageInfoView.m
//  Geo
//
//  Created by David Fink on 11/23/13.
//  Copyright (c) 2013 David Fink. All rights reserved.
//

#import "MessageInfoView.h"
#import <QuartzCore/QuartzCore.h>


@interface MessageInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//@property (weak, nonatomic) IBOutlet MKMapView *fenceMap;

@end

@implementation MessageInfoView

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
	// Do any additional setup after loading the view.
    
    //_titleLabel.text = _scent[@"title"];
    //_authorLabel.text = _scent[@"author"];
    _contentLabel.text = _scent[@"content"];
    
    _contentLabel.layer.borderColor = [UIColor greenColor].CGColor;
    _contentLabel.layer.borderWidth = 3.0;
    
    //_fenceMap.showsUserLocation = YES;
    //[_fenceMap setCenterCoordinate:_userLocation animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
