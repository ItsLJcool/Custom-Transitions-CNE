//a
import openfl.display.BitmapData;
import funkin.menus.BetaWarningState;

import Type;

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

    prevStateSprite = new FlxSprite();
    prevStateSprite.pixels = prevGameBitmap;
    prevStateSprite.screenCenter();
    prevStateSprite.scrollFactor.set();
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
        item.destroy();
        remove(item, true);
    }
}