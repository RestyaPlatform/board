/**
 * @fileOverview This file has functions related to user index container view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UserIndexContainer View
 * @class UserIndexContainerView
 * @constructor
 * @extends Backbone.View
 */
App.UserLoginsContainerView = Backbone.View.extend({
    template: JST['templates/user_logins_index_container'],
    tag: 'section',
    className: 'clearfix row',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {},
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.sortField = options.sortField;
        this.filter_count = options.filter_count;
        this.roles = options.roles;
        this.sortDirection = options.sortDirection;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            filter_count: this.filter_count,
            roles: this.roles
        }));

        this.showTooltip();
        return this;
    },
});
