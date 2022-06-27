#import "YBPopupMenuPath+Cxsdcontent.h"
@implementation YBPopupMenuPath (Cxsdcontent)
+ (BOOL)yb_maskLayerWithRectRectcornerCornerradiusArrowwidthArrowheightArrowpositionArrowdirectionCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 2 == 0;
}
+ (BOOL)yb_bezierPathWithRectRectcornerCornerradiusBorderwidthBordercolorBackgroundcolorArrowwidthArrowheightArrowpositionArrowdirectionCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 36 == 0;
}

@end
