/**
 * @fileOverview This file has functions related to checklist item mention member search form view. This view calling from card checklist item view and card checklist view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ChecklistItemMentionMember View
 * @class ChecklistItemMentionMemberView
 * @constructor
 * @extends Backbone.View
 */
App.ChecklistItemMentionMemberSerachFormView = Backbone.View.extend({
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
    template: JST['templates/checklist_item_mention_member_search_form'],
    tagName: 'div',
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
