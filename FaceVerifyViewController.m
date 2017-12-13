//
//  FaceVerifyViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/2.
//  Copyright © 2017年 Mac. All rights reserved.
//


//***刷脸验证***//

#import "FaceVerifyViewController.h"
#import "PhotographViewController.h"

@interface FaceVerifyViewController (){
    MBProgressHUD *hud;
}


@property (weak, nonatomic) IBOutlet UIButton *uploadingBtn;  //上传
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;  //取消

@property (strong, nonatomic) UIImage *faceImage;

@end

@implementation FaceVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"刷脸认证";
    
    _uploadingBtn.layer.cornerRadius = 7;
    _cancelBtn.layer.cornerRadius = 7;
    
    _uploadingBtn.backgroundColor = NAV_COLOR;
    
    [_uploadingBtn addTarget:self action:@selector(uploadingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}


//调用相机拍照返回后上传
-(void)uploadingBtnClick{
    
    PhotographViewController *vc = [[PhotographViewController alloc] init];
    vc.block = ^(UIImage *image) {
        _faceImage = image;
        [self postVerifyWithFaceImage:_faceImage];
    };
    [self presentViewController:vc animated:YES completion:nil];
}


//上传认证照片
-(void)postVerifyWithFaceImage:(UIImage *)faceImage{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"AddUser/upIdimg"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        NSData *data=UIImagePNGRepresentation(image);
        NSData *data = UIImageJPEGRepresentation(faceImage, 0.7);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        NSLog(@"上传图片成功 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                
                //保存已认证的手机号码
                NSMutableArray *keyArray = [NSMutableArray array];
                //获取全部手机号码
                NSArray *allKey = [KeyChain load:KEY_Server];
                if (allKey != nil) {
                    keyArray = [allKey mutableCopy];
                }
                //添加新手机号码
                NSMutableDictionary *key_phone = [NSMutableDictionary dictionary];
                [key_phone setValue:_userPhone forKey:@"userPhone"];
                [keyArray addObject:key_phone];
                //删除以前的
                [KeyChain delete:KEY_Server];
                //保存新的手机列表
                [KeyChain save:KEY_Server data:keyArray];
                
                [Util toastWithView:self.navigationController.view AndText:@"上传成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"上传失败，请重新操作"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传图片失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        [hud hideAnimated:YES];
        
        return ;
    }];
    
}



-(void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
