if (typeof App == 'undefined') {
    App = {};
}
/**
 * User Collection
 * @class UserCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.UserCollection = Backbone.Collection.extend({
    model: App.User,
    initialize: function() {
        this.sortField = "id";
        this.sortDirection = "DESC";
    },
    forSelect: function() {
        return this.map(function(user) {
            return [user.get('name'), user.id];
        });
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
