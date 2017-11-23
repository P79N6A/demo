//
//  DetailViewController.h
//  41 mask
//
//  Created by FEIWU888 on 2017/10/30.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

