# UIComponents

公共UI组件：广告轮播、PageControl、导航栏、ProgressHUD、ZoomScrollView

<img width="273" alt="企业微信截图_e4987d53-cde9-4251-aba9-0ba0a3612fb9" src="https://user-images.githubusercontent.com/13111933/114657118-f2ec8300-9d21-11eb-9e57-2f6ea5098c38.png">

、、MKAdvertBannerView *advertBannerView = [[MKAdvertBannerView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 20, kScreenWidth,  150)];
、、advertBannerView.itemWidth = kScreenWidth - 60;
、、advertBannerView.minLineSpace = -20;
、、advertBannerView.isZoom = YES;
、、advertBannerView.autoScroll = YES;
、、advertBannerView.repeats = YES;
、、advertBannerView.dataSource = self;
、、advertBannerView.delegate = self;
、、[self addSubView:advertBannerView];
