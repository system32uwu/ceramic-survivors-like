import ceramic.Assets;
import ceramic.Sprite;
import ceramic.SpriteSheet;

class Sword extends Sprite {
	public function new(assets:Assets) {
		super();

		initArcadePhysics();

		sheet = new SpriteSheet();
		sheet.texture = assets.texture(Images.PIRATE_MAIN_WEAPON);
		sheet.grid(9, 31);
		sheet.addGridAnimation('default', [0], 0);
		animation = 'default';

		anchor(0.5, 1);

		quad.roundTranslation = 1;

		scale(2);

		gravity(0, 0);
	}

	override function update(dt:Float) {
		super.update(dt);
	}
}
