//a
import funkin.options.type.Checkbox;
import funkin.options.type.TextOption;
import funkin.options.type.ArrayOption;
import funkin.options.OptionsScreen;

import funkin.editors.ui.UIState;
import flixel.effects.FlxFlicker;

var transitionOptionsValues:Array<String> = [];
var __transitionNames = (transitionNames ?? ["Default"]);
function postCreate() {
    for (data in __transitionNames) transitionOptionsValues.push(data.toLowerCase());
    main.add(
        new TextOption("Transition Settings >", "Change your default transitions!", function() {
            optionsTree.add(new OptionsScreen("Transition Settings", "Change your default transitions!", getOptions()));
        })
    );
}


function getOptions() {
    var optionsArray = new ArrayOption("Type", "Select the type of transition you want to use!", transitionOptionsValues, __transitionNames, "transitionTypeName", (curSel) -> {
        FlxG.save.data.transitionTypeName = curSel;
    }, FlxG.save.data);
    
    var testTransition = new TextOption("Test Transition", "Test your selected transition!");
    testTransition.selectCallback = () -> {
        FlxG.save.flush();
        FlxFlicker.stopFlickering(testTransition);
        FlxG.resetState();
    }

    if (!FlxG.random.bool(10)) return [ optionsArray,  testTransition ];
    else {
        var video = new TextOption("Secret Transition..?", "???");
        video.selectCallback = () -> {
            FlxFlicker.stopFlickering(video);
            __onceVideoTransition = true;
            FlxG.resetState();
        }
        // alwaysVideoTransition
        return [ optionsArray, testTransition, video];
    }
}