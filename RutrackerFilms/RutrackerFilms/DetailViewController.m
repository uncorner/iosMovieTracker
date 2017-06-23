//
//  ViewController.m
//  RutrackerFilms
//
//  Created by denis on 24.05.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import "DetailViewController.h"
#import "Common.h"

@interface DetailViewController ()


@end

@implementation DetailViewController

NSInteger const MaxTitleLenght = 12;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"Back"
                                                                         style:UIBarButtonItemStylePlain
                                                                         target:nil action:nil];
    //self.navigationController.navigationItem.title = @"123";
    //self.navigationController.navigationBar.topItem.title = @"123";
    
    NSString *shortName = [NSString stringWithString:self.name];
    if (shortName.length > MaxTitleLenght) {
        shortName = [NSString stringWithString:[self.name substringToIndex:MaxTitleLenght]];
        shortName = [shortName stringByAppendingString:@"..."];
    }
    
    [self setTitle: shortName];
    
    NSMutableString *stringUrl = [[NSMutableString alloc]init];
    [stringUrl appendString:WebsiteUrl];
    [stringUrl appendString:@"/"];
    [stringUrl appendString:self.relativeUrl];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    self.webView.scalesPageToFit = YES;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
