//
//  ViewController.m
//  SelectFiles
//
//  Created by zhw_mac on 2020/1/15.
//  Copyright © 2020 zhw_mac. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import "JBCollectionViewCell.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) NSMutableArray *selectArray;//保存选择的附件
@property (nonatomic ,strong) NSMutableArray *saveNameArray;//保存选择的附件名称
@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.selectArray = [NSMutableArray array];
    self.saveNameArray = [NSMutableArray array];
    
    [self initCollectinView];
}

//初始化collectionView
-(void)initCollectinView{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 110, 60, 20)];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor blackColor];
    label.text = @"附件";
    [self.view addSubview:label];
    
    
    CGFloat _itemWH;
    CGFloat _margin;
    
    _margin = 3;
    _itemWH = (self.view.bounds.size.width - 2 * _margin - 3) / 3 - _margin;
    
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.itemSize = CGSizeMake((SCREEN_WIDTH - 50)/ 3, (SCREEN_WIDTH - 50)/ 3 + 15);
    flowLayOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, (_itemWH -5) * 2 + 40) collectionViewLayout:flowLayOut];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[JBCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectArray.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
    cell.imagev.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 50)/ 3 - 20, (SCREEN_WIDTH - 50)/ 3-15);
    cell.deleteButton.frame = CGRectMake((SCREEN_WIDTH - 50)/ 3 - 20, -10, 20, 20);
 
    if (indexPath.row == self.selectArray.count) {
        //默认做多选4个附件
        if (self.selectArray.count >=4) {
            cell.imagev.hidden = YES;
            cell.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled = YES;
            cell.imagev.hidden = NO;
            cell.imagev.image = [UIImage imageNamed:@"addImage"];
        }
        cell.contentLab.text = @"";
        cell.deleteButton.hidden = YES;
    
    } else {
        cell.userInteractionEnabled = YES;
        cell.imagev.hidden = NO;
        NSObject *obj = self.selectArray[indexPath.row];
       
            //  cell.playImage.hidden = YES;
            NSLog(@"选择的类型 === %@",obj);
            NSURL *url = (NSURL *)obj;
            NSString *typeStr = [NSString stringWithFormat:@"%@", url];
            
            //显示附件内容
            if (self.saveNameArray.count) {
                NSString *str = self.saveNameArray[indexPath.row];
                cell.contentLab.text = str;
            }
        
            if ([typeStr containsString:@"pdf"])
            {
                cell.imagev.image = [UIImage imageNamed:@"FJpdf"];
                
            } if ([typeStr containsString:@"numbers"] || [typeStr containsString:@"xlsx"])
            {
                cell.imagev.image = [UIImage imageNamed:@"FJxlsx"];
                
            } if ([typeStr containsString:@"docx"])
            {
                cell.imagev.image = [UIImage imageNamed:@"FJword"];
                
            } if ([typeStr containsString:@"txt"])
            {
                cell.imagev.image = [UIImage imageNamed:@"FJtxt"];
                
            } if ([typeStr containsString:@"pptx"])
            {
                cell.imagev.image = [UIImage imageNamed:@"FJpptx"];
            }
        
           cell.deleteButton.hidden = NO;
            
        }
        
    
        cell.deleteButton.tag = 100 + indexPath.row;
    
      //删除按钮点击方法
      [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击加号添加附件
    if (indexPath.row == self.selectArray.count)
    {
        [self openFileAndSlectFile];
        
    } else {
#pragma mark ======= 预览附件 =======
            //预览文件
             UIDocumentInteractionController *documentVC= [UIDocumentInteractionController interactionControllerWithURL:self.selectArray[indexPath.row]];
              documentVC.delegate=self;
                
            if ([documentVC presentPreviewAnimated:YES])
                {
                    NSLog(@"打开成功");
                }
            else
                {
                    NSLog(@"打开失败");
                }
        }
    
}

//删除附件方法
- (void)deletePhotos:(UIButton *)sender{
    
    [self.selectArray removeObjectAtIndex:sender.tag - 100];
    [self.saveNameArray removeObjectAtIndex:sender.tag - 100];
  
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-100 inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}


//选择文件,打开文件app
-(void)openFileAndSlectFile{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *fileAction = [UIAlertAction actionWithTitle:@"选择文件" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //制定文件类型
        NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
        
        UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
        documentPickerViewController.delegate = self;
        documentPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:documentPickerViewController animated:YES completion:nil];
        
    }];
    
    [fileAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alertVC addAction:fileAction];
    
  
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertVC animated:true completion:nil];
    
}


#pragma mark - 选择文件代理方法
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    fileName = [fileName stringByRemovingPercentEncoding];
    NSLog(@"选择的文件名称=== %@",fileName);
    
    BOOL fileUrlAuthozied = [url startAccessingSecurityScopedResource];
    if(fileUrlAuthozied){
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        // __block NSData *fileData;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            //保存文件地址
            [self.selectArray addObjectsFromArray:@[newURL]];
            //保存文件名称
            [self.saveNameArray addObjectsFromArray:@[fileName]];
            
            [self.collectionView reloadData];
        }];
        [url stopAccessingSecurityScopedResource];
        
    }else{
        //Error handling
    }
}


#pragma mark =======  打开文件相关代理方法 ======
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
       return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
       return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
        return self.view.frame;
}







@end
