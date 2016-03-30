/**
 * @fileOverview This file has functions related to checklist action view. This view calling from card checklist view and card checklist item view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: checklist model. It contain all card checklist object @see Available Object in App.CardCheckListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ChecklistItemActions View
 * @class ChecklistItemActionsView
 * @constructor
 * @extends Backbone.View
 */
App.ChecklistItemActionsView = Backbone.View.extend({
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
    template: JST['templates/checklist_item_actions'],
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
            checklist_item: this.model
        }));
        this.showTooltip();
        return this;
    }
});
