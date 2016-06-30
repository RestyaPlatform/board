/**
 * @fileOverview This file has functions related to user search result view. This view calling from organization user view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UserSearchResult View
 * @class UserSearchResultView
 * @constructor
 * @extends Backbone.View
 */
App.UserSearchResultView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.q = options.q;
        this.render();
    },
    template: JST['templates/user_search_result'],
    tagName: 'li',
    className: 'col-xs-12',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            user: this.model,
            q: this.q
        }));
        this.showTooltip();
        return this;
    }
});
