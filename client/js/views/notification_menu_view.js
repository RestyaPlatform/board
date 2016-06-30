/**
 * @fileOverview This file has functions related to notification menu view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * NotificationMenu View
 * @class NotificationMenuView
 * @constructor
 * @extends Backbone.View
 */
App.NotificationMenuView = Backbone.View.extend({
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
    template: JST['templates/notification_menu'],
    tagName: 'li',
    className: 'list-unstyled js-notification-response',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            user: this.model
        }));
        this.showTooltip();
        return this;
    }
});
