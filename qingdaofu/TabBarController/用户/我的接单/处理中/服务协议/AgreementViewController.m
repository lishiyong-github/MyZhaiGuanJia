//
//  AgreementViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AgreementViewController.h"
#import "MyReleaseViewController.h"

#import "BaseCommitButton.h"

@interface AgreementViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIWebView *agreementWebView;
@property (nonatomic,strong) BaseCommitButton *agreeButton;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navTitleString;
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.agreementWebView];
    
    if ([self.flagString integerValue] == 1) {
        [self.view addSubview:self.agreeButton];
    }
    
    [self.view setNeedsUpdateConstraints];
    
    [self resuweeee];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.agreementWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        if ([self.flagString integerValue] == 1) {
            [self.agreeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
            [self.agreeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
            [self.agreeButton autoSetDimensionsToSize:CGSizeMake(80, 30)];
        }
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIWebView *)agreementWebView
{
    if (!_agreementWebView) {
        _agreementWebView = [UIWebView newAutoLayoutView];
//        NSString *urlString  = [NSString stringWithFormat:@"%@%@?type=view&productid=%@?token=%@",kQDFTestUrlString,kMyorderDetailOfAgreement,self.productid,[self getValidateToken]];
        
        
        
        
//        NSURL *url = [NSURL URLWithString:urlString];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        
//        [_agreementWebView loadRequest:request];
    }
    return _agreementWebView;
}

- (BaseCommitButton *)agreeButton
{
    if (!_agreeButton) {
        _agreeButton = [BaseCommitButton newAutoLayoutView];
        [_agreeButton setTitle:@"同意" forState:0];
        [_agreeButton addTarget:self action:@selector(agreeForAgreement) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

#pragma mark - method

- (void)resuweeee
{
    NSString *aoaoao = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyorderDetailOfAgreement];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"productid" : self.productid,
                             @"type" : @"pdf"};
    
    QDFWeakSelf;
    [self requestDataPostWithString:aoaoao params:params successBlock:^(id responseObject) {
        
//        [responseObject JSONString];
        
        NSDictionary *apapap = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
//        [weakself.agreementWebView loadData:responseObject MIMEType:@"pdf" textEncodingName:nil baseURL:nil];
        
        [weakself.agreementWebView loadHTMLString:@"http://www.zcb2016.com/site/pdf?type=I&types=6" baseURL:nil];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}
- (void)agreeForAgreement
{
    NSString *agreementString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfConfirmAgreement];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"ordersid" : self.ordersid
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:agreementString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself back];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}


-(void)loadDocument:(NSString *)documentName inView:(UIWebView *)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

CGPDFDocumentRef GetPDFDocumentRef(NSString *filename)
{
    
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    size_t count;
    
    path = CFStringCreateWithCString (NULL, [filename UTF8String], kCFStringEncodingUTF8);
    
    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    
    CFRelease (path);
    
    document = CGPDFDocumentCreateWithURL (url);
    
    CFRelease(url);
    
    count = CGPDFDocumentGetNumberOfPages (document);
    
    if(count == 0) {
            printf (
             "[%s] needs at least one page!\n"
             , [filename UTF8String]);
            
            return NULL;
        }
    else{
        printf (
         "[%ld] pages loaded in this PDF!\n"
         , count);
    }
    return document;
}

void  DisplayPDFPage (CGContextRef myContext,size_t pageNumber, NSString *filename)
{
    CGPDFDocumentRef document;
    CGPDFPageRef page;
    document = GetPDFDocumentRef (filename);
    page = CGPDFDocumentGetPage (document, pageNumber);
    CGContextDrawPDFPage (myContext, page);
    CGPDFDocumentRelease (document);  
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
