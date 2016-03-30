if (typeof App === 'undefined') {
    App = {};
}
/**
 * ClosedBoard Collection
 * @class MyClosedBoardCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.ClosedBoardCollection = Backbone.Collection.extend({
    model: App.boards
});
