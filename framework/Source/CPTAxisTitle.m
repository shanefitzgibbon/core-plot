#import "CPTAxisTitle.h"
#import "CPTExceptions.h"
#import "CPTLayer.h"

/**	@brief An axis title.
 *
 *	The title can be text-based or can be the content of any CPTLayer provided by the user.
 **/
@implementation CPTAxisTitle

-(void)positionRelativeToViewPoint:(CGPoint)point forCoordinate:(CPTCoordinate)coordinate inDirection:(CPTSign)direction
{
	CGPoint newPosition = point;
	CGFloat *value = (coordinate == CPTCoordinateX ? &(newPosition.x) : &(newPosition.y));
	self.rotation = (coordinate == CPTCoordinateX ? M_PI_2 : 0.0);
	CGPoint anchor = CGPointZero;
    
    // Position the anchor point along the closest edge.
    switch ( direction ) {
        case CPTSignNone:
        case CPTSignNegative:
            *value -= self.offset;
			anchor = (coordinate == CPTCoordinateX ? CGPointMake(0.5, 0.0) : CGPointMake(0.5, 1.0));
            break;
        case CPTSignPositive:
            *value += self.offset;
			anchor = (coordinate == CPTCoordinateX ? CGPointMake(0.5, 1.0) : CGPointMake(0.5, 0.0));
            break;
        default:
            [NSException raise:CPTException format:@"Invalid sign in positionRelativeToViewPoint:inDirection:"];
            break;
    }
	
	// Pixel-align the title layer to prevent blurriness
	CPTLayer *content = self.contentLayer;
	CGSize currentSize = content.bounds.size;
	
	content.anchorPoint = anchor;

	if ( self.rotation == 0.0 ) {
		newPosition.x = round(newPosition.x) - round(currentSize.width * anchor.x) + (currentSize.width * anchor.x);
		newPosition.y = round(newPosition.y) - round(currentSize.height * anchor.y) + (currentSize.height * anchor.y);
	}
	else {
		newPosition.x = round(newPosition.x);
		newPosition.y = round(newPosition.y);
	}
	content.position = newPosition;
    content.transform = CATransform3DMakeRotation(self.rotation, 0.0, 0.0, 1.0);
    
    [self.contentLayer setNeedsDisplay];
}

@end
