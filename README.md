# shareKit
集合微信+QQ+微博分享/一键登录/支付的工具集合，只需引入此静态库，配置一下对应的appId和appSecret，便可通过调用一行代码来实现分享,登录和支付的功能，去中心化，无需为分享功能额外注册


## 一键登录
### 通过QQ登录
```
[SHShareKitManager startQQAuthorizationWithSuccessBlock:^(NSString *uid) {
     //登录成功回调
} failureBlock:^(BOOL isCanceled) {
     //登录失败回调
}];
```
### 通过微信登录
```
[SHShareKitManager startWeChatAuthorizationWithViewController:self successBlock:^(NSString *uid, NSString *accessToken) {
    //登录成功回调
} failureBlock:^(BaseResp *response) {
   //登录失败回调
}];
```
### 通过微博登录
```
[SHShareKitManager startWeiboAuthorizationWithSuccessBlock:^(NSString *uid, NSString *accessToken) {
    //登录成功回调
} failureBlock:^(WBBaseResponse *response) {
   //登录失败回调     
}];
```

## 一键分享
### 分享到QQ空间
```
[SHShareKitManager shareToQzoneWithTitle:@"Test Title" descriptions:@"Test Descriptions" previewImageUrl:@"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg" linkUrl:@"http://sports.qq.com/a/20120510/000650.htm" successBlock:^(QQBaseResp *result) {
     //分享成功回调
 } failureBlock:^(QQBaseResp *result) {
     //分享成功回调
 }];
 ```
 ### 分享到微信好友
 ```
 [SHShareKitManager shareToWeChatSessionWithTitle:@"分享测试" descriptions:@"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。" thumbnailData:imageData linkUrl:@"http://www.wconcept.cn" successBlock:^(BaseResp *result) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
 } failureBlock:^(BaseResp *result) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
}]; 
```
 ### 分享到微信朋友圈
```
[SHShareKitManager shareToWeChatTimelineWithTitle:@"分享测试" descriptions:@"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。" thumbnailData:imageData linkUrl:@"http://www.wconcept.cn" successBlock:^(BaseResp *result) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
 } failureBlock:^(BaseResp *result) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
 }];
 ```
 ### 分享到博
 ```
 [SHShareKitManager shareToWeiboWithUUID:@"" title:@"分享测试" descriptions:@"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。" thumbnailData:imageData linkUrl:@"http://www.wconcept.cn" successBlock:^(WBBaseResponse *result) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
  } failureBlock:^(WBBaseResponse *result) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
  }];
  ```

 ## 一键支付
 ### 发起微信支付
  ```
 [SHShareKitManager wechatPayWithOrderNo:@"TestOrderNo001" orderName:@"TestOrder" orderPrice:@"1" successBlock:^(BaseResp *response) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
  } failureBlock:^(BaseResp *response) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:response.errStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
 }];
 ```
  
