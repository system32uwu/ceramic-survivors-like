import ceramic.Assets;
import ceramic.Quad;
import ceramic.SpriteSheet;

class Sword extends TaggedSprite {
	var scene:MainScene;
	var collider:Quad;

	public function new(assets:Assets, scene:MainScene) {
		super([Tags.PlayerWeapon]);
		this.scene = scene;

		sheet = new SpriteSheet();
		sheet.texture = assets.texture(Images.PIRATE_MAIN_WEAPON);
		sheet.grid(9, 31);
		sheet.addGridAnimation('default', [0], 0);
		animation = 'default';

		// initArcadePhysics();

		anchor(0, 2);

		scale(2);

		// gravity(0, 0);

		// onCollide(this, (v1, v2) -> {
		// 	trace('collide sword');
		// 	trace('--');
		// });
	}

	override function update(dt:Float) {
		rotation += 360 * dt / 3;
		super.update(dt);
	}
}
