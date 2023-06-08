package components;

import ceramic.Component;
import ceramic.Entity;
import ceramic.Visual;

class ValueComponent extends Entity implements Component {
	public var base:Float = 0;
	public var value:Float = 0;
	public var maxValue:Float = 0; // for health or energy

	/**
	 * This will be the visual we attached to
	 */
	@entity var visual:Visual;

	public function new(base:Float, maxValue:Float = 0) {
		super();

		this.value = base;
		this.base = base;
		this.maxValue = maxValue;
	}

	public function increaseByAmount(amount:Float) {
		this.value += amount;
	}

	public function decreaseByAmount(amount:Float) {
		this.value -= amount;
	}

	public function increaseByPercent(percent:Float) {
		this.value += this.value * percent / 100;
	}

	public function decreaseByPercent(percent:Float) {
		this.value += this.value * percent / 100;
	}

	function bindAsComponent() {}
}
