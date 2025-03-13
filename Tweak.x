//经调试，某音评论区实况图片会先缓存到tmp文件夹里
#import <Photos/Photos.h>
//全局变量获取缓存路径
static NSURL *livePhotoimageURL;
static NSURL *livePhotovideoURL;

%hook PHLivePhoto
-(NSURL *)imageURL {
livePhotoimageURL = %orig;
return livePhotoimageURL;
}

-(NSURL *)videoURL {
livePhotovideoURL = %orig;
return livePhotovideoURL;
}
%end
//这里用官方的评论区双击放大图片的手势，你也可以搞个悬浮按钮等等
%hook AWECommentMediaFeedImageCell
- (void)doubleTapToZoomWithGes:(id)arg1 {
//LivePhotos实际上就是一个mov视频文件和一个jpg图片文件，上面咱们已经通过全局变量获取到这俩文件的缓存路径，直接保存即可
[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
    [request addResourceWithType:PHAssetResourceTypePhoto fileURL:livePhotoimageURL options:nil];
    [request addResourceWithType:PHAssetResourceTypePairedVideo fileURL:livePhotovideoURL options:nil];
} completionHandler:^(BOOL success, NSError * _Nullable error) {
    if (success) {
                  //这里写保存成功提示
    } else {
                     //这里写保存失败提示
    }
}];
}
%end
/*
至于首页实况图片集，没发现缓存，可自行保存视频、图片，再调用
[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
    [request addResourceWithType:PHAssetResourceTypePhoto fileURL:图片地址 options:nil];
    [request addResourceWithType:PHAssetResourceTypePairedVideo fileURL:视频地址 options:nil];
} completionHandler:^(BOOL success, NSError * _Nullable error) {
    if (success) {
                  //这里写保存成功提示
    } else {
                     //这里写保存失败提示
    }
}];
比较麻烦，靠你们自己了
*/
