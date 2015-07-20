if (typeof App == 'undefined') {
    App = {};
}
/**
 * Activity Collection
 * @class ActivityCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.ActivityCollection = Backbone.Collection.extend({
    model: App.Activity
});
