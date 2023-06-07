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
		settings.targetWidth = 640;
		settings.targetHeight = 480;
		settings.scaling = FIT;
		settings.resizable = true;
		settings.fullscreen = false;

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
				scene.restart();
			}
		});
	}

	function setupResolution() {
		// Render as low resolution / pixel art,
		// But with a larger grid so that we get smoother scroll
		var pixelArt = new PixelArt();
		pixelArt.sharpness = 1.0;
		function pixelArtLayout() {
			var scale:Float = Math.floor(Math.min(Math.min(screen.nativeWidth * screen.nativeDensity / screen.width,
				screen.nativeHeight * screen.nativeDensity / screen.height), 4.0));
			pixelArt.size(Math.round(screen.width * scale), Math.round(screen.height * scale));
		}
		screen.onResize(this, pixelArtLayout);
		pixelArtLayout();
		app.scenes.filter = pixelArt;
	}
}
