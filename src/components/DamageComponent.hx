package components;

import ceramic.Component;
import ceramic.Entity;
import ceramic.Visual;

class DamageComponent extends Entity implements Component {
	public var base:Float = 0;
	public var value:Float = 0;

	/**
	 * This will be the visual we attached to
	 */
	@entity var visual:Visual;

	public function new(baseDamage:Float) {
		super();

		this.value = baseDamage;
		this.base = baseDamage;
	}

	public function increase(amount:Float) {
		this.value += amount;
	}

	public function decrease(amount:Float) {
		this.value -= amount;
	}

	function bindAsComponent() {}
}
