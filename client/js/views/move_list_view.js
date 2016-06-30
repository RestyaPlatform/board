/**
 * @fileOverview This file has functions related to move list form view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list model. @see Available Object in App.ListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * MoveCardsFromList View
 * @class MoveCardsFromListView
 * @constructor
 * @extends Backbone.View
 */
App.MoveListFromView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.boards = options.boards;
        this.total_board_list_length = options.total_board_list_length;
        this.render();
    },
    template: JST['templates/move_list'],
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
            list: this.model,
            boards: this.boards,
            total_board_list_length: this.total_board_list_length
        }));
        this.showTooltip();
        return this;
    }
});
