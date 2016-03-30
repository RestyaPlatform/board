/**
 * @fileOverview This file has functions related to checklist item add link view. This view calling from card checklist view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefinded
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardSidebar View
 * @class BoardSidebarView
 * @constructor
 * @extends Backbone.View
 */
App.ChecklistItemAddLinkView = Backbone.View.extend({
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
    template: JST['templates/checklist_item_add_link'],
    tagName: 'div',
    className: 'col-xs-12 h4 btn-link',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template());
        this.showTooltip();
        return this;
    }
});
