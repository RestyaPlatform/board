if (typeof App == 'undefined') {
    App = {};
}
/**
 * Board Collection
 * @class BoardCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.BoardCollection = Backbone.Collection.extend({
    model: App.Board,
    search: function(letters) {
        if (letters === "") return this;
        var pattern = new RegExp(letters, "i");
        return _(this.filter(function(data) {
            return pattern.test(data.get("name"));
        }));
    }
});
