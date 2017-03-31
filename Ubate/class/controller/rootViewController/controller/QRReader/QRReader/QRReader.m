//
//  QRReader.m
//  Ubate
//
//  Created by sunbin on 2017/2/9.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "QRReader.h"
#import <AVFoundation/AVFoundation.h>

#import "YScanPay.h"
#import "YBonline.h"
#import "ScanResultToUrl.h"
#import "ScanResultToText.h"


@interface QRReader ()<UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,CALayerDelegate ,AVCaptureMetadataOutputObjectsDelegate>
{
    UIImagePickerController *imagePicker;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanViewWidth;
@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UILabel *scanResult;

@property (nonatomic,strong) UIImageView *scanImageView;

@property ( strong , nonatomic ) AVCaptureDevice            * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput       * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput    * output;
@property ( strong , nonatomic ) AVCaptureSession           * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic,strong) CALayer *maskLayer;/** 非扫描区域的蒙版 */


@end

@implementation QRReader
{
    YUserInfo *userInfor;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupScanQRCode];
    [_session startRunning];
    [self startAnimate];
    
}
#pragma mark - <lazy - 懒加载>
/**
 *  懒加载设备
 */
- (AVCaptureDevice *)device {
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
/**
 *  懒加输入源
 */
- (AVCaptureDeviceInput *)input {
    if (!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

/**
 *  懒加载输出源
 */
- (AVCaptureMetadataOutput *)output {
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
    }
    return _output;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    userInfor = [YConfig myProfile];
    [self initView];
    
}
- (void)initView{
    [self navigationLeft];
}


- (void)navigationLeft{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(choicePhoto)];
}

- (void)choicePhoto{
    
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)loadData{}

- (void)dealloc{
    if (_preview) {
        [_preview removeFromSuperlayer];
    }
    if (self.maskLayer) {
        self.maskLayer.delegate = nil;
    }
}

- (void)startAnimate {
    CGFloat scanImageViewX = 0;
    CGFloat scanImageViewY = 0;
    CGFloat scanImageViewW = self.scanViewWidth.constant;
    CGFloat scanImageViewH = 7;
    NSLog(@"scanImageViewX:%f,scanImageViewY:%f,scanImageViewW:%f,scanImageViewH:%f",scanImageViewX,scanImageViewY,scanImageViewW,scanImageViewH);
    
    if (!_scanImageView) {
        _scanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanLine"]];
        [self.scanView addSubview:_scanImageView];
    }
    
    _scanImageView.frame = CGRectMake(scanImageViewX, scanImageViewY, scanImageViewW, scanImageViewH);
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        _scanImageView.frame = CGRectMake(scanImageViewX, scanImageViewY + self.scanViewHeight.constant, scanImageViewW, scanImageViewH);
    } completion:^(BOOL finished) {
        if (finished) {
            _scanImageView.frame = CGRectMake(scanImageViewX, scanImageViewY, scanImageViewW, scanImageViewH);
        }
    }];
}

- (void)setupScanQRCode {
    // 1、创建设备会话对象，用来设置设备数据输入
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset: AVCaptureSessionPresetHigh];    //高质量采集
    
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    // 设置条码类型为二维码
    [self.output setMetadataObjectTypes:self.output.availableMetadataObjectTypes];
    
    // 设置扫描范围
    [self setOutputInterest];
    
    // 3、实时获取摄像头原始数据显示在屏幕上
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    self.view.layer.backgroundColor = [[UIColor blackColor] CGColor];
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    self.maskLayer = [[CALayer alloc]init];
    self.maskLayer.frame = self.view.layer.bounds;
    self.maskLayer.delegate = self;
    [self.view.layer insertSublayer:self.maskLayer above:_preview];
    [self.maskLayer setNeedsDisplay];
}
- (void)setOutputInterest {
    CGSize size = self.view.bounds.size;
    CGFloat scanViewWidth = 240;
    CGFloat scanViewHeight = 240;
    CGFloat scanViewX = (size.width - scanViewWidth) / 2;
    CGFloat scanViewY = (size.height - scanViewHeight) / 2;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _output.rectOfInterest = CGRectMake((scanViewY + fixPadding) / fixHeight,
                                            scanViewX / size.width,
                                            scanViewHeight / fixHeight,
                                            scanViewWidth / size.width);
    } else {
        CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _output.rectOfInterest = CGRectMake(scanViewY / size.height,
                                            (scanViewX + fixPadding) / fixWidth,
                                            scanViewHeight / size.height,
                                            scanViewWidth / fixWidth);
    }
}
- (void)haveOnline{
    [_session startRunning];[self startAnimate];
}

#pragma mark - <CALayerDelegate - 图层的代理方法>
/**
 *   蒙板生成,需设置代理，并在退出页面时取消代理
 */
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    if (layer == self.maskLayer) {
        UIGraphicsBeginImageContextWithOptions(self.maskLayer.frame.size, NO, 1.0);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor);
        CGContextFillRect(ctx, self.maskLayer.frame);
        CGRect scanFrame = [self.view convertRect:self.scanView.frame fromView:self.scanView.superview];
        CGContextClearRect(ctx, scanFrame);
    }
}





