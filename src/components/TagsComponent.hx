package components;

import ceramic.Component;
import ceramic.Entity;
import ceramic.Visual;
import game_utils.Tags;

class TagsComponent extends Entity implements Component {
	var tags:Map<Tags, Bool>;

	/**
	 * This will be the visual we attached to
	 */
	@entity var visual:Visual;

	public function new(tags:Array<Tags>) {
		super();

		this.tags = new Map<Tags, Bool>();
		for (tag in tags) {
			this.tags.set(tag, true);
		}
	}

	public function hasTag(tag:Tags):Bool {
		return tags.get(tag) || false;
	}

	function bindAsComponent() {}
}
