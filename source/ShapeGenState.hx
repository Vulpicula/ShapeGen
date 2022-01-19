package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

class ShapeGenState extends FlxState
{
	var canvasSprite = new FlxSprite();
	var lineStyle:LineStyle;

	var shapeCenterCoordinate:FlxPoint;
	var shapePointA:FlxPoint;
	var shapePointB:FlxPoint;

	var shapePointAX:Float;
	var shapePointAY:Float;
	var shapePointBX:Float;
	var shapePointBY:Float;
	var shapeRadius:Int = 100;
	var shapeSides:Int = 4;

	override public function create()
	{
		canvasSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true); // Creates a background sprite for us to draw on.
		add(canvasSprite); // Draws it.

		lineStyle = {color: FlxColor.WHITE, thickness: 1};

		trace("Setting shapePoint thingymajiggers...");
		shapeCenterCoordinate.set(FlxG.width / 2, FlxG.height / 2);
		shapePointA.set(shapeCenterCoordinate.x, shapeCenterCoordinate.y - shapeRadius);
		shapePointB.set(shapeCenterCoordinate.x + shapeRadius, shapeCenterCoordinate.y);

		// Start a timer. Upon each conclusion it resets the timer and draws a line.
		// This is my attempt at emulating what Snap does in a simple way.
		new FlxTimer().start(0.1, timerComplete, shapeSides);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function timerComplete(timer:FlxTimer):Void
	{
		trace("Calling drawNextLine()");
		drawNextLine();
	}

	function drawNextLine()
	{
		canvasSprite.drawLine(shapePointAX, shapePointAY, shapePointBX, shapePointBY);
		// A -> B now drawn, set A to B, find new B.
		shapePointAX = shapePointBX;
		shapePointAY = shapePointBY;
	}

	function resetCanvas()
	{
		if (canvasSprite != null)
		{
			canvasSprite.destroy(); // Don't destroy this if it doesn't actually exist.
		}
		// Remake sprite.
		canvasSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true);
		add(canvasSprite);
	}
}
