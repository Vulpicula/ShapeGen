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
	var isDrawing:Bool = true;

	var canvasSprite = new FlxSprite();
	var lineStyle:LineStyle;

	var shapeCenterCoordinate:FlxPoint;
	var shapePointA:FlxPoint;
	var shapePointB:FlxPoint;

	var shapeRadius:Int = 300;
	var shapeSides:Int = 200;

	var drawIterations:Int = 0;

	var drawMode:Int = 2;

	override public function create()
	{
		canvasSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true); // Creates a background sprite for us to draw on.
		add(canvasSprite); // Draws it.

		lineStyle = {color: FlxColor.WHITE, thickness: 1};

		trace("Setting shapePoints...");
		shapeCenterCoordinate = new FlxPoint(FlxG.width / 2, FlxG.height / 2);
		shapePointA = new FlxPoint(shapeCenterCoordinate.x, shapeCenterCoordinate.y - shapeRadius); // Defines position of both.
		shapePointB = new FlxPoint(shapePointA.x, shapePointA.y);
		shapePointB.rotate(shapeCenterCoordinate, 360 / shapeSides); // Rotates B.

		// Start a timer. Upon each conclusion it resets the timer and draws a line.
		// This is my attempt at emulating what Snap does in a simple way.
		trace("Starting timer...");
		new FlxTimer().start(2 / shapeSides, timerComplete, 0);

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

		drawIterations++;
		trace("Iteration: " + drawIterations + "/" + shapeSides);

		if (shapePointA.x >= 720 && shapePointA.y >= 150 && drawIterations >= shapeSides) // Requires two passed checks, otherwise it ends early for some reason.
		{
			isDrawing = false;
			timer.destroy();
		}
	}

	function drawNextLine()
	{
		trace("shapePointA = " + shapePointA);
		trace("shapePointB = " + shapePointB);
		canvasSprite.drawLine(shapePointA.x, shapePointA.y, shapePointB.x, shapePointB.y);
		// Rotate both points by the shapeAngle.
		if (drawMode != 2)
		{
			shapePointA.rotate(shapeCenterCoordinate, 360 / shapeSides);
			shapePointB.rotate(shapeCenterCoordinate, 360 / shapeSides);
		}
		else
		{
			shapePointB.rotate(shapeCenterCoordinate, 360 / shapeSides);
		}
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

		// Resets shapePoint location back to the initial bit.
		shapePointA.set(shapeCenterCoordinate.x, shapeCenterCoordinate.y - shapeRadius);
		if (drawMode != 1)
		{
			shapePointB.set(shapePointA.x, shapePointA.y);
		}
		else
		{
			shapePointB.set(shapeCenterCoordinate.x + shapeRadius);
		}
		isDrawing = true;
	}
}
