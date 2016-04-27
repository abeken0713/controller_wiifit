//
//  racketOpenGL.m
//  WiiScale
//
//  Created by 安部謙太朗 on 2016/04/25.
//  Copyright © 2016年 Dmitri Amariei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "racketOpenGL.h"
#import <OpenGL/gl.h>

@implementation racketOpenGL
- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat*)format
{
    self = [super initWithFrame:frameRect];
    if (self) {
        // initialize
    }
    return self;
}
// xibにViewを配置しているときはinitWithFrameが呼ばれないので注意
- (void)awakeFromNib
{
    NSLog(@"initialize");
}
- (void)drawRect:(NSRect)rect {
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // default background color
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // View Transform
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    // Modeling Transform
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    [self drawScene:0.0f];
    glFlush();
}

- (void)reWrite:(float)x
{
    if (count > 2){
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // default background color
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        [self drawScene:x];
        glFlush();
        //NSLog(@"rewrite");
        count = 0;
    } else{
        count++;
    }
}

- (void)reshape
{
    int width = [self frame].size.width;
    int height = [self frame].size.height;
    // view port transform
    glViewport(0, 0, width, height);
    // projection transform
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity(); // default
}

- (void)drawScene:(float)x
{
    //int w = [self frame].size.width;
    //int h = [self frame].size.height;
    
    glColor3f(1.0f, 1.0f, 1.0f);
    glBegin(GL_QUADS);
    {
        glVertex3f( x + racketWidth/2, racketHeight , 0.0f);
        glVertex3f( x + racketWidth/2, -racketHeight , 0.0f);
        glVertex3f( x - racketWidth/2, -racketHeight , 0.0f);
        glVertex3f( x - racketWidth/2, racketHeight , 0.0f);
    }
    glEnd();
}

@end