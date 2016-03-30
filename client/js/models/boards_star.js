if (typeof App === 'undefined') {
    App = {};
}
/**
 * Board Star Model
 * @class BoardStar
 * @constructor
 * @extends Backbone.Model
 */
App.BoardStar = Backbone.Model.extend({
    url: function() {
        return api_url + 'board_stars/' + this.id + '.json';
    }
});
