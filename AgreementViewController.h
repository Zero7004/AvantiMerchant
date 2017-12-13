//
//  AgreementViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/22.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreementViewController : UITableViewController

typedef void(^IsAgree)(BOOL isAgree);
@property (nonatomic, copy) IsAgree block;


@end