#pragma mark - <AVCaptureMetadataOutputObjectsDelegate - 扫描二维码的回调方法>
/**
 *  当添加商家为上线后 扫码就只能支付的
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *metadataObjectValue;
    [_scanView showLoading:@"正在加载"];
    if ([metadataObjects count ] > 0 ) {
        //当扫描到数据时，停止扫描 扫描声音
        [ _session stopRunning ];
        //        [NHUtils playBeep];
        //将扫描的线从父控件中移除
        [_scanImageView removeFromSuperview];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        metadataObjectValue = metadataObject.stringValue ;
    }
    WEAKSELF;
    BOOL isTemp = [NHUtils isBlankString:metadataObjectValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isTemp) {
        }else{
            [weakSelf AnalyticalData:metadataObjectValue curretCtl:weakSelf];
        }
    });
}

- (void)AnalyticalData:(NSString *)content curretCtl:(QRReader*)weakSelf{

    NSArray *ary = [content componentsSeparatedByString:@" "];
    
    NSString *encryptDate = [ary lastObject];
    NSString *decodeData=IF_NULL_TO_STRING([encryptDate aes256_decrypt:AES256_KEY]);//解密后的数据
    //bug 当无间隔字符串操作
    //1 判断是否解密成功
    if ([weakSelf isBlankString:decodeData]) {
        //1.1解密失败 == 1.1.1网页 或 1.1.2其他页面
        if ([content isValidUrl]) {
            ScanResultToUrl *scanResultToUrl = [[ScanResultToUrl alloc] initWithNibName:@"ScanResultToUrl" bundle:nil];
            scanResultToUrl.contans = content;
            [weakSelf.navigationController pushViewController:scanResultToUrl animated:YES];
        }else{
            ScanResultToText *scanResultToText = [[ScanResultToText alloc] initWithNibName:@"ScanResultToText" bundle:nil];
            scanResultToText.contans = content;
            [weakSelf.navigationController pushViewController:scanResultToText animated:YES];
        }
        
    }else{
        
        //1.2解密成功 判断是用户 还是商户版 都可以添加上线  但支付只能为商户
        //2判断 对方是2.1用户 还是2.2商户
        NSArray *ary = [decodeData componentsSeparatedByString:@" "];
        NSUInteger count = ary.count;
        NSString *uidMake = [ary firstObject];
        //判断条件 只要其中一项为空就支付isAddOnline=no
        BOOL isAddOnline = [NHUtils isBlankString:userInfor.sponsorID] && [NHUtils isBlankString:userInfor.storeID];
        //2.1用户
        if (count == 2) {
            YBonline *onLine = kVCFromSb(@"YBonlineID", @"QRReader");
            onLine.onlineMethod = 0;
            onLine.uid = uidMake;
            onLine.isAddOnLine = isAddOnline;
            [self.navigationController pushViewController:onLine animated:YES];
        }else if (count == 3) {
            if (isAddOnline) {
                YBonline *onLine = kVCFromSb(@"YBonlineID", @"QRReader");
                onLine.onlineMethod = 1;
                onLine.uid = uidMake;
                [self.navigationController pushViewController:onLine animated:YES];
                
                return;
            }else{
                YScanPay *scanPay = kVCFromSb(@"ScanPayID", @"QRReader");
                scanPay.store_id = [uidMake integerValue];
                [self.navigationController pushViewController:scanPay animated:YES];
                return;
            }
        }else{
            //1.1解密失败 == 1.1.1网页 或 1.1.2其他页面
            if ([content isValidUrl]) {
                ScanResultToUrl *scanResultToUrl = [[ScanResultToUrl alloc] initWithNibName:@"ScanResultToUrl" bundle:nil];
                scanResultToUrl.contans = content;
                [weakSelf.navigationController pushViewController:scanResultToUrl animated:YES];
            }else{
                ScanResultToText *scanResultToText =[[ScanResultToText alloc] initWithNibName:@"ScanResultToText" bundle:nil];
                scanResultToText.contans = content;
                [weakSelf.navigationController pushViewController:scanResultToText animated:YES];
            }
        
        }
    }
}


#pragma mark - ImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *content = @"" ;
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData  *imageData = UIImagePNGRepresentation(pickImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray    *feature = [detector featuresInImage:ciImage];
    
    for (CIQRCodeFeature *result in feature) {
        content = result.messageString;
    }
    __weak typeof(self) weakSelf = self;
    BOOL isTemp = [NHUtils isBlankString:content];
    
    [picker dismissViewControllerAnimated:NO completion:^{
        if (isTemp) {
            NSLog(@"数据为空");
        }else{
           // [NHUtils playBeep];
            [weakSelf AnalyticalData:content curretCtl:weakSelf];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
