package;

import ceramic.Scene;

class MainScene extends Scene {
	var player:Player;

	override function preload() {
		// Add any asset you want to load here
		assets.add(Images.HERO);
		assets.add(Images.PIRATE_MAIN_WEAPON);
	}

	override function create() {
		assets.texture(Images.HERO).filter = NEAREST;
		assets.texture(Images.PIRATE_MAIN_WEAPON).filter = NEAREST;

		initPlayer();
	}

	function initPlayer() {
		player = new Player(assets);
		player.x = width / 2;
		player.y = height / 2;
		add(player);
	}

	override function update(delta:Float) {}
}
