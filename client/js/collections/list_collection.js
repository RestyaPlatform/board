if (typeof App === 'undefined') {
    App = {};
}
/**
 * List Collection
 * @class ListCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.ListCollection = Backbone.Collection.extend({
    model: App.List,
    comparator: function(item) {
        return item.get('position');
    },
    sortByColumn: function(colName) {
        this.sortKey = colName;
        this.sort();
    },
    storeName: 'list',
    search: function(letters) {
        if (letters === '') return this;
        var pattern = new RegExp(letters, 'gi');
        return _(this.filter(function(data) {
            return pattern.test(data.get('name'));
        }));
    },
    next: function(list) {
        return this.at(this.indexOf(list) + 1);
    },
    previous: function(list) {
        return this.at(this.indexOf(list) - 1);
    }
});
