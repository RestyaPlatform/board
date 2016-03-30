/**
 * @fileOverview This file has functions related to activity delete view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activity ID
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ActivityDeleteConfirm View
 * @class ActivityDeleteConfirmView
 * @constructor
 * @extends Backbone.View
 */
App.ActivityDeleteConfirmView = Backbone.View.extend({
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
    template: JST['templates/activity_delete_confirm'],
    tagName: 'div',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            activity_id: this.model
        }));
        this.showTooltip();
        return this;
    }
});
