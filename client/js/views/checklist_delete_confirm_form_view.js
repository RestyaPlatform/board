/**
 * @fileOverview This file has functions related to checklist delete confirm form view. This view calling from card checklist view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: checklist model. It contain all card checklist object @see Available Object in App.CardCheckListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ChecklistDeleteConfirmForm View
 * @class ChecklistDeleteConfirmFormView
 * @constructor
 * @extends Backbone.View
 */
App.ChecklistDeleteConfirmFormView = Backbone.View.extend({
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
    template: JST['templates/checklist_delete_confirm_form'],
    tagName: 'li',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            checklist: this.model
        }));
        this.showTooltip();
        return this;
    }
});
