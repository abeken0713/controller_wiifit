//
//  racketOpenGL.h
//  WiiScale
//
//  Created by 安部謙太朗 on 2016/04/25.
//  Copyright © 2016年 Dmitri Amariei. All rights reserved.
//

#ifndef racketOpenGL_h
#define racketOpenGL_h

#import "MyOpenGLView.h"

@interface racketOpenGL : NSOpenGLView{
    int count;  // in order to reduce OpengGL drawing
}

- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat*)format;
- (void)awakeFromNib;
- (void)drawRect:(NSRect)rect;
- (void)reWrite:(float)x;
- (void)reshape;
- (void)drawScene:(float)x;
@end



#endif /* racketOpenGL_h */
