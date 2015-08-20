//
//  RSATestViewController.m
//  iOSSecurity
//
//  Created by 吴湧霖 on 15/8/19.
//  Copyright (c) 2015年 吴湧霖. All rights reserved.
//

#import "RSATestViewController.h"
#import "RSA.h"
#import <AFNetworking.h>

@interface RSATestViewController ()

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *sendButton;

@end

@implementation RSATestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.textField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.text = @"Hello,Man!";
        textField.frame = CGRectMake(50, 50, 200, 50);
        textField;
    });
    [self.view addSubview:self.textField];
    
    self.sendButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Send" forState:UIControlStateNormal];
        button.frame = CGRectMake(100, 150, 100, 75);
        button.backgroundColor = [UIColor blueColor];
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.sendButton];
}

- (void)click {
    RSA *rsa = [[RSA alloc] init];
    NSString *msg = @"Hello,Man!Hello,Man!Hello,Man!Hello,Man!Hello,Man!Hello,Man!Hello,Man!Hello,Man!Hello,Man!Hello,Man!12345678901234567";
    msg = [rsa encryptWithString:msg];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"msg":msg};
    [manager GET:@"http://127.0.0.1:8080/Echo/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
