/**
 * @fileOverview This file has functions related to checklist item delete confirm form view. This view calling from card checklist item view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: checklist item model. It contain all card checklist item object @see Available Object in App.CardCheckListItemView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ChecklistItemDeleteConfirmForm View
 * @class ChecklistItemDeleteConfirmFormView
 * @constructor
 * @extends Backbone.View
 */
App.ChecklistItemDeleteConfirmFormView = Backbone.View.extend({
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
    template: JST['templates/checklist_item_delete_confirm_form'],
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
            checklist_item: this.model
        }));
        this.showTooltip();
        return this;
    }
});
