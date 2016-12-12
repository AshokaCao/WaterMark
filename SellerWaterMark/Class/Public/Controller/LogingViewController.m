//
//  LogingViewController.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/11/24.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "LogingViewController.h"
#import "UserDataViewController.h"

@interface LogingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *codeNumberText;
@property (weak, nonatomic) IBOutlet UIButton *codeNumberBtn;
@property (weak, nonatomic) IBOutlet UIButton *logingBtn;


@end

@implementation LogingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)returnBackAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)codeNumberAction:(UIButton *)sender {
}
- (IBAction)logingAction:(UIButton *)sender {
    UserDataViewController *userView = [[UserDataViewController alloc] init];
    UINavigationController *nacv = [[UINavigationController alloc] initWithRootViewController:userView];
    [self presentViewController:nacv animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
