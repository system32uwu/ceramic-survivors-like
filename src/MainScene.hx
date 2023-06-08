package;

import ceramic.Group;
import ceramic.Scene;
import characters.*;

class MainScene extends Scene {
	var player:Player;

	public var enemies:Group<Enemy>;

	override function preload() {
		assets.add(Images.HERO);
		assets.add(Images.PIRATE_MAIN_WEAPON);
		assets.add(Images.ENEMY_1);
		assets.add(Images.ENEMY_1V_2);
	}

	public function restart() {
		player.mainWeapon.destroy();
		player.inputMap.unbindEvents();
		player.destroy();
		enemies.destroy();

		start();
	}

	override function create() {
		assets.texture(Images.HERO).filter = NEAREST;
		assets.texture(Images.PIRATE_MAIN_WEAPON).filter = NEAREST;
		assets.texture(Images.ENEMY_1).filter = NEAREST;
		assets.texture(Images.ENEMY_1V_2).filter = NEAREST;

		start();
	}

	function start() {
		initArcadePhysics();

		initPlayer();

		enemies = new Group<Enemy>();
		for (i in 0...20) {
			var xNegate = Math.random() > 0.5 ? 1 : -1;
			var yNegate = Math.random() > 0.5 ? 1 : -1;

			var enemy = new Enemy(assets, this.player);
			enemy.x = width / 2 - 5 * i * xNegate;
			enemy.y = player.y - 50 * i * yNegate;
			enemies.add(enemy);
			enemy.depth = -1;
		}
	}

	function initPlayer() {
		player = new Player(assets, this);
		player.x = width / 2;
		player.y = height / 2;
		add(player);
		player.depth = 100;
	}

	override function update(dt:Float) {
		super.update(dt);

		arcade.world.collide(player, enemies);
		arcade.world.collide(player.mainWeapon, enemies);
	}
}
