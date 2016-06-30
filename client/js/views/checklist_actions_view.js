/**
 * @fileOverview This file has functions related to checklist action view. This view calling from card checklist view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: checklist model. It contain all checklist based object @see Available Object in App.CardCheckListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ChecklistActions View
 * @class ChecklistActionsView
 * @constructor
 * @extends Backbone.View
 */
App.ChecklistActionsView = Backbone.View.extend({
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
    template: JST['templates/checklist_actions'],
    tagName: 'a',
    className: 'js-show-confirm-checklist-delete',
    attributes: {
        'title': i18next.t('Delete This Checklist'),
        'href': '#'
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
            checklist: this.model
        }));
        this.showTooltip();
        return this;
    }
});
