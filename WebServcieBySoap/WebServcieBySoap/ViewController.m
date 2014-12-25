//
//  ViewController.m
//  WebServcieBySoap
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "ViewController.h"
#import "RemoteLogic.h"
#import "User.h"

@interface ViewController ()
@property (nonatomic,retain) UIButton *strBtn;
@property (nonatomic,retain) UIButton *arrayBtn;
@property (nonatomic,retain) UIButton *xmlBtn;
@property (nonatomic,retain) UIButton *jsonBtn;
@property (nonatomic,retain) UITextView *textView;
@end

@implementation ViewController
@synthesize strBtn = _strBtn;
@synthesize arrayBtn = _arrayBtn;
@synthesize xmlBtn = _xmlBtn;
@synthesize jsonBtn = _jsonBtn;
@synthesize textView = _textView;

-(void)dealloc{

    self.strBtn = nil;
    self.arrayBtn = nil;
    self.xmlBtn = nil;
    self.jsonBtn = nil;
    self.textView = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.strBtn = nil;
    self.arrayBtn = nil;
    self.xmlBtn = nil;
    self.jsonBtn = nil;
    self.textView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btnStr = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnStr.frame = CGRectMake(40,10,[UIScreen mainScreen].bounds.size.width/2-80,40);
    UILabel *labelStr = [[[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2-80-40)/2, 0, 40,40)] autorelease];
    labelStr.text = @"Str";
    labelStr.backgroundColor = [UIColor clearColor];
    [btnStr addSubview:labelStr];
    [btnStr addTarget:self action:@selector(btnStr:) forControlEvents:UIControlEventTouchUpInside];
    self.strBtn = btnStr;
    [self.view addSubview:self.strBtn];
    
    UIButton *btnArray = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnArray.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2+40,10,[UIScreen mainScreen].bounds.size.width/2-80,40);
    [btnArray addTarget:self action:@selector(btnArray:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelArray = [[[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2-80-40)/2, 0, 45,40)] autorelease];
    labelArray.text = @"Array";
    labelArray.backgroundColor = [UIColor clearColor];
    [btnArray addSubview:labelArray];
    self.arrayBtn = btnArray;
    [self.view addSubview:self.arrayBtn];
    
    UIButton *btnXML = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnXML.frame = CGRectMake(40,60,[UIScreen mainScreen].bounds.size.width/2-80,40);
    [btnXML addTarget:self action:@selector(btnXML:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelXML = [[[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2-80-40)/2, 0, 40,40)] autorelease];
    labelXML.text = @"XML";
    labelXML.backgroundColor = [UIColor clearColor];
    [btnXML addSubview:labelXML];
    self.xmlBtn = btnXML;
    [self.view addSubview:self.xmlBtn];
    
    UIButton *btnJson = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnJson.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2+40,60,[UIScreen mainScreen].bounds.size.width/2-80,40);
    [btnJson addTarget:self action:@selector(btnJson:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelJson = [[[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2-80-40)/2, 0, 40,40)] autorelease];
    labelJson.text = @"Json";
    labelJson.backgroundColor = [UIColor clearColor];
    [btnJson addSubview:labelJson];
    self.jsonBtn = btnJson;
    [self.view addSubview:self.jsonBtn];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 110,  [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-150)];
    textView.delegate = self;
    self.textView = textView;
    [self.view addSubview:self.textView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark - Button UIControlEventTouchUpInside
-(void)btnStr:(UIButton *)btn {
    NSString *str = [[RemoteLogic sharedInstance] GeUserIDByName:@"fs"];
    self.textView.text = str;
}

-(void)btnArray:(UIButton *)btn {
    NSMutableArray *array = [[RemoteLogic sharedInstance] GetUserNameList];
    NSString *str = @"";
    for (NSString *tempStr in array) {
        str =[str stringByAppendingFormat:@"%@\n",tempStr];
    }
    self.textView.text = str;
}

-(void)btnXML:(UIButton *)btn {
    NSMutableArray *array = [[RemoteLogic sharedInstance] GetUserListByXML];
    NSString *str = @"";
    for (User *user in array) {
        str =[str stringByAppendingFormat:@"%@{\nuserName:%@\nuserID:%@\n}\n",user,user.userName,user.userID];
    }
    self.textView.text = str;
}

-(void)btnJson:(UIButton *)btn {
    NSMutableArray *array = [[RemoteLogic sharedInstance] GetUserListByJson];
    NSString *str = @"";
    for (User *user in array) {
        str =[str stringByAppendingFormat:@"%@{\nuserName:%@\nuserID:%@\n}\n",user,user.userName,user.userID];
    }
    self.textView.text = str;
}

#pragma mark -
#pragma mark -textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

@end
