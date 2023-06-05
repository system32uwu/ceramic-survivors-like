import ceramic.Assets;
import ceramic.SpriteSheet;
import nape.geom.Vec2;

class Sword extends TaggedSprite {
	var scene:MainScene;
	final center:Vec2 = new Vec2(0, 0);

	public function new(assets:Assets, scene:MainScene) {
		super([Tags.PlayerWeapon]);
		this.scene = scene;

		sheet = new SpriteSheet();
		sheet.texture = assets.texture(Images.PIRATE_MAIN_WEAPON);
		sheet.grid(9, 31);
		sheet.addGridAnimation('default', [0], 0);
		animation = 'default';
		quad.roundTranslation = 1;

		anchor(0, 2);

		scale(2);
	}

	override function update(dt:Float) {
		nape.body.rotate(center, 360 * dt / 300);

		// trace(nape.body.rotation);
		trace(nape.body.position);
		super.update(dt);
	}
}
