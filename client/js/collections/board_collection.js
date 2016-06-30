if (typeof App === 'undefined') {
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
    comparator: function(item) {
        if (!_.isUndefined(this.sortDirection)) {
            var self = this;
            var str = '' + item.get(this.sortField);
            if (this.sortField !== 'id') {
                str = str.toLowerCase();
                str = str.split('');
                str = _.map(str, function(letter) {
                    if (self.sortDirection.toLowerCase() === 'desc') {
                        return String.fromCharCode(-(letter.charCodeAt(0)));
                    } else {
                        return String.fromCharCode((letter.charCodeAt(0)));
                    }
                });
                return str;
            } else if (this.sortField === 'created' || this.sortField === 'modified') {
                if (item.get(this.sortField) !== null) {
                    var date = item.get(this.sortField).split(' ');
                    if (!_.isUndefined(date[1])) {
                        _date = date[0] + 'T' + date[1];
                    } else {
                        _date = date[0];
                    }
                    sort_date = new Date(_date);
                    return self.sortDirection.toLowerCase() === 'desc' ? -sort_date.getTime() : sort_date.getTime();
                }
            } else {
                if (self.sortDirection.toLowerCase() === 'desc') {
                    return -item.get(this.sortField);
                } else {
                    return item.get(this.sortField);
                }
            }
        }
    },
    parse: function(response) {
        if (!_.isUndefined(response._metadata)) {
            return response.data;
        }
        return response;
    }
});
