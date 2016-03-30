/**
 * @fileOverview This file has functions related to show board member permission form view. This view calling from board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board user id.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * showBoardMemberPermissionForm View
 * @class showBoardMemberPermissionFormView
 * @constructor
 * @extends Backbone.View
 */
App.showBoardMemberPermissionFormView = Backbone.View.extend({
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
    template: JST['templates/show_board_member_permission_form'],
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
            board_user_id: this.model,
        }));
        this.showTooltip();
        return this;
    }
});
