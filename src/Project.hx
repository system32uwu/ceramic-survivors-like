package;

import ceramic.Color;
import ceramic.Entity;
import ceramic.InitSettings;
import ceramic.InputMap;
import ceramic.PixelArt;

enum abstract ProjectInput(Int) {
	var RESTART;
}

class Project extends Entity {
	var inputMap = new InputMap<ProjectInput>();

	function new(settings:InitSettings) {
		super();

		settings.antialiasing = 0;
		settings.background = Color.BLACK;
		settings.targetWidth = 800;
		settings.targetHeight = 600;
		settings.windowWidth = 1920;
		settings.windowHeight = 1080;
		settings.scaling = FIT_RESIZE;
		settings.resizable = true;
		settings.fullscreen = true;
		app.onceReady(this, ready);
	}

	function ready() {
		setupResolution();
		// Set MainScene as the current scene (see MainScene.hx)
		app.scenes.main = new MainScene();
		bindInput();
	}

	function bindInput() {
		inputMap.bindKeyCode(ProjectInput.RESTART, KEY_R);
		// We use scan code for these so that it
		// will work with non-qwerty layouts as well
		inputMap.bindScanCode(ProjectInput.RESTART, KEY_R);
		inputMap.bindGamepadButton(ProjectInput.RESTART, START);
		inputMap.onKeyDown(this, (k) -> {
			if (k == ProjectInput.RESTART) {
				var scene:MainScene = cast app.scenes.main;
				scene.player.inputMap.unbindEvents();
				scene.dispose();

				app.scenes.main = new MainScene();
			}
		});
	}

	function setupResolution() {
		var pixelArt = new PixelArt();
		pixelArt.bindToScreenSize();
		app.scenes.filter = pixelArt;
	}
}
