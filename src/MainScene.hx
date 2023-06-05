package;

import ceramic.Group;
import ceramic.Scene;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;

class MainScene extends Scene {
	var player:Player;

	public var enemies:Group<Enemy> = new Group<Enemy>();

	var swordCollisionType = new CbType();
	var enemyCollisionType = new CbType();

	var playerCollisionType = new CbType();

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

		var listener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, enemyCollisionType, swordCollisionType, onHitEnemy);
		var listener2 = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, playerCollisionType, enemyCollisionType, onHitPlayer);

		app.nape.space.listeners.add(listener);
		app.nape.space.listeners.add(listener2);
		initPlayer();

		var enemy = new Enemy(assets);
		enemy.x = 100;
		enemy.y = height - 20;

		add(enemy);

		enemy.initNapePhysics(DYNAMIC);
		enemy.nape.body.cbTypes.add(enemyCollisionType);
	}

	function onHitEnemy(collision:InteractionCallback) {
		trace(collision);
		trace('collided with enemy');
	}

	function onHitPlayer(collision:InteractionCallback) {
		trace(collision);
		trace('collided with player');
	}

	function initPlayer() {
		player = new Player(assets, this);
		player.x = width / 2;
		player.y = height / 2;

		add(player);
		player.initNapePhysics(DYNAMIC);

		player.mainWeapon.initNapePhysics(DYNAMIC);
		player.mainWeapon.nape.body.cbTypes.add(swordCollisionType);
	}

	override function update(dt:Float) {
		super.update(dt);
	}
}
