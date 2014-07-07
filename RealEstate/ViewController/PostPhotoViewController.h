//
//  PostPhotoViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/12/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostPhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)onTakePhotoBtnPressed:(id)sender;
- (void) setEnable:(BOOL)enable;
@end
