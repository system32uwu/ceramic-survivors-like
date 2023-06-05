import ceramic.Assets;
import ceramic.SpriteSheet;

class Enemy extends TaggedSprite {
	public function new(assets:Assets) {
		super([Tags.Enemy]);

		sheet = new SpriteSheet();
		sheet.texture = assets.texture(Images.ENEMY_1);
		sheet.grid(16, 24);

		sheet.addGridAnimation('idle', [4, 5, 6, 7], 0.1);
		sheet.addGridAnimation('run', [8, 9, 10, 11], 0.1);

		anchor(0.5, 0.5);

		quad.roundTranslation = 1;

		animation = 'idle';

		anchor(0.5, 0.5);

		scale(2);
	}

	override function update(dt:Float) {
		super.update(dt);
	}
}
