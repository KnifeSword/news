//
//  docDestialVC.m
//  新闻客户端
//
//  Created by qingyun on 16/6/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "docDestialVC.h"
#import "AFNetworking.h"
#import "Common.h"
@interface docDestialVC ()
@property(nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)UIButton *btn;
@end

@implementation docDestialVC
-(UIButton *)btn
{
    if (_btn==nil) {
        _btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"back" forState:UIControlStateNormal];

        [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //_btn.backgroundColor=[UIColor blackColor];
       // _btn.alpha=0;
       // _btn.hidden=YES;
         _btn.frame=CGRectMake(10, 20, 50, 40);
          [_btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
      
    }
    return _btn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self getDocNewswithModel:self.model];
    
    [self.view addSubview:self.btn];
   // self.webView.userInteractionEnabled=NO;
 


    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //self.btn.hidden=!self.btn.hidden;
}
-(void)back{

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",nil];
        _manager = manager;
    }
    return _manager;
}
-(UIWebView *)webView
{
    if (_webView==nil) {
        _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 70, ScrW, ScrY)];
      //  _webView.scalesPageToFit=YES;
        
    }
    return _webView;
}
-(void)viewDidAppear:(BOOL)animated
{
    self.view.backgroundColor=[UIColor whiteColor];
}
-(void)getDocNewswithModel:(HomeListModel *)model{
    
    //[self.webView loadHTMLString:model.newsId baseURL:nil];
    __weak  docDestialVC * webVC = self;
    [self.manager GET:model.newsId parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse * response = (NSHTTPURLResponse*)task.response;
        if (response.statusCode == 200) {
            NSString *textStr = responseObject[@"body"][@"text"];
            textStr = [textStr stringByReplacingOccurrencesOfString:@"凤凰" withString:@"11"];
           
            [webVC.webView loadHTMLString:textStr baseURL:nil];
    
        }
    } failure:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{//调整UIwebView的大小适应屏幕
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body') [0].style.webkitTextSizeAdjust= '150%'"];//修改百分比即可修改字体大小
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
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
