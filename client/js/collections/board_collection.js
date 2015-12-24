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
        RegExp.escape = function(text) {
            return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
        };
        var pattern = new RegExp(RegExp.escape(letters), "i");
        return _(this.filter(function(data) {
            return pattern.test(data.get("name"));
        }));
    },
    setSortField: function(field, direction) {
        this.sortField = field;
        this.sortDirection = direction;
    },
    parse: function(response) {
        if (!_.isUndefined(response._metadata)) {
            return response.data;
        }
        return response;
    }
});
