package;

import ceramic.Group;
import ceramic.Scene;

class MainScene extends Scene {
	var player:Player;

	public var enemies:Group<Enemy> = new Group<Enemy>();

	override function preload() {
		// Add any asset you want to load here
		assets.add(Images.HERO);
		assets.add(Images.PIRATE_MAIN_WEAPON);
		assets.add(Images.ENEMY_1);
	}

	override function create() {
		assets.texture(Images.HERO).filter = NEAREST;
		assets.texture(Images.PIRATE_MAIN_WEAPON).filter = NEAREST;
		assets.texture(Images.ENEMY_1).filter = NEAREST;

		initArcadePhysics();

		initPlayer();

		var enemy = new Enemy(assets);
		enemy.x = width / 2 - 5;
		enemy.y = player.y - 50;

		enemies.add(enemy);
	}

	function initPlayer() {
		player = new Player(assets, this);
		player.x = width / 2;
		player.y = height / 2;
		add(player);
	}

	override function update(dt:Float) {
		super.update(dt);

		arcade.world.collide(player, enemies);
		// arcade.world.collide(player.mainWeapon.childWithId('swordcollider'), enemies);
	}
}
