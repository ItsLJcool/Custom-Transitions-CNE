//a
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import funkin.menus.BetaWarningState;

import Type;

var prevStateSprite:FlxSprite = null;
function create(e) {
    if ((e.newState is BetaWarningState) || (FlxG.state is BetaWarningState) || FlxG.save.data.transitionTypeName.toLowerCase() == "default") return;
    var _default_persistentUpdate = FlxG.state.persistentUpdate;
    var _default_persistentDraw = FlxG.state.persistentDraw;
    FlxG.state.persistentUpdate = false;
    FlxG.state.persistentDraw = true;
    e.cancel();
    if (e.transOut) {
        prevGameBitmap = BitmapData.fromImage(FlxG.stage.window.readPixels());
        finish();
        return;
    }
    if (prevGameBitmap == null) return;
    // bgSprite = new FlxSprite().makeSolid(FlxG.width + 5, FlxG.height + 5, FlxColor.BLACK);
    // bgSprite.screenCenter();
    // bgSprite.scrollFactor.set();
    // add(bgSprite);
    
    var game = FlxG.game;
    var iscreenWidth = game.x * 2 + game.width;
    var iscreenHeight = game.y * 2 + game.height;
    var aspectChange = prevGameBitmap.width * iscreenWidth;

    var edgeX = game.x / aspectChange;
    var edgeY = game.y / aspectChange;

    prevStateSprite = new FlxSprite();
    prevStateSprite.pixels = prevGameBitmap;
    prevStateSprite.scrollFactor.set();
    prevStateSprite.frame.frame = prevStateSprite.frame.frame.set(edgeX, edgeY, prevGameBitmap.width - edgeX * 2, prevGameBitmap.height - edgeY * 2);
    var ff = prevStateSprite.frame;
    prevStateSprite.frame = null;
    prevStateSprite.frame = ff;
    prevStateSprite.setGraphicSize(FlxG.width, FlxG.height);
    prevStateSprite.updateHitbox();
    prevStateSprite.screenCenter();
    add(prevStateSprite);

    // newStateSprite = new FlxSprite();
    // newStateSprite.pixels = BitmapData.fromImage(FlxG.stage.window.readPixels());
    // newStateSprite.scrollFactor.set();
    // newStateSprite.screenCenter();
    // add(prevStateSprite);
    
    // transitionType("uncover", null, {left: true});
    // transitionType("fly through", 0.80, {out: true});
    var returnValue = transitionType(prevStateSprite, finish, FlxG.save.data.transitionTypeName);
    if (!returnValue) {
        e.cancelled = prevStateSprite.visible = false;
        FlxG.state.persistentUpdate = _default_persistentUpdate;
        FlxG.state.persistentDraw = _default_persistentDraw;
    }
}

function destroy() {
    for (item in members) {
        if (item == null) continue;
        FlxTween.cancelTweensOf(item);
        item.destroy();
        remove(item, true);
    }
}