package;

import ceramic.Camera;
import ceramic.Color;
import ceramic.Group;
import ceramic.Scene;
import ceramic.Text;
import ceramic.Tilemap;
import characters.*;

using ceramic.TilemapPlugin;

class MainScene extends Scene {
	public var player:Player;

	public var enemies:Group<Enemy>;

	var ltdkName = Tilemaps.LEVEL;
	var camera:Camera;

	public var tilemap:Tilemap = null;

	var fpsText:Text;

	var globalDebug = false;

	override function preload() {
		assets.add(Images.HERO);
		assets.add(Images.PIRATE_MAIN_WEAPON);
		assets.add(Images.ENEMY_1);
		assets.add(Images.ENEMY_1V_2);
		assets.add(ltdkName);
	}

	override function create() {
		assets.texture(Images.HERO).filter = NEAREST;
		assets.texture(Images.PIRATE_MAIN_WEAPON).filter = NEAREST;
		assets.texture(Images.ENEMY_1).filter = NEAREST;
		assets.texture(Images.ENEMY_1V_2).filter = NEAREST;

		start();

		if (globalDebug) {
			initDebugFps();
		}
	}

	function initDebugFps() {
		fpsText = new Text();
		fpsText.color = Color.WHITE;
		fpsText.pointSize = 28;
		fpsText.anchor(0.5, 0.5);
		fpsText.pos(20, 20);
	}

	function start() {
		initArcadePhysics(app.arcade.world);

		if (tilemap == null) {
			var ldtkData = assets.ldtk(ltdkName);
			var level = ldtkData.worlds[0].levels[0];

			level.ensureLoaded(() -> {
				tilemap = new Tilemap();
				tilemap.depth = -100;
				tilemap.tilemapData = level.ceramicTilemap;
				add(tilemap);
			});

			tilemap.initArcadePhysics(app.arcade.world);
		}

		enemies = new Group<Enemy>();

		initPlayer();
		initEnemies();

		app.arcade.autoUpdateWorldBounds = false;
		app.arcade.world.setBounds(0, 0, tilemap.width, tilemap.height);

		initCamera();
	}

	function initEnemies() {
		for (i in 0...100) {
			var xNegate = Math.random() > 0.5 ? 1 : -1;
			var yNegate = Math.random() > 0.5 ? 1 : -1;

			var enemy = new Enemy(assets, this.player, this.globalDebug);
			enemy.x = width / 2 - 5 * i * xNegate;
			enemy.y = player.y - 50 * i * yNegate;
			addDebug(enemy);
			enemies.add(enemy);
			tilemap.add(enemy);
			enemy.depth = 90;
		}
	}

	function addDebug(obj) {
		if (obj?.debug) {
			tilemap.add(obj.collider);
		}
	}

	function initPlayer() {
		player = new Player(assets, this, this.globalDebug);
		player.x = width / 2;
		player.y = height / 2;
		tilemap.add(player);
		tilemap.add(player.rotatorCenter);
		tilemap.add(player.mainWeapon);
		addDebug(player);
		addDebug(player.mainWeapon);
		player.depth = 100;
	}

	override function update(dt:Float) {
		super.update(dt);

		tilemap.arcade.world.collide(player, enemies);
		tilemap.arcade.world.collide(player.mainWeapon, enemies);

		if (globalDebug) {
			fpsText.content = Std.string(app.computedFps);
			fpsText.color = app.computedFps < 55 ? Color.RED : Color.WHITE;
		}
	}

	function initCamera() {
		// Configure camera
		camera = new Camera();

		// We tweak some camera settings to make it work
		// better with our low-res pixel art display
		camera.movementThreshold = 0.5;
		camera.trackSpeedX = 80;
		camera.trackSpeedY = 80;

		camera.trackCurve = 0.3;
		// camera.brakeNearBounds(0, 0);

		// Tell the camera what is the size of the viewport
		camera.viewportWidth = width;
		camera.viewportHeight = height;

		// Tell the camera what is the size and position of the content
		camera.contentX = 0;
		camera.contentY = 0;
		camera.contentWidth = tilemap.tilemapData.width;
		camera.contentHeight = tilemap.tilemapData.height;

		// We update the camera after everything else has been updated
		// so that we are sure it won't be based on some intermediate state
		app.onPostUpdate(this, updateCamera);

		// Update the camera once right away
		// (we use a very big delta so that it starts at a stable position)
		updateCamera(99999);
	}

	function updateCamera(delta:Float) {
		// Tell the camera what position to target (the player's position)
		camera.followTarget = true;
		camera.targetX = player.x;
		camera.targetY = player.y;

		// Then, let the camera handle these infos
		// so that it updates itself accordingly
		camera.update(delta);

		// Now that the camera has updated,
		// set the content position from the computed data
		tilemap.x = camera.contentTranslateX;
		tilemap.y = camera.contentTranslateY;

		// Update tile clipping
		// (disables tiles that are outside viewport)
		tilemap.clipTiles(Math.floor(camera.x - camera.viewportWidth * 0.5), Math.floor(camera.y - camera.viewportHeight * 0.5),
			Math.ceil(camera.viewportWidth) + tilemap.tilemapData.maxTileWidth, Math.ceil(camera.viewportHeight) + tilemap.tilemapData.maxTileHeight);
	}
}
