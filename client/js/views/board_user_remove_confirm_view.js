/**
 * @fileOverview This file has functions related to board user delete view. This view calling from board user view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardUserRemoveConfirm View
 * @class BoardUserRemoveConfirmView
 * @constructor
 * @extends Backbone.View
 */
App.BoardUserRemoveConfirmView = Backbone.View.extend({
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
    template: JST['templates/board_user_remove_confirm'],
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
            board_user: this.model
        }));
        this.showTooltip();
        return this;
    }
});
