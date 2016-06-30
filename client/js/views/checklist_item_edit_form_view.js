/**
 * @fileOverview This file has functions related to checklist item edit form view. This view calling from card checklist item view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board user collection
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ChecklistItemEditForm View
 * @class ChecklistItemEditFormView
 * @constructor
 * @extends Backbone.View
 */
App.ChecklistItemEditFormView = Backbone.View.extend({
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
    template: JST['templates/checklist_item_edit_form'],
    tagName: 'form',
    className: 'js-item-edit-form form-horizontal',
    attributes: {
        'method': 'POST'
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
            checklist_item: this.model
        }));
        this.showTooltip();
        return this;
    }
});
