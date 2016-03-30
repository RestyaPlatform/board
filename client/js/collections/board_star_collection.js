if (typeof App === 'undefined') {
    App = {};
}
/**
 * Board Star Collection
 * @class BoardStarCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.BoardStarCollection = Backbone.Collection.extend({
    model: App.BoardStar
});
