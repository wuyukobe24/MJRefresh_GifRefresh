# MJRefresh_GifRefresh
自定义MJRefresh上拉和下拉刷新动画如下：

![](https://github.com/wuyukobe24/MJRefresh_GifRefresh/blob/master/refresh_2.gif)

#### 实现思路：
* 制作下拉动画时我们只需要在`MJRefresh`的`MJRefreshGifHeader`类中添加我们所需要Gif图片，并隐藏掉提示文字即可。
* 制作上拉动画同理，需要在`MJRefresh`的`MJRefreshBackGifFooter`类或者`MJRefreshAutoGifFooter`类中添加我们所需要Gif图片，并隐藏掉提示文字即可。（`MJRefreshBackGifFooter`和`MJRefreshAutoGifFooter`的区别是：前者只有上拉才会显示，是默认的上拉控件，而后者则是添加在所需要刷新视图下面，上拉或者点击文字均可触发加载动画）
#### 下拉刷新
* 创建一个gif类`CustomGifHeader`继承自`MJRefreshGifHeader`。
```
@interface CustomGifHeader : MJRefreshGifHeader
```
* 重写父类方法，添加不同状态的下的gif图片，并设置隐藏提示文字。
```
#pragma mark - 实现父类的方法
- (void)prepare {
    [super prepare];
    //GIF数据
    NSArray * idleImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:8];
    NSArray * refreshingImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:8];
    //普通状态
    [self setImages:idleImages forState:MJRefreshStateIdle];
    //即将刷新状态
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    //正在刷新状态
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}
- (void)placeSubviews {
    [super placeSubviews];
    //隐藏状态显示文字
    self.stateLabel.hidden = YES;
    //隐藏更新时间文字
    self.lastUpdatedTimeLabel.hidden = YES;
}

#pragma mark - 获取资源图片
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    NSMutableArray * imageArray = [NSMutableArray array];
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"Loading_%zd.tiff",i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    return imageArray;
}
```

* 创建并添加`tableView`的刷新`gifHeader`
```
- (CustomGifHeader *)gifHeader {
    if (!_gifHeader) {
        _gifHeader = [CustomGifHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
            });
        }];
    }
    return _gifHeader;
}
```
```
_tableView.mj_header = self.gifHeader;
```

#### 上拉加载和下拉刷新步骤一样。需要注意的是创建上拉加载gif动画继承有两个类，`MJRefreshBackGifFooter`和`MJRefreshAutoGifFooter`。两者的的区别是：前者只有上拉才会显示，是默认的上拉控件，而后者则是添加在所需要刷新视图下面，上拉或者点击文字均可触发加载动画。
