//
//  QRViewController.m
//  QRContentMobilizer
//
//  Created by Wojciech Czekalski on 21.03.2014.
//  Copyright (c) 2014 Wojciech Czekalski. All rights reserved.
//

#import "QRViewController.h"
#import "QRContentMobilizer.h"
#import "NSAttributedString+HTMLStyle.h"

@interface QRViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation QRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [QRContentMobilizer setToken:@""];
    
    QRContentMobilizer *mobilizer = [[QRContentMobilizer alloc] init];
    [mobilizer mobilizeContentsOfURL:[NSURL URLWithString:@"http://www.theverge.com/2014/3/24/5526694/virtual-reality-made-me-believe-i-was-someone-else"] completion:^(NSDictionary *info, NSError *error) {
        self.textView.text = info[QRContentPlainText];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
