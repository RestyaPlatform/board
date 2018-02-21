if (typeof App === 'undefined') {
    App = {};
}
/**
 * intro_video Collection
 * @class intro_videoCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.intro_videoCollection = Backbone.Collection.extend({
    model: App.intro_view_model
});
