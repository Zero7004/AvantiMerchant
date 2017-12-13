//
//  EditMerchantsVIPCell.h
//  AvantiMerchant
//
//  Created by long on 2017/12/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMerchantsVIPCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *LV;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *zk;

@end
