//
//  imgsViewController.m
//  glgl
//
//  Created by udspj on 13-8-9.
//
//

#import "imgsViewController.h"

@interface imgsViewController ()

@end

@implementation imgsViewController

@synthesize context;
@synthesize effect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    GLKView *glview = (GLKView *)self.view;
    glview.context = context;
    glview.delegate = self;
    
    float ratio = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    projectionmatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), ratio, 0.1f, 1000.0f);
    
    picarray = [[NSArray alloc] initWithObjects:@"a.jpg",@"b.jpg",@"c.jpg",@"d.jpg",@"k.jpg",@"l.jpg",@"m.jpg",@"e.jpg",@"f.png",@"g.png",@"h.jpg",@"i.jpg",@"j.jpg", nil];
    picnum = [picarray count];
    
    imgarray = [[NSMutableArray alloc] initWithCapacity:picnum];
    midnum = 0;
    dis = 1.0f;
    movedis = 0;
    isleft = NO;
    
    [self buildPictures];
}

-(void)buildPictures
{
    for (i = 0; i < picnum; i ++)
    {
        glimg *img = [[glimg alloc] initWithImg:[picarray objectAtIndex:i] projection:projectionmatrix];
        img.position = GLKVector2Make(i * dis, 0);
        if (i == midnum)
        {
            img.rotateY = 0;
        }
        else
        {
            img.rotateY = -1;
        }
        img.velocity = GLKVector2Make(movedis, 0);
        [imgarray addObject:img];
    }
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    i = 0;
    while (i < midnum)
    {
        [[imgarray objectAtIndex:i] render];
        i++;
    }
    i = picnum - 1;
    while (i > midnum)
    {
        [[imgarray objectAtIndex:i] render];
        i--;
    }
    [[imgarray objectAtIndex:midnum] render];
}

- (void)update
{
    for (glimg *img in imgarray)
    {
        img.velocity = GLKVector2Make(movedis, 0);
        [img update:self.timeSinceLastUpdate];
    }
    movedis *= 0.9;
    NSLog(@"movedis %f",movedis);
    if (isleft)
    {
        if (midnum == picnum-1 || !change)
        {
            return;
        }
        [[imgarray objectAtIndex:midnum] setRotateY:1];
        [[imgarray objectAtIndex:midnum+1] setRotateY:0];
        midnum ++;
        change = NO;
    }
    else
    {
        if (midnum == 0 || !change)
        {
            return;
        }
        [[imgarray objectAtIndex:midnum] setRotateY:-1];
        [[imgarray objectAtIndex:midnum-1] setRotateY:0];
        midnum --;
        change = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *Touch in touches)
    {
        touchpoint = [Touch locationInView:Touch.view];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(movedis > 0.000001 || movedis < -0.000001)
    {
        return;
    }
    CGPoint touch;
    for (UITouch *Touch in touches)
    {
        touch = [Touch locationInView:Touch.view];
    }
    
    if ((touch.x < touchpoint.x && midnum == picnum-1 && movedis < 0.000001) || (touch.x > touchpoint.x && midnum == 0 && movedis > -0.000001))
    {
        return;
    }

    if (touch.x > touchpoint.x)
    {
        movedis = 0.1/(1-pow(0.9, 50));
        isleft = NO;
        change = YES;
    }
    else
    {
        movedis = -0.1/(1-pow(0.9, 50));
        isleft = YES;
        change = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
