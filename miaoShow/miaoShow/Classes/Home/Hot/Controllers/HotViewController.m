//
//  HotViewController.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "HotViewController.h"
#import "HomeADTableViewCell.h"
#import "HotLiveTableViewCell.h"
#import "RefreshGifHeader.h"
#import "LiveADModel.h"
#import "LiveListModel.h"
#import "WebViewController.h"
#import "LiveIngCollectionViewController.h"
@interface HotViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** 直播 */
@property(nonatomic, strong) NSMutableArray *lives;
/** 广告 */
@property(nonatomic, strong) NSArray *topADS;

@property (nonatomic, strong) UITableView *tableView;
@end
static NSString *reuseIdentifier = @"HotLiveTableViewCell";
static NSString *ADReuseIdentifier = @"HomeADTableViewCell";

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lives =[NSMutableArray array];
    self.topADS = [NSArray array];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    self.tableView.delegate = self;
    self.tableView .dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];

    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HotLiveTableViewCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    [self.tableView registerClass:[HomeADTableViewCell class] forCellReuseIdentifier:ADReuseIdentifier];
    
    
     self.currentPage = 1;
    
    //头部栏刷新   自定义了一个RefreshGifHeader 继承自MJRefreshGifHeader
    self.tableView.mj_header = [RefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        // 获取顶部的广告
        [self getTopAD];
        [self getHotLiveList];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getHotLiveList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
}
#pragma mark 获取广告数据
-(void)getTopAD{

    //NetWorkTool 继承自AFHTTPSessionManager
    // GET请求 没有参数
    [[NetWorkTool shareTool] GET:@"http://live.9158.com/Living/GetAD" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
        NSArray *result = responseObject[@"data"];
        if (result.count>0) {
            self.topADS = [LiveADModel mj_objectArrayWithKeyValuesArray:result];
            
            //刷新
            [self.tableView reloadData];

        }else{
            [self showHint:@"网络异常"];
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        [self showHint:@"网络异常"];

    }];
    
}
#pragma mark 获取直播数据
- (void)getHotLiveList{

    [[NetWorkTool shareTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", self.currentPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
            //结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSArray *resultArr =[LiveListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if (resultArr.count>0) {
            [self.lives addObjectsFromArray:resultArr];
            //刷新
            [self.tableView reloadData];
        }else{
            [self showHint:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentPage--;
        [self showHint:@"网络异常"];
    }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.lives.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    return 465;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HomeADTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ADReuseIdentifier];
        if (self.topADS.count) {
            cell.topADs = self.topADS;
            [cell setImageClickBlock:^(LiveADModel *topAD) {
                if (topAD.link.length) {
                    WebViewController *web = [[WebViewController alloc] initWithUrlStr:topAD.link];
                    web.navigationItem.title = topAD.title;
                  
                    //通知  让home控制器 移除热点 最新 关注 导航栏
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSelectedView" object:nil];
                    

                    [self.navigationController pushViewController:web animated:YES];
                }
            }];
        }
        return cell;
    }
    HotLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (self.lives.count) {
        LiveListModel *liveModel = self.lives[indexPath.row-1];
        cell.live = liveModel;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveIngCollectionViewController *liveVc = [[LiveIngCollectionViewController alloc] init];
    liveVc.lives = self.lives;
    liveVc.currentIndex = indexPath.row-1;
    [self presentViewController:liveVc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
