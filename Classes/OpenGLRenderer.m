/*
 ////////////////////////////////////////////////////////////////////
 // This example is derived from the Apple OSXGLEssentials example //
 ////////////////////////////////////////////////////////////////////
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "OpenGLRenderer.h"

// Vertices of the triangle
GLfloat posArray[] = {
    -0.5f,  -0.5f,  0.0f,
     0.5f,  -0.5f,  0.0f,
     0.0f,   0.5f,  0.0f
};

#define GetGLError()									\
{														\
	GLenum err = glGetError();							\
	while (err != GL_NO_ERROR) {						\
		NSLog(@"GLError %s set in File:%s Line:%d\n",	\
				GetGLErrorString(err),					\
				__FILE__,								\
				__LINE__);								\
		err = glGetError();								\
	}													\
}

#pragma mark - Private Ivars

@interface OpenGLRenderer ()
{
    GLuint          _vaoName;
    GLuint          _vboName;
    GLKBaseEffect*  _baseEffect;

    GLuint          _viewWidth;
    GLuint          _viewHeight;
}
@end

@implementation OpenGLRenderer

#pragma mark - Overridden Methods

- (id) init
{
	if((self = [super init]))
	{
		NSLog(@"%s %s", glGetString(GL_RENDERER), glGetString(GL_VERSION));
		
		_viewWidth = 100;
		_viewHeight = 100;
		
        // Create a vertex array object (VAO)
        glGenVertexArrays(1, &_vaoName);
        glBindVertexArray(_vaoName);
        
        // create a BaseEffect (it will supply the vertex & fragment shaders)
        _baseEffect = [[GLKBaseEffect alloc] init];
        _baseEffect.useConstantColor = GL_TRUE;
        _baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 0.0, 0.8);
        
        // Create, Bind, Allocate and Load data into a vertex buffer object (VBO)
        glGenBuffers(1, &_vboName);
        glBindBuffer(GL_ARRAY_BUFFER, _vboName);
        glBufferData(GL_ARRAY_BUFFER, sizeof(posArray), posArray, GL_STATIC_DRAW);
        
		// set the clear color
		glClearColor(1.0f, 0.0f, 1.0f, 1.0f);
		
        // Enable simple blending of the image with the background
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glEnable( GL_BLEND );
		
		// Check for errors to make sure all of our setup went ok
		GetGLError();
	}
	return self;
}

#pragma mark - Public Methods

- (void) resizeWithWidth:(GLuint)width AndHeight:(GLuint)height
{
    // adjust the Viewport
	glViewport(0, 0, width, height);
	_viewWidth = width;
	_viewHeight = height;
}

- (void) render
{    
    // prepare the BaseEffect
    [_baseEffect prepareToDraw];
    // clear the buffer
	glClear(GL_COLOR_BUFFER_BIT);
	// enable the vertex data
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	// define the vertex data size & layout
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), NULL);
    // Draw the triangle
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

@end
