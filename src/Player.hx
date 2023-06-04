import ceramic.Assets;
import ceramic.InputMap;
import ceramic.KeyCode as K;
import ceramic.Sprite;
import ceramic.SpriteSheet;
import ceramic.StateMachine;

/**
 * The different states the player can have.
 */
enum abstract PlayerState(Int) {
	/**
	 * Player's default state: walking or not moving at all
	 */
	var DEFAULT;
}

/**
 * The input keys that will make player interaction
 */
enum abstract PlayerInput(Int) {
	var RIGHT;
	var LEFT;
	var DOWN;
	var UP;
	var JUMP;
}

class Player extends Sprite {
	var inputMap = new InputMap<PlayerInput>();

	/**
	 * A state machine plugged as a `Component` to `Player` using `PlayerState`
	 * as an enum that provides the different possible states.
	 *
	 * Because this state machine is here, `{STATE}_enter()/update()/exit()` are
	 * automatically called if they exist in the `Player` class and the corresponding
	 * state is the current machine's state.
	 */
	@component var machine = new StateMachine<PlayerState>();

	public function new(assets:Assets) {
		super();

		initArcadePhysics();

		body.collideWorldBounds = true;

		sheet = new SpriteSheet();
		sheet.texture = assets.texture(Images.HERO);
		sheet.grid(16, 24);

		sheet.addGridAnimation('idle', [4, 5, 6, 7], 0.1);
		sheet.addGridAnimation('run', [8, 9, 10, 11], 0.1);

		anchor(0.5, 1);

		quad.roundTranslation = 1;

		animation = 'idle';

		machine.state = DEFAULT;

		scale(2);

		gravity(0, 0);

		bindInput();
	}

	function bindInput() {
		inputMap.bindKeyCode(PlayerInput.RIGHT, K.RIGHT);
		inputMap.bindKeyCode(PlayerInput.LEFT, K.LEFT);
		inputMap.bindKeyCode(PlayerInput.DOWN, K.DOWN);
		inputMap.bindKeyCode(PlayerInput.UP, K.UP);
	}

	override function update(dt:Float) {
		// Update sprite
		super.update(dt);
	}

	function DEFAULT_update(dt:Float) {
		handleInput(dt);
	}

	function handleInput(dt:Float) {
		if (inputMap.pressed(PlayerInput.RIGHT)) {
			velocityX = 120;
			scaleX = 2;
		}

		if (inputMap.pressed(PlayerInput.LEFT)) {
			velocityX = -120;
			scaleX = -2;
		}

		if (inputMap.pressed(PlayerInput.UP)) {
			velocityY = -120;
		}

		if (inputMap.pressed(PlayerInput.DOWN)) {
			velocityY = 120;
		}

		if (!inputMap.pressed(PlayerInput.RIGHT) && !inputMap.pressed(PlayerInput.LEFT)) {
			velocityX = 0;
		}

		if (!inputMap.pressed(PlayerInput.UP) && !inputMap.pressed(PlayerInput.DOWN)) {
			velocityY = 0;
		}

		handleMovement(dt);
	}

	function handleMovement(dt:Float) {
		if (velocityX != 0 || velocityY != 0) {
			animation = 'run';
		} else {
			animation = 'idle';
		}

		// if the player moves in both directions, we divide the speed by 1.4
		// to avoid going too fast
		if (velocityX != 0 && velocityY != 0) {
			velocityX /= 1.4;
			velocityY /= 1.4;
		}

		x += velocityX * dt;
		y += velocityY * dt;
	}
}
