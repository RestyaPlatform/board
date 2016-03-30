/**
 * @fileOverview This file has functions related to edit board member permission to normal view. This view calling from board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board user ID.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UserCards View
 * @class UserCardsView
 * @constructor
 * @extends Backbone.View
 */
App.EditBoardMemberPermissionToNormal = Backbone.View.extend({
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
    template: JST['templates/edit_board_member_permission_to_normal'],
    tagName: 'div',
    className: 'clearfix',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            board_user_id: this.model,
        }));
        this.showTooltip();
        return this;
    }
});
