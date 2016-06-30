/**
 * @fileOverview This file has functions related to checklist item mention member view. This view calling from card checklist item view and card checklist view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: checklist item model. It contain all card checklist item object @see Available Object in App.CardCheckListItemView
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
App.ChecklistItemMentionMemberView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.class_name = options.class_name;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/checklist_item_mention_member'],
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            board_user: this.model,
            class_name: this.class_name
        }));
        this.showTooltip();
        return this;
    }
});
