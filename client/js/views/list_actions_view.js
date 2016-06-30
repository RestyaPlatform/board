/**
 * @fileOverview This file has functions related to list action view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list model. It contain all list based object @see Available Object in App.ListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ListActions View
 * @class ListActionsView
 * @constructor
 * @extends Backbone.View
 */
App.ListActionsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.subscribers = options.subscribers;
        this.authuser = options.authuser;
        this.render();
    },
    template: JST['templates/list_actions'],
    tagName: 'ul',
    className: 'dropdown-menu dropdown-menu-right arrow arrow-right js-list-actions-response',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            list: this.model,
            subscribers: this.subscribers,
            authuser: this.authuser
        }));
        this.showTooltip();
        return this;
    }
});
