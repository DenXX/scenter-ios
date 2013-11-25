//
//  MessageInfoView.m
//  Geo
//
//  Created by David Fink on 11/23/13.
//  Copyright (c) 2013 David Fink. All rights reserved.
//

#import "MessageInfoView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#define darkGreen [UIColor colorWithRed:0/255.0 green:128/255.0 blue:0/255.0 alpha:1]
#define lightGreen [UIColor colorWithRed:0/255.0 green:50/255.0 blue:0/255.0 alpha:0.1]


@interface MessageInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *labelBackground;
@property (weak, nonatomic) IBOutlet UITableView *scentsInFenceTable;
@property (weak, nonatomic) IBOutlet UILabel *moreScentsLabel;

//@property (weak, nonatomic) IBOutlet MKMapView *fenceMap;

@end

@implementation MessageInfoView {
    BOOL alreadySeenThisScentInList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) populateTable {
    NSString *domain = @"http://tritanium.mathcs.emory.edu/scenter/api";
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@/fence/%@", domain, self.scent[@"fence"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:urlStr]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *jsonParsingError = nil;
    self.fence = [[NSDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError]];
    
    urlStr = [[NSString alloc] initWithFormat:@"%@/scents/%@", domain, _fence[@"id"]];
    request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:urlStr]];;
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    self.scentsInFence = [[NSArray alloc] initWithArray: [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError]];
    
    _scentsInFenceTable.delegate = self;
    _scentsInFenceTable.dataSource = self;
    [_scentsInFenceTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    alreadySeenThisScentInList = NO;
    
    [self populateTable];
    
    _moreScentsLabel.text = [[NSString alloc] initWithFormat:@"More scents in %@", _fence[@"name"]];
    
    
    //self.view.backgroundColor = [UIColor colorWithRed: 180.0/255.0 green: 238.0/255.0 blue:180.0/255.0 alpha: 1.0];
    
    //_titleLabel.text = _scent[@"title"];
    //_authorLabel.text = _scent[@"author"];
    _contentLabel.text = _scent[@"content"];
    
    [_contentLabel sizeToFit];
    
    _labelBackground.layer.borderColor = darkGreen.CGColor;
    _labelBackground.layer.borderWidth = 1.0;
    _labelBackground.layer.cornerRadius = 10.0;
    _labelBackground.backgroundColor = lightGreen;
    
    _scentsInFenceTable.layer.borderColor = darkGreen.CGColor;
    _scentsInFenceTable.layer.borderWidth = 1.0;
    _scentsInFenceTable.layer.cornerRadius = 10.0;
    //_scentsInFenceTable.backgroundColor = [UIColor whiteColor];
    
    
    //_fenceMap.showsUserLocation = YES;
    //[_fenceMap setCenterCoordinate:_userLocation animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Number of rows is the number of time zones in the region for the specified section.
    return [_scentsInFence count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
    }
    
    
    NSInteger index = indexPath.item;
    if([[_scentsInFence objectAtIndex:index][@"id"] isEqualToNumber:_scent[@"id"]]) {
        alreadySeenThisScentInList = YES;
    }
    
    if(alreadySeenThisScentInList) {
        index = index + 1;
    }
    
    NSDictionary *workingScent = [_scentsInFence objectAtIndex:index];
    //cell.textLabel.text = scent[@"title"];
    //cell.detailTextLabel.text = scent[@"author"];
    cell.textLabel.text = workingScent[@"content"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // self.
}


@end
