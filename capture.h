#import <AVFoundation/AVFoundation.h>

@interface capture:NSObject {

}

@property (nonatomic, assign) NSString *filepath;
@property(nonatomic, assign) bool mirror;
@property (nonatomic, assign) BOOL front;
@property(nonatomic, assign) bool landscape;
@property(nonatomic, assign) int quality;

@property (nonatomic,strong) AVCaptureSession *session;
@property (readwrite, retain) AVCaptureStillImageOutput *stillImageOutput;

- (AVCaptureDevice *)frontFacingCameraIfAvailable;
- (AVCaptureDevice *)backFacingCameraIfAvailable;

- (void)setupCaptureSession;
- (void)captureWithBlock:(void(^)(UIImage* block))block;
@end

