if (typeof App === 'undefined') {
    App = {};
}
/**
 * Organization Collection
 * @class OrganizationCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.OrganizationCollection = Backbone.Collection.extend({
    model: App.Organization,
    initialize: function() {
        this.sortField = "name";
        this.sortDirection = "ASC";
    },
    saved: function() {
        return this.reject(function(organization) {
            return organization.isNew();
        });
    },
    setSortField: function(field, direction) {
        this.sortField = field;
        this.sortDirection = direction;
    },
    comparator: function(item) {
        var self = this;
        var str = '' + item.get(this.sortField);
        if (this.sortField !== 'id') {
            str = str.toLowerCase();
            str = str.split("");
            str = _.map(str, function(letter) {
                if (self.sortDirection.toLowerCase() === 'desc') {
                    return String.fromCharCode(-(letter.charCodeAt(0)));
                } else {
                    return String.fromCharCode((letter.charCodeAt(0)));
                }
            });
            return str;
        } else {
            if (self.sortDirection.toLowerCase() === 'desc') {
                return -item.get(this.sortField);
            } else {
                return item.get(this.sortField);
            }
        }
    }
});
