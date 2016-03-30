/**
 * @fileOverview This file has functions related to edit activity form view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activitiy model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * EditActivityForm View
 * @class EditActivityFormView
 * @constructor
 * @extends Backbone.View
 */
App.EditActivityFormView = Backbone.View.extend({
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
    template: JST['templates/edit_activity_form'],
    tagName: 'form',
    className: 'js-edit-comment',
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
