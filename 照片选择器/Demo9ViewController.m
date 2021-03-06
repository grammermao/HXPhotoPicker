//
//  Demo9ViewController.m
//  照片选择器
//
//  Created by 洪欣 on 2018/2/14.
//  Copyright © 2018年 洪欣. All rights reserved.
//

#import "Demo9ViewController.h"
#import "Demo9ViewCell.h"
#import "Demo9Model.h"
#import "HXPhotoPicker.h"
#import "HXPhotoSubViewCell.h"
@interface Demo9ViewController ()<UITableViewDelegate,UITableViewDataSource, UIViewControllerPreviewingDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *uploadArray;
@property (nonatomic, strong) NSMutableArray *waitArray;
@property (nonatomic, strong) NSMutableArray *completeArray;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (weak, nonatomic) id<UIViewControllerPreviewing> previewingContext;
@end

@implementation Demo9ViewController

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        Demo9Model *model = [[Demo9Model alloc] init];
        if (i == 0) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"QQ空间视频_20180301091047" withExtension:@"mp4"];
//            HXCustomAssetModel *assetModel1 = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539156782143&di=dc52a95270831d8bc10e5bf78f6626b4&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fzhidao%2Fwh%253D450%252C600%2Fsign%3D038e2a1cacc27d1ea57333c02ee58158%2Fe61190ef76c6a7ef19aa309ef5faaf51f2de66fe.jpg"] selected:YES];
            HXCustomAssetModel *assetModel1 = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539156872167&di=93cd047350dfc7a60fa9e89e30079b25&imgtype=0&src=http%3A%2F%2Fpic.9ht.com%2Fup%2F2018-5%2F15252310743961744.gif"] networkThumbURL:[NSURL URLWithString:@"https://goss.veer.com/creative/vcg/veer/1600water/veer-129342703.jpg"] selected:YES];
            
            HXCustomAssetModel *assetModel2 = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:@"https://goss.veer.com/creative/vcg/veer/1600water/veer-129342703.jpg"]  networkThumbURL:nil selected:YES];
            
            HXCustomAssetModel *assetModel3 = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3935625616,3616422245&fm=27&gp=0.jpg"] selected:YES];
            HXCustomAssetModel *assetModel4 = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539156831133&di=2f917f5242bcd54aeb16e74c19732b16&imgtype=0&src=http%3A%2F%2Fimg.bqatj.com%2Fimg%2F1650c759c7315250.jpg"] selected:YES];
            HXCustomAssetModel *assetModel5 = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539156872167&di=93cd047350dfc7a60fa9e89e30079b25&imgtype=0&src=http%3A%2F%2Fpic.9ht.com%2Fup%2F2018-5%2F15252310743961744.gif"] selected:YES];
            HXCustomAssetModel *assetModel6 = [HXCustomAssetModel assetWithLocalVideoURL:url selected:YES];
            
            model.customAssetModels = @[assetModel1, assetModel2, assetModel3, assetModel4, assetModel5, assetModel6];
        }
        [self.dataArray addObject:model];
    }
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hxNavigationBarHeight, self.view.hx_w, self.view.hx_h - hxNavigationBarHeight) style:UITableViewStyleGrouped];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
        if ((NO)) {
#endif
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[Demo9ViewCell class] forCellReuseIdentifier:@"CellId"];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写入" style:UIBarButtonItemStyleDone target:self action:@selector(didRightBtn)];
        
    if ([self respondsToSelector:@selector(traitCollection)]) {
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
            }
        }
    }
}
- (void)didRightBtn {
    self.completeArray = [NSMutableArray array];
    self.waitArray = [NSMutableArray arrayWithArray:self.dataArray];
    [self.view hx_showLoadingHUDText:@"写入中"];
    [self startUpload];
}
- (void)startUpload {
    if (self.waitArray.count == 0) {
        [self.view hx_handleLoading];
        NSSLog(@"全部写入完毕");
        return;
    }
    __block Demo9Model *model = self.waitArray.firstObject;
    [self.waitArray removeObjectAtIndex:0];
    __weak typeof(self) weakSelf = self;
    if (model.endSelectedList.count > 0) {
        [self.toolManager writeSelectModelListToTempPathWithList:model.endSelectedList requestType:0 success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
            NSSLog(@"\n第%ld个cell写入完成\n%@",[weakSelf.dataArray indexOfObject:model],allURL);
            model.photoUrls = allURL;
            [weakSelf.completeArray addObject:model];
            [weakSelf startUpload];
        } failed:^{
            [weakSelf.view hx_handleLoading];
            [weakSelf.view hx_showImageHUDText:[NSString stringWithFormat:@"第%ld个cell写入失败",[weakSelf.dataArray indexOfObject:model]]];
        }];
    }else {
        [self.completeArray addObject:model];
        [self startUpload];
    }
}
#pragma mark - < UITableViewDataSource >
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Demo9ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    Demo9Model *model = self.dataArray[indexPath.section];
    model.section = indexPath.section;
    cell.model = model;
    HXWeakSelf
    [cell setPhotoViewChangeHeightBlock:^(UITableViewCell *mycell) {
        NSIndexPath *myIndexPath = [weakSelf.tableView indexPathForCell:mycell];
        if (myIndexPath) {
            [weakSelf.tableView reloadRowsAtIndexPaths:@[myIndexPath] withRowAnimation:0];
        }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Demo9Model *model = self.dataArray[indexPath.section];
    return model.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
    
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (!indexPath) {
        return nil;
    }
    Demo9ViewCell *cell = (Demo9ViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    HXPhotoSubViewCell *view = [cell.photoView previewingContextViewWithPoint:[self.tableView convertPoint:location toView:cell]];
    if (!view) {
        return nil;
    }
    CGRect frame = [cell convertRect:view.frame fromView:cell.photoView];
    frame = [self.tableView convertRect:frame fromView:cell];
    previewingContext.sourceRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width);
    
    HXPhotoModel *model = view.model;
    HXPhoto3DTouchViewController *vc = [[HXPhoto3DTouchViewController alloc] init];
    vc.model = model;
    vc.indexPath = indexPath;
    vc.image = view.imageView.image;
    vc.preferredContentSize = model.previewViewSize;
    HXWeakSelf
    vc.downloadImageComplete = ^(HXPhoto3DTouchViewController *vc, HXPhotoModel *model) {
        if (!model.loadOriginalImage) {
            Demo9ViewCell *myCell = (Demo9ViewCell *)[weakSelf.tableView cellForRowAtIndexPath:vc.indexPath];
            NSIndexPath *myIndexPath = [myCell.photoView currentModelIndexPath:model];
            HXPhotoSubViewCell *subCell = (HXPhotoSubViewCell *)[myCell.photoView.collectionView cellForItemAtIndexPath:myIndexPath];
            [subCell resetNetworkImage];
        }
    };
    vc.previewActionItemsBlock = ^NSArray<id<UIPreviewActionItem>> *{
        
        UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            [weakSelf.view hx_showImageHUDText:@"点赞成功!"];
            NSSLog(@"赞!!!");
        }];
        UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"评论" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            [weakSelf.view hx_showImageHUDText:@"评论成功!"];
            NSSLog(@"评论!!!");
        }];
        UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            [weakSelf.view hx_showImageHUDText:@"收藏成功!"];
            NSSLog(@"收藏!!!");
        }];
        return @[action1, action2, action3];
    };
    return vc;
}
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    HXPhoto3DTouchViewController *vc = (HXPhoto3DTouchViewController *)viewControllerToCommit;
    Demo9ViewCell *cell = (Demo9ViewCell *)[self.tableView cellForRowAtIndexPath:vc.indexPath];
    [cell.photoView jumpPreviewViewControllerWithModel:vc.model];
}
    
- (void)dealloc {
    if (self.previewingContext) {
        [self unregisterForPreviewingWithContext:self.previewingContext];
    }
    NSSLog(@"dealloc");
}
@end
