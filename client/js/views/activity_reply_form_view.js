/**
 * @fileOverview This file has functions related to activity reply view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activitiy model and it's related values
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ActivityReplyForm View
 * @class ActivityReplyFormView
 * @constructor
 * @extends Backbone.View
 */
App.ActivityReplyFormView = Backbone.View.extend({
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
    template: JST['templates/activity_reply_form'],
    tagName: 'form',
    className: 'js-add-comment panel-body js-reply-form',
    id: 'AddActivityForm',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            activity: this.model
        }));
        this.showTooltip();
        return this;
    }
});
