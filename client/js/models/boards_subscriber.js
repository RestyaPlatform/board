if (typeof App === 'undefined') {
    App = {};
}
/**
 * Board Subscriber Model
 * @class BoardSubscriber
 * @constructor
 * @extends Backbone.Model
 */
App.BoardSubscriber = Backbone.Model.extend({
    url: function() {
        return api_url + 'board_subscribers/' + this.id + '.json';
    }
});
