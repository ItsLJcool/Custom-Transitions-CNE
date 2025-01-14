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
        if (FlxG.random.bool(0.00001) || alwaysVideoTransition || __onceVideoTransition) {
            if (__onceVideoTransition) __onceVideoTransition = false;
            if (rapbattle()) return;
        }
        prevGameBitmap = BitmapData.fromImage(FlxG.stage.window.readPixels());
        finish();
        return;
    }

    if (prevGameBitmap == null) return finish();
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

function onSkip(e) {
    if (playingVideo == null) return;
    trace("Skipping");
    e.cancel();
    playingVideo.bitmap.onEndReached.dispatch();
}

function destroy() {
    for (item in members) {
        if (item == null) continue;
        FlxTween.cancelTweensOf(item);
        item.destroy();
        remove(item, true);
    }
}

import haxe.io.Path;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;

var playingVideo:FlxVideoSprite;
var _playing = false;
function rapbattle() {
    var funny = Paths.getFolderContent("videos/rapbattle");
    var temp = [];
    for (song in funny) temp.push(Path.withoutExtension(song));
    funny = temp;

    var name = funny[FlxG.random.int(0, funny.length - 1)];

	var background = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	background.screenCenter();
	add(background);

	var path = Paths.video("rapbattle/" + name, "mp4");
	playingVideo = new FlxVideoSprite();
	playingVideo.antialiasing = true;
	playingVideo.bitmap.onFormatSetup.add(function() {
		if (playingVideo.bitmap == null || playingVideo.bitmap.bitmapData == null)
			return;

		var scale:Float = Math.min(FlxG.width / playingVideo.bitmap.bitmapData.width, FlxG.height / playingVideo.bitmap.bitmapData.height);

		playingVideo.setGraphicSize(playingVideo.bitmap.bitmapData.width * scale, playingVideo.bitmap.bitmapData.height * scale);
		playingVideo.updateHitbox();
		playingVideo.screenCenter();
	});

    var prev_music_volume = FlxG?.sound?.music?.volume ?? 0;
    var prev_sound_volume = FlxG.sound.volume;

	playingVideo.bitmap.onEndReached.add(function() {
        playingVideo.destroy();
        background.destroy();
        playingVideo = null;
        FlxG?.sound?.music?.volume = prev_music_volume;
        FlxG.sound.volume = 0;
        FlxG.sound.changeVolume(prev_sound_volume);
        new FlxTimer().start(0.01, (tmr) -> {
            prevGameBitmap = BitmapData.fromImage(FlxG.stage.window.readPixels());
            finish();
        });
        // finish();
	});

	if (playingVideo.load(path)) {
        add(playingVideo);
        playingVideo.play();
        _playing = true;
        FlxG?.sound?.music?.volume = 0;
        FlxG.sound.volume = 0;
        FlxG.sound.changeVolume(0.5);
	} else {
		background.destroy();
        playingVideo.bitmap.onEndReached.dispatch();
        _playing = false;
	}
    return _playing;
}