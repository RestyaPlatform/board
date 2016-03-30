/**
 * @fileOverview This file has functions related to attachment delete view. This view calling from attachment view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: attachment model and it's related values
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * AttachmentDeleteConfirmForm View
 * @class AttachmentDeleteConfirmFormView
 * @constructor
 * @extends Backbone.View
 */
App.AttachmentDeleteConfirmFormView = Backbone.View.extend({
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
    template: JST['templates/attachment_delete_confirm_form'],
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
            attachment: this.model
        }));
        this.showTooltip();
        return this;
    }
});
