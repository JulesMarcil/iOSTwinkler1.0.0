//
//  DashboardViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "DashboardViewController.h"
#import "memberCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface DashboardViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSArray *memberArray;
}

@end

@implementation DashboardViewController

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
    memberArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupMembers"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSLog(@"member: %u",[memberArray count]);
    return [memberArray count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    memberCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"memberCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [cell.memberProfilePic setFrame:CGRectMake(22,0,35,35)];
    [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:35.0];
    
    NSDictionary *member = [memberArray objectAtIndex:indexPath.row];
    NSLog(@"member = %@", member);
    
    NSString *path = member[@"picturePath"];
    NSNumber *facebookId= [[[NSNumberFormatter alloc] init] numberFromString:path];
    
    NSURL *url;
    if (facebookId) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
    } else if(![path isEqualToString:@"local"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8888/Twinkler1.2.3/web/%@", path]];
    }
    
    if(url) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSLog(@"%@", url);
        
        [cell.memberProfilePic setImageWithURLRequest:request
                                     placeholderImage:[UIImage imageNamed:@"profile-pic.png"]
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  cell.memberProfilePic.image = image;
                                                  [cell.memberProfilePic setFrame:CGRectMake(22,0,35,35)];
                                                  [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:35.0];
                                                  
                                              }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"Failed with error: %@", error);
                                              }];
    }
    
    cell.memberProfilePic.alpha=1;
    cell.isSelected=YES;
    cell.memberNameLabel.text=[memberArray objectAtIndex:indexPath.row][@"name"];
    cell.memberNameLabel.backgroundColor=[UIColor clearColor];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    memberCollectionViewCell *cell= (memberCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    

    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(80, 60);
    return retval;
}

-(void) setRoundedView:(UIImageView *)imageView picture: (UIImage *)picture toDiameter:(float)newSize{
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:100.0] addClip];
    // Draw your image
    CGRect frame=imageView.bounds;
    frame.size.width=newSize;
    frame.size.height=newSize;
    [picture drawInRect:frame];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
}
@end
