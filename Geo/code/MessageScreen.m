//
//  MessageScreen.m
//  Geo
//
//  Created by David Fink on 11/22/13.
//  Copyright (c) 2013 David Fink. All rights reserved.
//

#import "MessageScreen.h"
#import "MessageInfoView.h"

@interface MessageScreen ()

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

- (IBAction)refresh:(id)sender;

@end

@implementation MessageScreen {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

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

    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    [self updateMessages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [_scentsNearby count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
    }
    
    NSDictionary *scent = [_scentsNearby objectAtIndex:indexPath.item];
    //cell.textLabel.text = scent[@"title"];
    //cell.detailTextLabel.text = scent[@"author"];
    cell.textLabel.text = scent[@"content"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"messageInfoPush" sender:[self navigationController]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MessageInfoView *messageInfoController = segue.destinationViewController;
    NSIndexPath *selectedPath = [_messageTableView indexPathForSelectedRow];
    
    NSDictionary *scent = [_scentsNearby objectAtIndex:selectedPath.item];
    messageInfoController.scent = scent;
    
    NSDictionary *fence = _fencesWithin[scent[@"fence"]];
    messageInfoController.fence = fence;
    messageInfoController.userLocation = _location;
    
    [_messageTableView deselectRowAtIndexPath:selectedPath animated:YES];
}

 
- (void) getMessagesNearby
{
    if(!_fencesWithin) {
        _fencesWithin = [[NSMutableDictionary alloc] init];
    }
    if(!_scentsNearby) {
        _scentsNearby = [[NSMutableArray alloc] init];
    }
    
    [_fencesWithin removeAllObjects];
    [_scentsNearby removeAllObjects];
    
    NSString *domain = @"http://tritanium.mathcs.emory.edu/scenter/api";
    NSString *urlString = [NSString stringWithFormat:@"%@/fences/?loc=%f,%f", domain, _location.latitude, _location.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *jsonParsingError = nil;
    NSArray *fencesWithinArray = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError]];

    
    for(int i = 0; i < [fencesWithinArray count]; i++) {
        [_fencesWithin setObject:[fencesWithinArray objectAtIndex:i] forKey:[fencesWithinArray objectAtIndex:i][@"id"]];
    }
    
    for(int i = 0; i < [fencesWithinArray count]; i++) {
        NSDictionary *fence = [fencesWithinArray objectAtIndex:i];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/scents/%@", domain, fence[@"id"]]];
        request = [NSURLRequest requestWithURL:url];
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSArray *scentsInThisFence = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
        for(int j = 0; j < [scentsInThisFence count]; j++) {
            [_scentsNearby addObject:[scentsInThisFence objectAtIndex:j]];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];

    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _location = currentLocation.coordinate;
    }
    
    
    [self getMessagesNearby];
    
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    [_messageTableView reloadData];
}

- (void)updateMessages
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (IBAction)refresh:(id)sender
{
    [self updateMessages];
}

@end
