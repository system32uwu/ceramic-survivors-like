package characters;

import ceramic.Assets;
import ceramic.InputMap;
import ceramic.KeyCode as K;
import ceramic.SpriteSheet;
import ceramic.StateMachine;
import game_utils.*;

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
}

class Player extends TaggedSprite {
	public var inputMap = new InputMap<PlayerInput>();

	var moveSpeed:Float = 180;
	var scene:MainScene;

	public var rotatorCenter:RotatorCenter;
	public var mainWeapon:Sword;

	/**
	 * A state machine plugged as a `Component` to `Player` using `PlayerState`
	 * as an enum that provides the different possible states.
	 *
	 * Because this state machine is here, `{STATE}_enter()/update()/exit()` are
	 * automatically called if they exist in the `Player` class and the corresponding
	 * state is the current machine's state.
	 */
	@component var machine = new StateMachine<PlayerState>();

	public function new(assets:Assets, scene:MainScene, debug:Bool = false) {
		super([Tags.Player], 10, 0, 0, debug);
		this.scene = scene;

		initArcadePhysics();

		body.collideWorldBounds = true;

		sheet = new SpriteSheet();
		sheet.texture = assets.texture(Images.HERO);
		sheet.grid(16, 24);

		sheet.addGridAnimation('idle', [4, 5, 6, 7], 0.1);
		sheet.addGridAnimation('run', [8, 9, 10, 11], 0.1);

		anchor(0.5, 0.5);

		quad.roundTranslation = 1;

		animation = 'idle';

		machine.state = DEFAULT;

		gravity(0, 0);

		bindInput();

		initSword(debug);
	}

	function initSword(debug:Bool = false) {
		initRotatorCenter();

		mainWeapon = new Sword(this.scene.assets, this.rotatorCenter, debug);
		mainWeapon.depth = 100;
	}

	function initRotatorCenter() {
		rotatorCenter = new RotatorCenter(this);
		// scene.tilemap.add(rotatorCenter);
	}

	function bindInput() {
		inputMap.bindKeyCode(PlayerInput.RIGHT, K.RIGHT);
		inputMap.bindKeyCode(PlayerInput.LEFT, K.LEFT);
		inputMap.bindKeyCode(PlayerInput.DOWN, K.DOWN);
		inputMap.bindKeyCode(PlayerInput.UP, K.UP);

		// We use scan code for these so that it
		// will work with non-qwerty layouts as well
		inputMap.bindScanCode(PlayerInput.RIGHT, KEY_D);
		inputMap.bindScanCode(PlayerInput.LEFT, KEY_A);
		inputMap.bindScanCode(PlayerInput.DOWN, KEY_S);
		inputMap.bindScanCode(PlayerInput.UP, KEY_W);

		inputMap.bindGamepadAxisToButton(PlayerInput.RIGHT, LEFT_X, 0.25);
		inputMap.bindGamepadAxisToButton(PlayerInput.LEFT, LEFT_X, -0.25);
		inputMap.bindGamepadAxisToButton(PlayerInput.DOWN, LEFT_Y, 0.25);
		inputMap.bindGamepadAxisToButton(PlayerInput.UP, LEFT_Y, -0.25);
		inputMap.bindGamepadButton(PlayerInput.RIGHT, DPAD_RIGHT);
		inputMap.bindGamepadButton(PlayerInput.LEFT, DPAD_LEFT);
		inputMap.bindGamepadButton(PlayerInput.DOWN, DPAD_DOWN);
		inputMap.bindGamepadButton(PlayerInput.UP, DPAD_UP);
	}

	override function update(dt:Float) {
		// Update sprite
		super.update(dt);
	}

	public function updatePhysics(dt:Float) {}

	function DEFAULT_update(dt:Float) {
		handleInput(dt);
	}

	function handleInput(dt:Float) {
		if (inputMap.pressed(PlayerInput.RIGHT)) {
			velocityX = moveSpeed;
		}

		if (inputMap.pressed(PlayerInput.LEFT)) {
			velocityX = -moveSpeed;
		}

		if (inputMap.pressed(PlayerInput.UP)) {
			velocityY = -moveSpeed;
		}

		if (inputMap.pressed(PlayerInput.DOWN)) {
			velocityY = moveSpeed;
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

		if (velocityX != 0) {
			scaleX = velocityX > 0 ? scaleFactor : -scaleFactor;
		}
	}
}
