//a

import flixel.math.FlxRect;
import funkin.backend.MusicBeatTransition;
import StringTools;

static var prevGameBitmap:BitmapData = null;
function new() {
    FlxG.save.data.transitionTypeName ??= "default";

    if (StringTools.trim(MusicBeatTransition.script) == "")
        MusicBeatTransition.script = "data/scripts/Powerpoint";
}

function destroy() {
    prevGameBitmap = null;
}

static var transitionNames = ["Default", "Instant", "Uncover", "Fly Through", "Scale", "Spin", "Wipe"];
static function transitionType(_prevStateSprite:FlxSprite, _finish, ?type:String, ?time:Float, ?extras:Dynamic) {
    var finish = _finish;
    var prevStateSprite = _prevStateSprite;

    type ??= "uncover";
    time ??= 0.5;
    extras ??= {};
    switch (type.toLowerCase()) {
        case "uncover":
            var goLeft = (extras?.left ?? false);
            var goRight = (extras?.right ?? false) && !goLeft;
            var goTop = (extras?.up ?? false);
            var topBottom = (extras?.down ?? false) && !goTop;
            var x = 0;
            var y = 0;

            if (goLeft) x = -prevStateSprite.width - 5;
            else if (goRight) x = FlxG.width + 5;

            if (goTop) y = -prevStateSprite.height - 5;
            else if (topBottom) y = FlxG.height + 5;
            FlxTween.tween(prevStateSprite, {x: x, y: y}, time, {ease: FlxEase.quadIn, onComplete: finish});
        case "fly through":
            var targetScale = (extras?.out ?? false) ? 0.5 : 2;
            var easeType = (extras?.out ?? false) ? FlxEase.quadIn : FlxEase.quadInOut;
            FlxTween.tween(prevStateSprite, {alpha: 0}, time, {ease: easeType, onComplete: finish});
            FlxTween.tween(prevStateSprite.scale, {x: targetScale, y: targetScale}, time, {ease: easeType});
        case "scale":
            FlxTween.tween(prevStateSprite.scale, {x: 0, y: 0}, time, {ease: FlxEase.quadIn, onComplete: finish});
        case "spin":
            var angle = 360;
            if (FlxG.random.bool(50)) angle *= -1;
            FlxTween.tween(prevStateSprite, {angle: angle}, time, {ease: FlxEase.cubeIn, onComplete: finish});
            FlxTween.tween(prevStateSprite.scale, {x: 0, y: 0}, time, {ease: FlxEase.quadIn});
        case "wipe":
            prevStateSprite.clipRect = new FlxRect(0, 0, prevStateSprite.width, prevStateSprite.height);
            // var goLeft = (extras?.left ?? false);
            // var goRight = (extras?.right ?? false) && !goLeft;
            // var goTop = (extras?.up ?? false);
            // var topBottom = (extras?.down ?? false) && !goTop;
            // var targetWidth = prevStateSprite.width;
            // var targetHeight = prevStateSprite.height;

            FlxTween.num(0, 1, time, {ease: FlxEase.quadInOut, onComplete: finish, onUpdate: (tween:FlxTween) -> {
                prevStateSprite.clipRect = new FlxRect(0, 0, prevStateSprite.width*(1 - tween.percent), prevStateSprite.height);
            }}, (v:Float) -> { });
        case "instant":
            finish();
        default:
            trace("Invalid transition type: " + type);
            return false;
    }
    return true;
}