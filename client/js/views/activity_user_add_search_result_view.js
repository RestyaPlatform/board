/**
 * @fileOverview This file has functions related to activity user search view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model and it's related values
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ActivityUserAddSearchResult View
 * @class ActivityUserAddSearchResultView
 * @constructor
 * @extends Backbone.View
 */
App.ActivityUserAddSearchResultView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/activity_user_add_search_result'],
    tagName: 'ul',
    className: 'list-unstyled navbar-btn',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({
            user: this.model
        });
        this.showTooltip();
        return this;
    }
});
