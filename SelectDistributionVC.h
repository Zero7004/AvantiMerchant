//
//  SelectDistributionVC.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDistributionVC : UIViewController

typedef void(^PeiSong)(BOOL isPeiSong);
@property (nonatomic, copy) PeiSong block;


@end
