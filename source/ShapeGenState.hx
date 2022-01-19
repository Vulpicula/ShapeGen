package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.display.Display.Package;

using flixel.util.FlxSpriteUtil;

class ShapeGenState extends FlxState
{
	// UI related.
	var isDrawing:Bool = true;

	var chosenColour:Int = 0;
	var hideUI = false;
	var quickDraw = true;
	var rainbowMode = false;

	var canvasSprite = new FlxSprite();
	var lineStyle:LineStyle;

	var shapeCenterCoordinate:FlxPoint;
	var shapePointA:FlxPoint;
	var shapePointB:FlxPoint;

	var shapeRadius:Int = 300;
	var shapeSides:Int = 8;

	var drawIterations:Int = 0;

	var drawMode:Int = 0;

	var infoText:FlxText;

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

		// On-screen information.
		infoText = new FlxText(1, 1, 0,
			"([ShapeGen Controls])\n > [C] to toggle colour. \n > [M] to toggle drawing mode.\n > [Q] to disable quick drawing. \n > [R] to toggle RAINBOWS (overwrites [C])." +
			"\n > [+] to increase sides. ([3] to add 3)\n > [-] to decrease sides (min 3). \n > [Shift] to increase radius by 15px (max 450).\n > [Ctrl] to decrease radius by 15px (min 15)." +
			"\n > [ESC] to redraw with changes.\n > \n > [H] to hide this text.",
			16); // Start a timer. Upon each conclusion it resets the timer and draws a line.
		infoText.color = FlxColor.GRAY;
		add(infoText);

		// This is my attempt at emulating what Snap does in a simple way.
		trace("Starting timer...");
		new FlxTimer().start(1 / shapeSides, timerComplete, 0);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (isDrawing == false)
		{
			if (FlxG.keys.anyJustPressed([C]))
			{
				chosenColour++;
				rainbowMode = false;

				trace("chosenColour set to " + chosenColour);
				if (chosenColour > 7)
				{
					chosenColour = 0;
				}
				setLineColour(chosenColour);
				if (quickDraw == true)
				{
					resetCanvas();
				}
			}
			if (FlxG.keys.anyJustPressed([H]))
			{
				trace("Toggling UI.");
				if (hideUI == false)
				{
					remove(infoText);
					hideUI = true;
				}
				else
				{
					add(infoText);
					hideUI = false;
				}
			}
			if (FlxG.keys.anyJustPressed([M]))
			{
				trace("Toggling drawMode.");
				drawMode++;
				if (drawMode > 2)
				{
					drawMode = 0;
				}
				if (quickDraw == true)
				{
					resetCanvas();
				}
			}
			if (FlxG.keys.anyJustPressed([Q]))
			{
				trace("Toggling instantDraw.");
				if (quickDraw == false)
				{
					quickDraw = true;
				}
				else
				{
					quickDraw = false;
				}
				resetCanvas();
			}
			if (FlxG.keys.anyJustPressed([R]))
			{
				if (rainbowMode == false)
				{
					trace("RAINBOWS activated.");
					rainbowMode = true;
				}
				else
				{
					trace("RAINBOWS disabled :(.");
					rainbowMode = false;
				}
				if (quickDraw == true)
				{
					resetCanvas();
				}
			}
			if (FlxG.keys.anyJustPressed([PLUS]))
			{
				shapeSides++;
				if (quickDraw == true)
				{
					resetCanvas();
				}
			}
			if (FlxG.keys.anyJustPressed([THREE]))
			{
				shapeSides += 3;
				if (quickDraw == true)
				{
					resetCanvas();
				}
			}
			if (FlxG.keys.anyJustPressed([MINUS]))
			{
				if (shapeSides > 3)
				{
					shapeSides--;
				}
				if (quickDraw == true)
				{
					resetCanvas();
				}
			}
			if (FlxG.keys.anyJustPressed([SHIFT]))
			{
				if (shapeRadius <= 450)
				{
					shapeRadius += 15;
				}
				if (quickDraw == true)
				{
					resetCanvas();
				}
			}
			if (FlxG.keys.anyJustPressed([CONTROL]))
			{
				if (shapeRadius >= 15)
				{
					shapeRadius -= 15;
				}
				if (quickDraw == true)
				{
					resetCanvas();
				}
			}
			if (FlxG.keys.anyJustPressed([ESCAPE]))
			{
				resetCanvas();
			}
		}
		super.update(elapsed);
	}

	function timerComplete(timer:FlxTimer):Void
	{
		trace("Calling drawNextLine()");
		drawNextLine();

		drawIterations++;
		trace("Iteration: " + drawIterations + "/" + shapeSides);

		if (drawIterations >= shapeSides)
		{
			isDrawing = false;
			timer.destroy();
		}
	}

	function drawNextLine()
	{
		trace("shapePointA = " + shapePointA);
		trace("shapePointB = " + shapePointB);
		if (rainbowMode == true)
		{
			chosenColour++;
			if (chosenColour > 7)
			{
				chosenColour = 1;
			}
			setLineColour(chosenColour);
		}
		if (drawIterations < shapeSides - 1 || drawMode == 1)
		{
			canvasSprite.drawLine(shapePointA.x, shapePointA.y, shapePointB.x, shapePointB.y, lineStyle);
		}
		else
		{
			canvasSprite.drawLine(shapePointA.x, shapePointA.y, shapeCenterCoordinate.x, shapeCenterCoordinate.y - shapeRadius, lineStyle);
		}
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
		canvasSprite = new FlxSprite();
		canvasSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true);
		insert(0, canvasSprite);
		// Removes text, re-adds it at the top of the stack.
		remove(infoText);
		if (hideUI == false)
		{
			insert(1000, infoText);
		}

		// Resets shapePoint location back to the initial bit.
		shapePointA.set(shapeCenterCoordinate.x, shapeCenterCoordinate.y - shapeRadius);
		if (drawMode != 1)
		{
			shapePointB.set(shapePointA.x, shapePointA.y);
			shapePointB.rotate(shapeCenterCoordinate, 360 / shapeSides);
		}
		else
		{
			shapePointB.set(shapePointA.x + shapeRadius, shapePointA.y);
		}
		isDrawing = true;

		// Reset variables.
		drawIterations = 0;

		// Start the timer again.
		if (quickDraw == false)
		{
			new FlxTimer().start(1 / shapeSides, timerComplete, 0);
		}
		else
		{
			new FlxTimer().start(0.1 / shapeSides, timerComplete, 0);
		}
	}

	function setLineColour(colour:Int)
	{
		trace("setLineColour(" + colour + ")");
		if (colour == 0)
		{
			lineStyle.color.setRGB(255, 255, 255);
		}
		else if (colour == 1) // R
		{
			lineStyle.color.setRGB(255, 0, 0);
		}
		else if (colour == 2) // O
		{
			lineStyle.color.setRGB(255, 127, 0);
		}
		else if (colour == 3) // Y
		{
			lineStyle.color.setRGB(255, 255, 0);
		}
		else if (colour == 4) // G
		{
			lineStyle.color.setRGB(0, 255, 0);
		}
		else if (colour == 5) // B
		{
			lineStyle.color.setRGB(0, 0, 255);
		}
		else if (colour == 6) // I
		{
			lineStyle.color.setRGB(75, 0, 130);
		}
		else if (colour == 7) // V
		{
			lineStyle.color.setRGB(148, 0, 211);
		}
	}
}
